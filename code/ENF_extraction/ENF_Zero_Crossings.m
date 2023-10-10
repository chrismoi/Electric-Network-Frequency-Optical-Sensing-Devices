function [ enf ] = ENF_ZC(x, fs, wlen , hop )
%Calculates the enf signal for the input recording x
%Inputs:	x: the recording 
%			Fs: sampling frequency of the recording x
%			wlen: the length of each frame
%			hop: Overlapping of the frames is wlen-hop
%Output:	enf: is the calculated enf
		
x = x/max(x);   % normalize the signal
        
[~,fc] = basicFrequency(x);   %the basic Frequency of the recording x
       
h = waitbar(0);

% filtering of the recording, around the basic frequency
l = length(x);
[b, a] = butter(2, [(fc-5)/500 (fc+5)/500]);
x = filter(b, a, x);
x = x(1:l);
%-------------------------

slices = floor(length(x)/hop - (wlen-hop)/hop); % number of frames of the recording x
f = [fc,zeros(1,slices)] ;% initialize frequency Vector
    
for i = 2:slices+1
	waitbar(i/(length(x)/hop - (wlen-hop)/hop) ,h,'Calculating using Zero Crossings');
			
	%z is a frame that corresponds to wlen/4096 seconds
    z = x((i-2)*wlen-(i-2)*(wlen-hop)+1:(i-1)*wlen-(i-2)*(wlen-hop)); 
    f(i) = zeroCrossings(z, 1/fs); % calculate the max frequency of z using zero crossings method
end

enf = zeros(1,length(f(3:end)));
enf(1,:) = f(3:end);
close(h);
end

