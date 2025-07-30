% MATLAB PROGRAM ecg2x60.m
clear all               % clears all active variables
close all

% the ECG signal in the file is sampled at 200 Hz
ecg = load('noisy_signal.dat');
fs = 200; %sampling rate
slen = length(ecg);
t=[1:slen]/fs;
figure(1)
subplot(2,1,1);
plot(t, ecg)
title('Tín hiệu ECG ban đầu')
xlabel('Time in seconds');
ylabel('ECG');
axis tight;

windowSize = 8; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
y = filter(b,a,ecg);
subplot(2,1,2);
plot(t,y)
title('Tín hiệu ECG sau khi lọc')
xlabel('Time in seconds');
ylabel('ECG');

N = length(ecg);
xdft = fft(ecg);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(ecg):fs/2;
figure(2)
subplot(2,1,1)
plot(freq,pow2db(psdx))
grid on
title("PSD của tín hiệu ban đầu")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (dB/Hz)")
N1=length(y)
xdft = fft(y);
xdft = xdft(1:(N1)/2+1);
psdx = (1/(fs*N1)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(y):fs/2;
subplot(2,1,2)
plot(freq,pow2db(psdx))
grid on
title("PSD của tín hiệu sau khi lọc")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (dB/Hz)")

LPFreqResponse = figure('Name','Đáp ứng pha-tần số của bộ lọc'); % Create a new figure
freqz(b,a, 512, 200);
title('Đáp ứng pha - tần số của bộ lọc');

LPZPlane = figure('Name','Von Hann lowpass ﬁlter - Pole-Zero diagram of the filter'); % Create a new figure
zplane(b,a)
title('Biểu đồ cực-zero của bộ lọc');
