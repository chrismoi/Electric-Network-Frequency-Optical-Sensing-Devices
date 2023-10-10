function [ centralFrequency,fmax, fc ] = basicFrequency( x )
% A function to calculate the basic Network frequency of a given power 
%signal
% Input is the singal x, and output is the estimated frequency
Fs=1000;
[X,f] = fastfourier(x,Fs,0,'n');
Y=0;fc=0;
for(j = 1:4)
    
    i50 = floor(length(f)*[ 49*j, j*51]/Fs*2);
    i60 = floor(length(f)*[ 59*j, j*61]/Fs*2);
    
    Y = [Y;X(i50(1):i50(2));X(i60(1):i60(2))];
    fc= [fc,f(i50(1):i50(2)),f(i60(1):i60(2))];
    
end

[~,i]= max(Y);
fc = fc(i);
if( min(abs(fc - [60,120,180,240]))<min(abs(fc - [50,100,150,200])))
    centralFrequency = 60;
else centralFrequency =50;
end
fmax = fc;
fc = fc/round(fc/centralFrequency);
end

