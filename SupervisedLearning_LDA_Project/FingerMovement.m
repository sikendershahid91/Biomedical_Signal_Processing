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
Fs = 250;
df = Fs/2048;
frequency = (-Fs/2:df:Fs/2-df)';

% Normalize the training data set respect to Trials
for i=1:1:length(train_label)
  train_set_c3(i,:) = (train_set_c3(i,:) - min(train_set_c3(i,:))) / (max(train_set_c3(i,:)) - min(train_set_c3(i,:)));
  train_set_c4(i,:) = (train_set_c4(i,:) - min(train_set_c4(i,:))) / (max(train_set_c4(i,:)) - min(train_set_c4(i,:)));
end

% wavelet Transform (WT)- extract the coeiffienct from train_set for each trial
daubechies_WT = 'db5';
train_WaveletCoefficentMatrix_c3 = zeros(length(train_label),6,length(train_set_c3(1,:)));
train_WaveletCoefficentMatrix_c4 = zeros(length(train_label),6,length(train_set_c4(1,:)));

% coloumn 1-6 respectively are Noise, Gamma, Beta, Alpha, Theta, Delta
for i=1:1:length(train_label)
  [C, L]= wavedec(train_set_c3(i, :), 5, daubechies_WT);
    train_WaveletCoefficentMatrix_c3(i,1, :) = wrcoef('d',C,L,daubechies_WT,1); %Noise
    train_WaveletCoefficentMatrix_c3(i,2, :) = wrcoef('d',C,L,daubechies_WT,2); %Gamma
    train_WaveletCoefficentMatrix_c3(i,3, :) = wrcoef('d',C,L,daubechies_WT,3); %Beta
    train_WaveletCoefficentMatrix_c3(i,4, :) = wrcoef('d',C,L,daubechies_WT,4); %Alpha
    train_WaveletCoefficentMatrix_c3(i,5, :) = wrcoef('d',C,L,daubechies_WT,5); %Theta
    train_WaveletCoefficentMatrix_c3(i,6, :) = wrcoef('a',C,L,daubechies_WT,5); %DELTA
end

for i=1:1:length(train_label)
  [C, L]= wavedec(train_set_c4(i, :), 5, daubechies_WT);
    train_WaveletCoefficentMatrix_c4(i,1, :) = wrcoef('d',C,L,daubechies_WT,1); %Noise
    train_WaveletCoefficentMatrix_c4(i,2, :) = wrcoef('d',C,L,daubechies_WT,2); %Gamma
    train_WaveletCoefficentMatrix_c4(i,3, :) = wrcoef('d',C,L,daubechies_WT,3); %Beta
    train_WaveletCoefficentMatrix_c4(i,4, :) = wrcoef('d',C,L,daubechies_WT,4); %Alpha
    train_WaveletCoefficentMatrix_c4(i,5, :) = wrcoef('d',C,L,daubechies_WT,5); %Theta
    train_WaveletCoefficentMatrix_c4(i,6, :) = wrcoef('a',C,L,daubechies_WT,5); %DELTA
end

featuresMatrix_alpha_c3 = zeros(length(train_label), 6, length(train_set_c3));
featuresMatrix_beta_c3 = zeros(length(train_label), 6, length(train_set_c3));
featuresMatrix_alpha_c4 = zeros(length(train_label), 6, length(train_set_c4));
featuresMatrix_beta_c4 = zeros(length(train_label), 6, length(train_set_c4));



% required features RMS, WL, MMAV, SSI, ZC, SSC
% y = rmx(x, N)
% WL
%
signal = zeros(length(train_set_c3));
N = length(train_set_c3)/2
signal(1:N) = squeeze(train_WaveletCoefficentMatrix_c3(1,3,1:N));
signal(N+1:length(train_set_c3)) = squeeze(train_WaveletCoefficentMatrix_c3(1,4,N+1:length(train_set_c3)));

figure();
plot(t, signal);




%

% figure();
% plot(t, squeeze(train_WaveletCoefficentMatrix_c3(1,4,:)));
