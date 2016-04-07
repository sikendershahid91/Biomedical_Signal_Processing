clc;clear;
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

% removing by sync average
% ecg extraction
averageEcg = zeros(50+70+2, 1);
for n = qrs
    count = 1;
    for m = n-50:1:n+70
        averageEcg(count) = averageEcg(count) + ecg(m);
        count = count + 1;
    end
end
figure();
plot(averageEcg);
title('QRS averaging');

averageEcg = averageEcg./count-1;
averageEcg = tsmovavg(averageEcg,'s',6,1);
averageEcg = averageEcg';

extendedEcg = zeros(1, 8192);
for n=1:8192
    if count == 122
        count = 1;
    end
    extendedEcg(n) = averageEcg(count);
    count = count +1;
end
figure();
plot(time, extendedEcg);
title('Ecg from QRS indicies')
xlabel('Seconds');
ylabel('Amplitude');

% 3a
Ryx_a = cov(emg, extendedEcg);
Rxx_a = cov(extendedEcg, extendedEcg);
if(isnan(Rxx_a(1,1)))
    Rxx_a(1,1) = 1;
end
GainRatio = Ryx_a(1,1)/Rxx_a(1,1);
filtered_emg_using_qrs = emg - GainRatio*extendedEcg;
figure();
plot(time, filtered_emg_using_qrs);
title('Filtered EMG from QRS')
xlabel('Seconds');
ylabel('Amplitude');

% 3b
Rxx_b = cov(ecg, ecg);
Ryx_b = cov(emg, ecg);
if(isnan(Rxx_b(1,1)))
    Rxx_b(1,1) = 1;
end
GainRatio = Ryx_b(1,1)/Rxx_b(1,1);
filtered_emg_using_ecg = emg - GainRatio*ecg;
figure();
plot(time, filtered_emg_using_ecg);
title('Filtered EMG from ECG recording')
xlabel('Seconds');
ylabel('Amplitude');

compare_a_b = cov(filtered_emg_using_ecg, filtered_emg_using_qrs);
disp('covariance of solution a and b:');
disp(compare_a_b(1,1));
