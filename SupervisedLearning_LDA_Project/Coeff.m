% % Z = input('Input Trial Number: ');
[m n] = size(eeg_train(:,:,1));
coeffMat = zeros(131,14);

for i = 1:n
C3 = eeg_train(:,i,1);
C4 = eeg_train(:,i,2);

%% Decomposition
[c3,l3] = wavedec(C3,5,'db8');
[c4,l4] = wavedec(C4,5,'db8');
d3 = detcoef(c3,l3);
d4 = detcoef(c4,l4);
xC3_Noise = wrcoef('d',c3,l3,'db8');
xC4_Noise = wrcoef('d',c4,l4,'db8');
C3Beta = wrcoef('d',c3,l3,'db8',3);
C4Beta = wrcoef('d',c4,l4,'db8',3);
C3Alpha = wrcoef('d',c3,l3,'db8',4);
C4Alpha = wrcoef('d',c4,l4,'db8',4);

%% Calculating Features
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

end

for i = 1:length(label_train)
    coeffMat(i,15) = label_train(i);
end

%% Splitting Coeff Mat into Left and Right Mat.

leftInd = find(label_train == -1);
rightInd = find(label_train == 1);
rightCoeffMat = zeros(length(rightInd),15);
leftCoeffMat = zeros(length(leftInd),15);
tally = 1;
for i = 1:length(rightInd)
    for n = 1:14
    rightCoeffMat(tally,n)= coeffMat(rightInd(i),n);
    end
    tally = tally + 1;
end
tally = 1;
for i = 1:length(leftInd)
    for n = 1:14
    leftCoeffMat(tally,n)= coeffMat(leftInd(i),n);
    end
    tally = tally + 1;
end

% Averaging Values in Each Mat
avgLeftCoeff = zeros(1,14);
avgRightCoeff = zeros(1,14);

for i = 1:14
    avgLeftCoeff(i) = mean(leftCoeffMat(:,i));
    avgRightCoeff(i) = mean(rightCoeffMat(:,i));
end

avgLeft = mean(avgLeftCoeff);
avgRight = mean(avgRightCoeff);
