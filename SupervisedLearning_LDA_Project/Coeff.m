% % Z = input('Input Trial Number: ');
[m n] = size(eeg_train(:,:,1));
coeffMat = zeros(131,14);

for i = 1:n
C3 = eeg_train(:,i,1);
C4 = eeg_train(:,i,2);


[c3,l3] = wavedec(C3,5,'sym4');
[c4,l4] = wavedec(C4,5,'sym4');
d3 = detcoef(c3,l3);
d4 = detcoef(c4,l4);
xC3_Noise = wrcoef('d',c3,l3,'sym4');
xC4_Noise = wrcoef('d',c4,l4,'sym4');
C3Beta = wrcoef('d',c3,l3,'sym4',3);
C4Beta = wrcoef('d',c4,l4,'sym4',3);
C3Alpha = wrcoef('d',c3,l3,'sym4',4);
C4Alpha = wrcoef('d',c4,l4,'sym4',4);

c3Alpha = C3Alpha/max(C3Alpha);
c3Beta = C3Beta/max(C3Beta);
c4Alpha = C4Alpha/max(C4Alpha);
c4Beta = C4Beta/max(C4Beta);

meanC3Alpha = mean(c3Alpha);
meanC3Beta = mean(c3Beta);
meanC4Alpha = mean(c4Alpha);
meanC4Beta = mean(c4Beta);

coeffMat(i,1) = meanC3Alpha; % Mean of Coeffs.
coeffMat(i,2) = meanC3Beta;
coeffMat(i,3) = meanC4Alpha;
coeffMat(i,4) = meanC4Beta;
coeffMat(i,5) = mean(c3Alpha.^2); % Avg Pow of Coeffs.
coeffMat(i,6) = mean(c3Beta.^2);
coeffMat(i,7) = mean(c4Alpha.^2);
coeffMat(i,8) = mean(c4Beta.^2);
coeffMat(i,9) = sqrt(var(c3Alpha)); % Std Dev of Coeffs.
coeffMat(i,10) = sqrt(var(c3Beta));
coeffMat(i,11) = sqrt(var(c4Alpha));
coeffMat(i,12) = sqrt(var(c4Beta));
coeffMat(i,13) = meanC3Alpha/meanC3Beta; %Ratio of Alpha to Beta
coeffMat(i,14) = meanC4Alpha/meanC4Beta;

% % coeffMat(i,1) = meanC3Alpha;
% % coeffMat(i,2) = meanC3Beta;
% % coeffMat(i,3) = meanC4Alpha;
% % coeffMat(i,4) = meanC4Beta;
% % coeffMat(i,5) = avgPowC3Alpha;

end
% % 
% % plot(t(1:2048),c4Alpha)
% % hold
% % plot(t(1:2048),c3Beta+5,'r')

% % titleC3Bef = sprintf('C3 Before, Trial %d',Z);
% % titleC3Aft = sprintf('C3 After, Trial %d',Z);
% % titleC4Bef = sprintf('C4 Before, Trial %d',Z);
% % titleC4Aft = sprintf('C4 After, Trial %d',Z);
% % 
% % figure
% % subplot(2,1,1)
% % plot(C3)
% % title(titleC3Bef)
% % ylim([-10 10])
% % %xlim([600 1100])
% % subplot(2,1,2)
% % plot(xC3_Noise)
% % title(titleC3Aft)
% % ylim([-10 10])
% % %xlim([600 1100])
% % 
% % figure
% % subplot(2,1,1)
% % plot(C4)
% % title(titleC4Bef)
% % ylim([-10 10])
% % %xlim([600 1100])
% % subplot(2,1,2)
% % plot(xC4_Noise)
% % title(titleC4Aft)
% % ylim([-10 10])
% % %xlim([600 1100])
