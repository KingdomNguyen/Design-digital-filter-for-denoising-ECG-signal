% MATLAB PROGRAM ecg2x60.m
clear all               % clears all active variables
close all

% the ECG signal in the file is sampled at 200 Hz
ecg = load('ecg_lfn.dat');
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

DFa(1) = 1;
DFa(2) = -0.995;
DFb(1) = 1;
DFb(2) = -1;

% normalize gain at z=-1 to 1
% H(z) = G (1 - z^-1) / (1 - 0.995z^-1)
% H(z=-1) = 1 = G (1 - (-1) / ( 1 - 0.995(-1)
% 1 = G * (2 / 1.9950)
DFGain = 0.9975;
DFb = DFb * DFGain; % combine into b coefficients

% Filter the ECG signal
y = filter(DFb, DFa, ecg);
subplot(2,1,2);
plot(t, y)
title('Tín hiệu ECG sau lọc')
xlabel('Time in seconds');
ylabel('ECG');
axis tight;

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
N1=length(y);
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
freqz(DFb,DFa, 512, 200);
title('Đáp ứng pha - tần số của bộ lọc');

LPZPlane = figure('Name','Von Hann lowpass ﬁlter - Pole-Zero diagram of the filter'); % Create a new figure
zplane(DFb,DFa)
title('Biểu đồ cực-zero của bộ lọc');
