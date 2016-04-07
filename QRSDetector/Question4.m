clc; clear;
% Load relevant data from file
data = load('Midterm_Dataset-2.mat');
data.Fs(end-1:end) = [];
Fs = str2double(data.Fs);
dt = 1/Fs;

ecg = data.ecg;
emg = data.emg;
qrs = data.qrs;
N = length(emg);
time = dt*(0:N-1)';
df = Fs/N;
frequency = (-Fs/2:df:Fs/2-df)';

% moving average canceling the DC drift 
ecg = ecg - mean(ecg);

% discrete fourier transform 
spectrum = fftshift(fft(ecg))/N;
figure();
plot(frequency, abs(spectrum));
title('Power Sectrum Density FFT')
xlabel('Frequency')
ylabel('Power/Amplitude')

% Parseval power theorm
figure();
plot(frequency, (1/(Fs*N))*abs(spectrum).^2);
title('Parseval Theorm FFT')
xlabel('Frequency')
ylabel('Power/Amplitude')

% periodogram power spectrum density 
figure();
periodogram(ecg,rectwin(N),N,Fs)
grid on
title('Periodogram Using FFT')
xlabel('Frequency')
ylabel('Power/Amplitude')