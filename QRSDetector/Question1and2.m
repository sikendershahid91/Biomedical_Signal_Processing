clc;
clear;

% selecting file
disp('Load a subject file by selecting number.')
disp('1: subject 1 - ecg_sbj1.m')
disp('2: subject 2 - ecg_sbj2.m')
disp('3: subject 3 - ecg_sbj3.m')
disp('4: subject 4 - ecg_sbj4.m')
subject = input('Pick number from 1 to 4: ');
switch subject
  case 1
    fileName = 'ecg_sbj1.mat';
  case 2
    fileName = 'ecg_sbj2.mat';
  case 3
    fileName = 'ecg_sbj3.mat';
  case 4
    fileName = 'ecg_sbj4.mat';
end
%-------------------------------------------------------------------------------

% Load relevant data from file
data = load(fileName);
data.Fs(end-1:end) = [];
Fs = str2double(data.Fs);
dt = 1/Fs;
rawEcg = data.ecg(1+(end-(60/dt)):1:end);
N = length(rawEcg);
time = dt*(0:N-1)';

% normalize the data set
ecg = (rawEcg - min(rawEcg)) / (max(rawEcg) - min(rawEcg));

figure();
plot(time, ecg, 'b');
xlim([0 10]);
title('Normalized Ecg Data');
xlabel('Seconds');
ylabel('Amplitude');

% first high pass difference digital filter
filtered_ecg= zeros(N,1);
for i=5:N
    filtered_ecg(i)= ecg(i)-ecg(i-4);
end

% second low pass difference digital filter
filtered_ecg2=zeros(N,1);
for n=5:N
    filtered_ecg2(n) = filtered_ecg(n) + 4*filtered_ecg(n-1) + 6*filtered_ecg(n-2) + 4*filtered_ecg(n-3) + filtered_ecg(n-4);
end

% three point moving average
filtered_ecg3=zeros(N,1);
for n=2:N-1
    filtered_ecg3(n) = (filtered_ecg2(n-1) + 2*filtered_ecg2(n) + filtered_ecg2(n+1))/4;
end

% simple smoothing window
filtered_ecg4 = tsmovavg(filtered_ecg3,'s',10,1);

% calculate peaks
Rpeak=0;
RpeakIndices = zeros(N,1);
for n=2:N-1
    if( filtered_ecg4(n)>filtered_ecg4(n-1) && filtered_ecg4(n)>filtered_ecg4(n+1) && filtered_ecg4(n)>max(filtered_ecg4)*(3/4))
        Rpeak = Rpeak +1;
        RpeakIndices(Rpeak) = n;
    end
end


figure();
plot(time,rawEcg, 'b');
title('RawEcg(Blue) vs FilteredEcg(Red)')
xlabel('Seconds');
ylabel('Amplitude');
hold
plot(time,filtered_ecg4, 'r');

%Question1 Main plot
figure();
plot(time(RpeakIndices(1):RpeakIndices(2)),filtered_ecg4(RpeakIndices(1):RpeakIndices(2)));
title('Question 2: RR - interval');
xlabel('Seconds');
ylabel('Amplitude');
disp('**********************');
disp('Heart beats per minute');
disp(Rpeak);

%--------------------------------------------------------------------------
%Question2

%RR peaks left and right
averageEcg = zeros(50+70+2, 1);
count = 1;
for n = RpeakIndices
    count = 1;
    for m = n-50:1:n+70
        averageEcg(count) = averageEcg(count) + filtered_ecg(m);
        count = count + 1;
    end
end
averageEcg = averageEcg./count-1;
averageEcg = tsmovavg(averageEcg,'s',6,1);


figure()
plot(averageEcg)
