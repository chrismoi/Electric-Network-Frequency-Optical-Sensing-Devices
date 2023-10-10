%fastfourier ( y, Fs, db)
%fft of y with sampling frequency Fs
%if db = 1 then plot in db 
%if pl = 'y' then plot the result
function [Y,f]=fastfourier ( y, Fs , db, pl );
Fs;                     % Sampling frequency
T = 1/Fs;                     % Sample time
L = length(y);                 % Length of signal
t = (0:L-1)*T;                % Time vector
y = y;


NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

Y=2*abs(Y(1:NFFT/2+1));
%Plot single-sided amplitude spectrum.
if (pl == 'y')
    if ( db == 1 )
	plot(f,mag2db(Y)) 
    else plot(f,Y) 
    end
    xlabel('Frequency (Hz)')
    ylabel('Amplitude')
end
end