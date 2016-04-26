clc; clear;
EEG_DATA = load('Sbj2_Finger_Movement_EEG_All_Labels.mat');

% Seting up variables.
% Fs=250Hz; Data was recorded starting 3sec before the onset of the movement.
% eeg=[Samples x Trials x Channel]; Ch1=C3, Ch2=C4; LeftFinger=-1, RightFinger=1;

test_set_c3 = EEG_DATA.eeg_test(:,:,1)';
test_set_c4 = EEG_DATA.eeg_test(:,:,2)';
train_set_c3 = EEG_DATA.eeg_train(:,:,1)';
train_set_c4 = EEG_DATA.eeg_train(:,:,2)';
test_label = EEG_DATA.label_test(:,:)';
train_label = EEG_DATA.label_train(:,:)';
t = EEG_DATA.t(:,:)';
t(end) = [];

% Normalize the training data set respect to Trials
for i=1:1:length(train_label)
  train_set_c3(i,:) = (train_set_c3(i,:) - min(train_set_c3(i,:))) / (max(train_set_c3(i,:)) - min(train_set_c3(i,:)));
  train_set_c4(i,:) = (train_set_c4(i,:) - min(train_set_c4(i,:))) / (max(train_set_c4(i,:)) - min(train_set_c4(i,:)));
end


% Filter 8Hz - 30Hz
[B,A] = butter(8,.3,'low');
filter_c3=filtfilt(B,A,train_set_c3);
[C,D] = butter(8,.08,'high');
filter_c4=filtfilt(C,D,train_set_c4);

% Wavelet Packet Decomposition
WavePacketTreeC3 = wpdec(train_set_c3,length(train_set_c3),'coif5');
WavePacketTreeC4 = wpdec(train_set_c4,length(train_set_c3),'coif5');

% NodeTraversal
N = depo2ind(2, [2, 3]);
WavePacketTreeC3Coeff = wpcoef(WavePacketTreeC3, N);
