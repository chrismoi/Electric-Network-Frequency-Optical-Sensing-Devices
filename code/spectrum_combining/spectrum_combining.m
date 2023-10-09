function [f_mains, f_pd] = spectrum_combining(mains, photodiode)
%% parameter setting and initialization
% constant sampling frequency
FS                       = 800; 
% constant value for ENF harmonic processing
HARMONIC_INDEX           = [2,3,4,5,6,7]; 
% nominal frequencies at each harmonic
fc                       = 50*HARMONIC_INDEX;
% tolerable IF deviations at each harmonic
bound                    = 0.1*HARMONIC_INDEX; 
filter_length            = 256;
[BPF_coeffs, coeffs_2nd] = func_BPF(filter_length);

fs_rec = 1000;
ref = mains';
raw_wave = resample(photodiode', FS, fs_rec);

%% bandpass filtering
input             = filtfilt(BPF_coeffs,1,raw_wave); 

%% ENF estimators 
% set up parameters for frame-based processing
% duration of overlapping frame in second
window_dur        = 16; 
% frame step-size usually 1 second
step_size_dur     = 1; 
% FFT resolution = 1/FFT_res_factor Hz
FFT_res_factor    = 2000; 
% reference ENF
f_mains         = func_STFT_single_tone(ref,fs_rec,...
    window_dur,step_size_dur,fc(1),bound(1),FFT_res_factor);

%% 3. implementation of [1]: search within sum of harmonic
%     components, mapped to 2nd harmonic
% [1] D. Bykhovsky and A. Cohen, "Electrical network frequency
%     (ENF) maximum-likelihood estimation via a multitone harmonic
%     model," IEEE Trans. Inf. Forensics Security, vol. 8, no. 5,
%     pp. 744�C753, May 2013.

% for fair comparison use doubled FFT length to ensure consistent
% search grid at 2nd harmonic.
f_pd         = func_STFT_multi_tone_search(input,FS,window_dur,...
    step_size_dur,fc,bound,2*FFT_res_factor);

MSE_MLE          = 1/length(f_mains)*norm(f_pd-f_mains).^2;
mean(MSE_MLE)
corrcoef(f_pd, f_mains)

end