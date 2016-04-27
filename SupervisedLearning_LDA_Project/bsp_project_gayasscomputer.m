clc; clear;
EEG_DATA = load('Sbj2_Finger_Movement_EEG_All_Labels.mat');

% Seting up variables. Transposing the dataset. 
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
train_set_c3 = normc(train_set_c3);
train_set_c4 = normc(train_set_c4);

% Filter 8Hz - 30Hz for c3 set
[B,A] = butter(8,.3,'low');
filter_c3=filtfilt(B,A,train_set_c3);
[C,D] = butter(8,.08,'high');
filter_c4=filtfilt(C,D,train_set_c3);

% Filter 8Hz - 30Hz for c4 set 
[B,A] = butter(8,.3,'low');
filter_c3=filtfilt(B,A,train_set_c4);
[C,D] = butter(8,.08,'high');
filter_c4=filtfilt(C,D,train_set_c4);

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

%Creating feature extraction matrix
featuresMatrix_alpha_c3 = zeros(length(train_label), 5);
featuresMatrix_beta_c3 = zeros(length(train_label), 5);
featuresMatrix_alpha_c4 = zeros(length(train_label), 5);
featuresMatrix_beta_c4 = zeros(length(train_label), 5);

%RMS using y = rms(x, N)
for i=1:1:length(train_label)
  featuresMatrix_alpha_c3(i, 1) = rms(train_WaveletCoefficentMatrix_c3(i, 4, :));
  featuresMatrix_beta_c3(i, 1) = rms(train_WaveletCoefficentMatrix_c3(i, 3, :));
  featuresMatrix_alpha_c4(i, 1) = rms(train_WaveletCoefficentMatrix_c4(i, 4, :));
  featuresMatrix_beta_c4(i, 1) = rms(train_WaveletCoefficentMatrix_c4(i, 3, :));
end

%using waveform length
for i=1:1:length(train_label)
  featuresMatrix_alpha_c3(i, 2) = WaveformLength(train_WaveletCoefficentMatrix_c3(i,4, :));
  featuresMatrix_beta_c3(i, 2) = WaveformLength(train_WaveletCoefficentMatrix_c3(i,3, :));
  featuresMatrix_alpha_c4(i, 2) = WaveformLength(train_WaveletCoefficentMatrix_c4(i,4, :));
  featuresMatrix_beta_c4(i, 2) = WaveformLength(train_WaveletCoefficentMatrix_c4(i,3, :));
end

%using ModifiedMeanAbsValue2
for i=1:1:length(train_label)
  featuresMatrix_alpha_c3(i, 3) = ModifiedMeanAbsValue2(train_WaveletCoefficentMatrix_c3(i,4, :));
  featuresMatrix_beta_c3(i, 3) = ModifiedMeanAbsValue2(train_WaveletCoefficentMatrix_c3(i,3, :));
  featuresMatrix_alpha_c4(i, 3) = ModifiedMeanAbsValue2(train_WaveletCoefficentMatrix_c4(i,4, :));
  featuresMatrix_beta_c4(i, 3) = ModifiedMeanAbsValue2(train_WaveletCoefficentMatrix_c4(i,3, :));
end

%using SimpleSquareIntegral
for i=1:1:length(train_label)
  featuresMatrix_alpha_c3(i, 4) = SimpleSquareIntegral(train_WaveletCoefficentMatrix_c3(i,4, :));
  featuresMatrix_beta_c3(i, 4) = SimpleSquareIntegral(train_WaveletCoefficentMatrix_c3(i,3, :));
  featuresMatrix_alpha_c4(i, 4) = SimpleSquareIntegral(train_WaveletCoefficentMatrix_c4(i,4, :));
  featuresMatrix_beta_c4(i, 4) = SimpleSquareIntegral(train_WaveletCoefficentMatrix_c4(i,3, :));
end

%using featureExtraction1 <potentially will be using covariance, log-variance, autoregression>
for i=1:1:length(train_label)
  featuresMatrix_alpha_c3(i, 5) = log_variance(train_WaveletCoefficentMatrix_c3(i,4, :));
  featuresMatrix_beta_c3(i, 5) = log_variance(train_WaveletCoefficentMatrix_c3(i,3, :));
  featuresMatrix_alpha_c4(i, 5) = log_variance(train_WaveletCoefficentMatrix_c4(i,4, :));
  featuresMatrix_beta_c4(i, 5) = log_variance(train_WaveletCoefficentMatrix_c4(i,3, :));
end

% combining segments
feature_matrix_c3 = horzcat(featuresMatrix_alpha_c3,featuresMatrix_beta_c3);
feature_matrix_c4 = horzcat(featuresMatrix_alpha_c4,featuresMatrix_beta_c4);

% clear workspace
clearvars -except 	feature_matrix_c3 ...
					feature_matrix_c4 ...
					train_label ...
					test_label ...
					train_set_c3 ...
					train_set_c4 ...
					test_set_c3 ...
					test_set_c4 ...

% linear discriminant analysis 
% obj = fitcdiscr(feature_matrix_c3,train_label,'DiscrimType','linear');
% save('obj.mat','obj');
load('obj.mat');
% [label,score,cost] = predict(obj,feature_matrix_c3); 