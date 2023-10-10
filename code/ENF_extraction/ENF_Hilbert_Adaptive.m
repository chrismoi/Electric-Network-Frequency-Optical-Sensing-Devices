function [ enf ] = ENF_Hilbert_Adaptive( x, fs, frameLength, range )
%ENF_Hilbert_Adaptive Hilbert transform based ENF extraction method
%   This function outputs the estimated ENF of input signal using an
%   adaptive Hilbert transform technique. It uses a hanning window to
%   extract frames from the input signal and uses a 2nd order band-pass
%   Butterworth filter to isolate the higher harmonic. After the Hilbert 
%   transform is computed, the resulting phase is differentiated in order
%   to produce the instantaneous frequency. The estimated frequency for the
%   corresponding frame is computed as the mean of the instantaneous
%   frequencies that are within the specified range. This frequency is
%   then mapped to the respective first harmonic. The passband of the 
%   Butterworth filter changes at each iteration, and is centered around
%   the frequency computed for the last frame.
%   Inputs:
%   - x             : signal to extract ENF from
%   - fs            : sampling frequency
%   - frameLength   : length of frames
%   - range         : frequency range
%% pre-filtering
[cf, fc] = basicFrequency(x);
y = x;
harm = round(fc / cf);
%% emd
len = round(length(x)/frameLength) - 1;
freq = zeros(len, 1);
Ts = 1/fs;

for seg = 1:len
    frame = y((seg-1) * frameLength + 1 : seg * frameLength);
    [b, a] = butter(2, [(fc-range/2)/(fs/2) (fc+range/2)/(fs/2)]);
    frame = filter(b, a, frame);
    th = angle(hilbert(frame));
    th = unwrap(th);
    d = diff(th)/Ts/(2*pi);
    freq(seg) = mean(d(abs(d - fc) <= range)) / harm;
    fc = freq(seg) * harm;
end
enf = freq;
end

