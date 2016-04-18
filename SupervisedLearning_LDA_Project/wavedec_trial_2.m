

%b2=fir1(6,[0.5 60]/Fs,'bandpass');
%X=filter(b2,1,eeg_train(:,:,1));
data_train = eeg_train;
data_test = eeg_test;
Fs=250; %in Hz
N=length(data_train);
time = [1:N]/Fs;
s=data_train(:,1,1);
s2=data_train(:,1,2);

waveletFunction = 'db5';
                [C,L] = wavedec(s,5,waveletFunction);
       
                
                D1 = wrcoef('d',C,L,waveletFunction,1); %Noise
                D2 = wrcoef('d',C,L,waveletFunction,2); %Gamma
                D3 = wrcoef('d',C,L,waveletFunction,3); %Beta
                D4 = wrcoef('d',C,L,waveletFunction,4); %Alpha
                D5 = wrcoef('d',C,L,waveletFunction,5); %Theta
                A5 = wrcoef('a',C,L,waveletFunction,5); %DELTA
                POWER_BETA = (sum(D3.^2))/length(D3)
                
                
                
waveletFunction2 = 'db5';
                [C2,L2] = wavedec(s2,5,waveletFunction2);
       
               
                
                DD1 = wrcoef('d',C2,L2,waveletFunction,1); %Noise
                DD2 = wrcoef('d',C2,L2,waveletFunction,2); %Gamma
                DD3 = wrcoef('d',C2,L2,waveletFunction,3); %Beta
                DD4 = wrcoef('d',C2,L2,waveletFunction,4); %Alpha
                DD5 = wrcoef('d',C2,L2,waveletFunction,5); %Theta
                AA5 = wrcoef('a',C2,L2,waveletFunction,5); %DELTA
                
Gamma = D2; 
subplot(5,1,1); plot(1:1:length(Gamma),Gamma);title('GAMMA');
         
Beta = D3; 
subplot(5,1,2); plot(1:1:length(Beta),Beta);title('BETA');
         
Alpha = D4; 
subplot(5,1,3); plot(1:1:length(Alpha),Alpha); title('ALPHA'); 
                
Theta = D5; 
subplot(5,1,4); plot(1:1:length(Theta),Theta);title('THETA');

Delta = A5; 
subplot(5,1,5);plot(1:1:length(Delta),Delta);title('DELTA');




% Rectify Alpha signals
eegC3alpha_sq = D4.^2;
eegC4alpha_sq = DD4.^2;

% Rectify Beta signals
eegC3beta_sq = D3.^2;
eegC4beta_sq = DD3.^2;

%Normalize the signals. 

% Normalize Alpha signals
eegC3alpha_norm = eegC3alpha_sq/(max(eegC3alpha_sq));
eegC4alpha_norm = eegC4alpha_sq/(max(eegC4alpha_sq));

% Normalize Beta signals
eegC3beta_norm = eegC4beta_sq/(max(eegC3beta_sq));
eegC4beta_norm = eegC4beta_sq/(max(eegC4beta_sq));

figure(3)

subplot(2,2,1)
plot(time,eegC3alpha_norm);
xlabel('Time(s)'); ylabel('Amplitude'); title('Normalized Alpha CH3');

subplot(2,2,2)
plot(time,eegC4alpha_norm);
xlabel('Time(s)'); ylabel('Amplitude'); title('Normalized Alpha CH4');

subplot(2,2,3)
plot(time,eegC3beta_norm);
xlabel('Time(s)'); ylabel('Amplitude'); title('Normalized Beta CH3');

subplot(2,2,4)
plot(time,eegC4beta_norm);
xlabel('Time(s)'); ylabel('Amplitude'); title('Normalized Beta CH4');

D2 = detrend(D2,0);
xdft = fft(D2);
freq = 0:N/length(D2):N/2;
xdft = xdft(1:length(D2)/2+1);
subplot(511);plot(freq,(abs(xdft)));title('GAMMA-FREQUENCY'); xlim([0 100])
[~,I] = max(abs(xdft));
fprintf('Gamma:Maximum occurs at %3.2f Hz.\n',freq(I));

D3 = detrend(D3,0);
xdft2 = fft(D3);
freq2 = 0:N/length(D3):N/2;
xdft2 = xdft2(1:length(D3)/2+1);

subplot(512);plot(freq2,abs(xdft2));title('BETA');xlim([0 100])
[~,I] = max(abs(xdft2));
fprintf('Beta:Maximum occurs at %3.2f Hz.\n',freq2(I));

D4 = detrend(D4,0);
xdft3 = fft(D4);
freq3 = 0:N/length(D4):N/2;
xdft3 = xdft3(1:length(D4)/2+1);

subplot(513);plot(freq3,abs(xdft3));title('ALPHA');xlim([0 100])
[~,I] = max(abs(xdft3));
fprintf('Alpha:Maximum occurs at %f Hz.\n',freq3(I));


D5 = detrend(D5,0);
xdft4 = fft(D5);
freq4 = 0:N/length(D5):N/2;
xdft4 = xdft4(1:length(D5)/2+1);

subplot(514);plot(freq4,abs(xdft4));title('THETA');xlim([0 100])
[~,I] = max(abs(xdft4));
fprintf('Theta:Maximum occurs at %f Hz.\n',freq4(I));

A5 = detrend(A5,0);
xdft5 = fft(A5);
freq5 = 0:N/length(A5):N/2;
xdft5 = xdft5(1:length(A5)/2+1);

subplot(515);plot(freq3,abs(xdft5));title('DELTA');xlim([0 100])
[~,I] = max(abs(xdft5));
fprintf('Delta:Maximum occurs at %f Hz.\n',freq5(I));

figure;
plot(t(1:2048),D3.^2)
hold
plot(t(1:2048), (DD4.^2),'r-')


                
                
               