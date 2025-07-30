clear all;               % Clears all active variables
close all;

% Load the ECG signal from the file
ecg = load('ecg_hfn.dat'); % Make sure 'ecg_hfn.dat' is in the current directory
fs = 1000;               % Sampling rate (200 Hz)

% Length of the ECG signal
slen = length(ecg);

% Time vector
t = (1:slen) / fs;

% Plot the original ECG signal
figure(1);
subplot(2,1,1);
plot(t, ecg);
title('Tín hiệu ECG ban đầu');
xlabel('Time in seconds');
ylabel('ECG');
axis tight;

% Low-pass filter parameters
             % Cutoff frequency (in Hz)
ripple = 3;            % Ripple in the passband (not used for Butterworth)
attenuation = 40;      % Attenuation in the stopband (not used for Butterworth)
% Calculate the normalized passband and stopband frequencies
Wn_pass = 40 / (fs / 2);        % Normalized passband frequency
Wn_stop = 100/(fs/2);                  % Normalized stopband frequency (adjust as needed)

% Calculate the order of the filter using buttord
[order, Wn] = buttord(Wn_pass, Wn_stop, ripple, attenuation);

% Design the Butterworth low-pass filter
[b, a] = butter(order, Wn, 'low'); % Filter coefficients

% Apply the filter using zero-phase filtering
filtered_ecg = filtfilt(b, a, ecg);

% Plot the filtered ECG signal
subplot(2,1,2);
plot(t, filtered_ecg);
title('Tín hiệu ECG sau khi lọc thấp');
xlabel('Time in seconds');
ylabel('Filtered ECG');
axis tight;
[rep1, com1, sigNum] = scorer12(filtered_ecg, 1000);
kurtosis_filtered = kurtosis(filtered_ecg);

% Calculate Power Spectral Density (PSD) for original ECG
N = length(ecg);
xdft = fft(ecg);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2 * psdx(2:end-1);
freq = 0:fs/length(ecg):fs/2;

figure(2);
subplot(2,1,1);
plot(freq, pow2db(psdx));
grid on;
title("PSD của tín hiệu ban đầu");
xlabel("Frequency (Hz)");
ylabel("Power/Frequency (dB/Hz)");

% Calculate PSD for filtered ECG
N1 = length(filtered_ecg);
xdft = fft(filtered_ecg);
xdft = xdft(1:N1/2+1);
psdx_filtered = (1/(fs*N1)) * abs(xdft).^2;
psdx_filtered(2:end-1) = 2 * psdx_filtered(2:end-1);
freq_filtered = 0:fs/length(filtered_ecg):fs/2;

subplot(2,1,2);
plot(freq_filtered, pow2db(psdx_filtered));
grid on;
title("PSD của tín hiệu sau khi lọc");
xlabel("Frequency (Hz)");
ylabel("Power/Frequency (dB/Hz)");

% Frequency response of the Butterworth filter
LPFreqResponse = figure('Name', 'Đáp ứng pha-tần số của bộ lọc'); % Create a new figure
freqz(b, a, 512, fs);
title('Đáp ứng pha - tần số của bộ lọc');

% Pole-Zero diagram of the Butterworth filter
LPZPlane = figure('Name', 'Butterworth Low-Pass Filter - Pole-Zero diagram'); % Create a new figure
pzmap(tf(b, a));
title('Biểu đồ cực-zero của bộ lọc');
