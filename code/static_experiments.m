%% Plot Figure 4
clc;clear;
% Video duration (minutes)
duration = 1:1:8;

% Estimate ENF for mains and photodiode using spectrum combining
enf_recordings = audioread('4.exp_HAL_200cm_wall\ENF_2CH.wav');
[enf_mains_HAL, enf_pd_HAL] = ...
    spectrum_combining(enf_recordings(:,2), enf_recordings(:,1));

enf_recordings = audioread('24.exp_INC_200cm_wall\ENF_2CH.wav');
[enf_mains_INC, enf_pd_INC] = ...
    spectrum_combining(enf_recordings(:,2), enf_recordings(:,1));

enf_mains = [enf_mains_HAL; enf_mains_INC];
enf_pd = [enf_pd_HAL; enf_pd_INC];

% Split photodiode signal in g = 1,2,...,8 min segments
size = numel(enf_pd_HAL);
step = round(size/8);
      
k=0;
% For every segment try to find a match with the ground truth
for i=step:step:size
    i;
    k=k+1;

    clear ENF

    ENF = enf_pd(1,1:i);
    [MCC,MCC_ind,MSDE,MSDE_ind] = match(enf_mains(1,:),ENF);
    pd_vs_mains(1,k) = MCC(1,2);

    ENF = enf_pd(2,1:i);
    [MCC,MCC_ind,MSDE,MSDE_ind] = match(enf_mains(2,:),ENF);
    pd_vs_mains(2,k) = MCC(1,2);
end

% load light intensity arrays directly or calculate from scratch
y_HAL = load('4.exp_HAL_200cm_wall\y.mat').y;
y_INC = load('24.exp_INC_200cm_wall\y.mat').y;
% y_HAL = SLIC('4.exp_HAL_200cm_wall\GH011064M.MP4');
% y_INC = SLIC('24.exp_INC_200cm_wall\GH011142M.MP4');

if length(y_HAL) < length(y_INC)
    y_INC = (y_INC(1:length(y_HAL)));
else
    y_HAL = (y_HAL(1:length(y_INC)));
end

y_all = [y_HAL; y_INC];
% Split video in g = 1,2,...,8 min segments
size = numel(y_HAL);
step = round(size/8);

k=0;
F_pass1 = 9.7;
F_pass2= 10.3;
framesec = 17;
N=511;
Fs=30;
nffttimes=4;
% For every video clip estimate ENF using BTSE
% and try to find a match with the ground truth
for i=step:step:size
    i;
    k=k+1;

    clear ENF

    y = y_all(1,1:i);
    data_filtered=bpfilt(y,Fs,F_pass1,F_pass2,N); 
	ENF_video = enfestBTSE(data_filtered,framesec,nffttimes,Fs);

    [MCC,MCC_ind,MSDE,MSDE_ind] = match(enf_mains(1,:),ENF_video);
    video_vs_mains(1,k) = MCC(1,2);

    y = y_all(2,1:i);
    data_filtered=bpfilt(y,Fs,F_pass1,F_pass2,N);
	ENF_video = enfestBTSE(data_filtered,framesec,nffttimes,Fs);

    [MCC,MCC_ind,MSDE,MSDE_ind] = match(enf_mains(2,:),ENF_video);
    video_vs_mains(2,k) = MCC(1,2);
end

plot(duration, video_vs_mains(1,:), '-x');
hold on;
plot(duration, video_vs_mains(2,:), '-*');
plot(duration, pd_vs_mains(1,:), '-o');
plot(duration, pd_vs_mains(2,:), '-+');

grid on;
xlabel('Video duration D (m)','Fontsize',14);
ylabel('MCC','Fontsize',14);
legend('camera (Halogen)','camera (Incandescent)',...
    'photodiode (Halogen)', 'photodiode (Incandescent)')
ylim([0.9 1]);
