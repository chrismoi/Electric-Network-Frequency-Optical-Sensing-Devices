%% Find audio device identifier ID for input
info = audiodevinfo
info.input(3)
%% 2 Channel stereo recording
% Audio jack set as line input
% CH1: power mains, CH2: photodiode
recObj = audiorecorder(1000,16,2,2);

formatOut = 'yyyy/mm/dd HH:MM:SS.FFF';
timestamp = datestr(now,formatOut)
fid = fopen(strcat('ENF_2CH_',datestr(now,'dd_mm_yyyy'),'.csv'), 'wt');

disp('Start of recording')
recordblocking(recObj, 5); % 10800 3hours
disp('End of Recording.');

myRecording = getaudiodata(recObj);

disp('Writing .wav file');
% Write to .wav
audiowrite('ENF_2CH.wav',myRecording,1);
disp('Done');

disp('Writing .csv file');
% Write to .csv
dlmwrite(strcat('ENF_2CH_',datestr(now,'dd_mm_yyyy'),'.csv'),...
    myRecording,'-append');
disp('Done');
fclose(fid);

% Plot the first 10 seconds of the recording
plot(myRecording);
axis([0 10000 -1 1])