%% experiment a)
clc;clear;
% Run SLIC function or load the array directly
% y = SLIC('GX011768M.MP4');
load('experiment_a\y.mat')

% Load ground truth ENF from power mains
% and ENF from the photodiode using spectrum combining
load('experiment_a\GT_mains.mat')
load('experiment_a\GT_pd_spectrum_combining.mat')
GT_pd_sc = f_MLE;

% Alias frequency limits
F_pass1 = 9.99;
F_pass2= 10.19;
Fs=30;
nffttimes=4;

% filter orders N
ordervals=[111, 311]; 
nn = numel(ordervals);
%% STFT
a=1;
for i=1:nn
    k=1;
    for framesec=1:1:60
        
        N = ordervals(i);
        % data filtering
        data_filtered=bpfilt(y,Fs,F_pass1,F_pass2,N);

        % Video ENF estimation using STFT
    	ENF_video = enfestSTFT(data_filtered,framesec,...
            nffttimes,Fs);

        % Matching procedure
    	[MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_mains,ENF_video);
        results_mains(a,k)=MCC(1,2);

        [MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_pd_sc,ENF_video); 
        results_pd(a,k)=MCC(1,2);
        k=k+1;
    end
    a=a+1;
end

framesec_axis = 1:1:60;
figure
plot(framesec_axis,results_mains(1,:));
hold on
plot(framesec_axis,results_mains(2,:),'-o');
plot(framesec_axis,results_pd(1,:),'-x');
plot(framesec_axis,results_pd(2,:),'--');
grid on
xlabel('Segment duration D (s)','Fontsize',14)
ylabel('MCC','Fontsize',14)
legend('ENF mains \nu=111','ENF mains \nu=311','ENF pd \nu=111',...
    'ENF pd \nu=311')
ylim([0.55 1]);
title('Experiment a) ENF estimation using STFT')
set(gcf, 'Position',  [100, 100, 800, 400])

%% ESPRIT
a=1;
for i=1:nn
    k=1;
    for framesec=1:1:60
        
        N = ordervals(i);
        data_filtered=bpfilt(y,Fs,F_pass1,F_pass2,N); 

        ENF_video = enfestESPRIT(data_filtered,framesec,...
            nffttimes,Fs);

    	[MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_mains,ENF_video);  
        results_mains(a,k)=MCC(1,2);

        [MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_pd_sc,ENF_video);
        results_pd(a,k)=MCC(1,2);
        k=k+1;
    end
    a=a+1;
end

framesec_axis = 1:1:60;
figure
plot(framesec_axis,results_mains(1,:));
hold on
plot(framesec_axis,results_mains(2,:),'-o');
plot(framesec_axis,results_pd(1,:),'-x');
plot(framesec_axis,results_pd(2,:),'--');
grid on
xlabel('Segment duration D (s)','Fontsize',14)
ylabel('MCC','Fontsize',14)
legend('ENF mains \nu=111','ENF mains \nu=311',...
    'ENF pd \nu=111','ENF pd \nu=311')
ylim([0.55 1]);
title('Experiment a) ENF estimation using ESPRIT')
set(gcf, 'Position',  [100, 100, 800, 400])

%% experiment b)
clc;clear;
% Run SLIC function or load the array directly
load('experiment_b\y.mat')
% y = SLIC('GX011769M.MP4');

load('experiment_b\GT_mains.mat')
load('experiment_b\GT_pd_spectrum_combining.mat')
GT_pd_sc = f_MLE;

F_pass1 = 9.99;
F_pass2= 10.19;
Fs=30;
nffttimes=4;

%% ESPRIT
ordervals=[51, 111];
nn = numel(ordervals);
a=1;
for i=1:nn
    k=1;
    for framesec=1:4:150
        
        N = ordervals(i);
        data_filtered=bpfilt(y,Fs,F_pass1,F_pass2,N);
        ENF_video = enfestESPRIT(data_filtered,framesec,...
            nffttimes,Fs);

    	[MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_mains,ENF_video);
        results_mains(a,k)=MCC(1,2);

        [MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_pd_sc,ENF_video);
        results_pd(a,k)=MCC(1,2);
        k=k+1;
    end
    a=a+1;
end

framesec_axis = 1:4:150;
figure
plot(framesec_axis,results_mains(1,:));
hold on
plot(framesec_axis,results_mains(2,:),'-o');
plot(framesec_axis,results_pd(1,:),'-x');
plot(framesec_axis,results_pd(2,:),'--');
grid on
xlabel('Segment duration D (s)','Fontsize',14)
ylabel('MCC','Fontsize',14)
legend('ENF mains \nu=51','ENF mains \nu=111','ENF pd \nu=51',...
    'ENF pd \nu=111')
ylim([0 1]);
title('Experiment b) ENF estimation using ESPRIT')
set(gcf, 'Position',  [100, 100, 800, 400])

%% STFT
ordervals=[111, 311, 511];
nn = numel(ordervals);
a=1;
for i=1:nn
    k=1;
    for framesec=1:4:150
        
        N = ordervals(i);
        data_filtered=bpfilt(y,Fs,F_pass1,F_pass2,N);
    	ENF_video = enfestSTFT(data_filtered,framesec,...
            nffttimes,Fs);

    	[MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_mains,ENF_video);
        results_mains(a,k)=MCC(1,2);

        [MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_pd_sc,ENF_video);
        results_pd(a,k)=MCC(1,2);
        k=k+1;
    end
    a=a+1;
end

framesec_axis = 1:4:150;
figure
plot(framesec_axis,results_mains(1,:));
hold on
plot(framesec_axis,results_mains(2,:),'-o');
plot(framesec_axis,results_mains(3,:),'-*');
plot(framesec_axis,results_pd(1,:),'-x');
plot(framesec_axis,results_pd(2,:),'--');
plot(framesec_axis,results_pd(3,:),'-+');
grid on
xlabel('Segment duration D (s)','Fontsize',14)
ylabel('MCC','Fontsize',14)
legend('ENF mains \nu=111','ENF mains \nu=311',...
    'ENF mains \nu=511','ENF pd \nu=111',...
    'ENF pd \nu=311','ENF pd \nu=511')
title('Experiment b) ENF estimation using STFT')
set(gcf, 'Position',  [100, 100, 800, 400])

%% experiment c)
clc;clear;
% Run SLIC function or load the array directly
% y = SLIC('GX011765M.MP4');
load('experiment_c\y.mat')

% Load GT_mains_spectrum_combining.mat
% and GT_pd_spectrum_combining.mat
load('experiment_c\GT_mains_spectrum_combining.mat')
load('experiment_c\GT_pd_spectrum_combining.mat')
GT_mains = f_ref;
GT_pd_sc = f_MLE;

% Base aliased, wide
base_alias = [9.99 10.19];

Fs=30;
nffttimes=4;

%% ESPRIT
ordervals=[51,211];
nn = numel(ordervals);
a=1;
for i=1:nn
    k=1;
    for framesec=1:4:120
        
        N = ordervals(i);
        data_filtered=bpfilt(y,Fs,base_alias(1), base_alias(2),N);  

        ENF_video = enfestESPRIT(data_filtered,framesec,...
            nffttimes,Fs);

    	[MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_mains,ENF_video);  
        results_mains(a,k)=MCC(1,2);

        [MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_pd_sc,ENF_video); 
        results_pd(a,k)=MCC(1,2);
        k=k+1;
    end
    a=a+1;
end

framesec_axis = 1:4:120;
figure
plot(framesec_axis,results_mains(1,:));
hold on
plot(framesec_axis,results_mains(2,:),'-o');
plot(framesec_axis,results_pd(1,:),'-x');
plot(framesec_axis,results_pd(2,:),'--');
grid on
xlabel('Segment duration D (s)','Fontsize',14)
ylabel('MCC','Fontsize',14)
legend('ENF mains \nu=51','ENF mains \nu=211','ENF pd \nu=51',...
    'ENF pd \nu=211')
ylim([0.1 1]);
title('Experiment c) ENF estimation using ESPRIT')
set(gcf, 'Position',  [100, 100, 800, 400])

%% STFT
ordervals=[111,211,511];
nn = numel(ordervals);
a=1;
for i=1:nn
    k=1;
    for framesec=1:4:150
        
        N = ordervals(i);
        data_filtered=bpfilt(y,Fs,base_alias(1), base_alias(2),N);

    	ENF_video = enfestSTFT(data_filtered,framesec,...
            nffttimes,Fs);

        [MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_pd_sc,ENF_video); 
        results_pd(a,k)=MCC(1,2);
        k=k+1;
    end
    a=a+1;
end

framesec_axis = 1:4:150;
figure
plot(framesec_axis,results_pd(1,:),'-x');
hold on
plot(framesec_axis,results_pd(2,:),'--');
plot(framesec_axis,results_pd(3,:),'-+');
grid on
xlabel('Segment duration D (s)','Fontsize',14)
ylabel('MCC','Fontsize',14)
legend('ENF pd \nu=111','ENF pd \nu=211','ENF pd \nu=511')
ylim([0.1 0.7]);
title('Experiment c) ENF estimation using STFT')
set(gcf, 'Position',  [100, 100, 800, 400])

%% experiment d)
clc;clear;
% Run SLIC function or load the array directly
% y = SLIC('GX011766M.MP4');
load('experiment_d\y.mat')

% Load GT_mains_spectrum_combining.mat
% and GT_pd_spectrum_combining.mat
load('experiment_d\GT_mains_spectrum_combining.mat')
load('experiment_d\GT_pd_spectrum_combining.mat')
GT_mains = f_ref;
GT_pd_sc = f_MLE;

% Base aliased, narrow
narrow_base_alias = [10.04 10.14];

Fs=30;
nffttimes=4;

%% ESPRIT
ordervals=[51,211,511];
nn = numel(ordervals);
a=1;
for i=1:nn
    k=1;
    for framesec=1:4:120
        
        N = ordervals(i);
        data_filtered=bpfilt(y,Fs,narrow_base_alias(1),...
            narrow_base_alias(2),N);

        ENF_video = enfestESPRIT(data_filtered,framesec,...
            nffttimes,Fs);

    	[MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_mains,...
            ENF_video);   
        results_mains(a,k)=MCC(1,2);

        [MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_pd_sc,...
            ENF_video);   
        results_pd(a,k)=MCC(1,2);
        k=k+1;
    end
    a=a+1;
end

framesec_axis = 1:4:120;
figure
plot(framesec_axis,results_mains(1,:));
hold on
plot(framesec_axis,results_mains(2,:),'-o');
plot(framesec_axis,results_mains(3,:),'-*');
plot(framesec_axis,results_pd(1,:),'-x');
plot(framesec_axis,results_pd(2,:),'--');
plot(framesec_axis,results_pd(3,:),'-+');
grid on
xlabel('Segment duration D (s)','Fontsize',14)
ylabel('MCC','Fontsize',14)
legend('ENF mains \nu=51','ENF mains \nu=211',...
    'ENF mains \nu=511','ENF pd \nu=51',...
    'ENF pd \nu=211','ENF pd \nu=511')
ylim([0.4 0.1]);
title(['Experiment d) ENF estimation using ESPRIT'])
set(gcf, 'Position',  [100, 100, 800, 400])

%% STFT
ordervals=[111,211,311];
nn = numel(ordervals);
a=1;
for i=1:nn;
    k=1;
    for framesec=1:4:140
        
        N = ordervals(i);
        data_filtered=bpfilt(y,Fs,narrow_base_alias(1),...
            narrow_base_alias(2),N);
    	ENF_video = enfestSTFT(data_filtered,framesec,...
            nffttimes,Fs);

    	[MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_mains,ENF_video);   
        results_mains(a,k)=MCC(1,2);

        [MCC,MCC_ind,MSDE,MSDE_ind] = match(GT_pd_sc,ENF_video);   
        results_pd(a,k)=MCC(1,2);
        k=k+1;
    end
    a=a+1;
end

framesec_axis = 1:4:140;
figure
plot(framesec_axis,results_mains(1,:));
hold on
plot(framesec_axis,results_mains(2,:),'-o');
plot(framesec_axis,results_mains(3,:),'-*');
plot(framesec_axis,results_pd(1,:),'-x');
plot(framesec_axis,results_pd(2,:),'--');
plot(framesec_axis,results_pd(3,:),'-+');
grid on
xlabel('Segment duration D (s)','Fontsize',14)
ylabel('MCC','Fontsize',14)
legend('ENF mains \nu=111','ENF mains \nu=211',...
    'ENF mains \nu=311','ENF pd \nu=111',...
    'ENF pd \nu=211','ENF pd \nu=311')
ylim([0.4 0.85]);
title(['Experiment d) ENF estimation using STFT'])
set(gcf, 'Position',  [100, 100, 800, 400])