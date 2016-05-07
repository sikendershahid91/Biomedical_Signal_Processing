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
avgLeftCoeff(1,15) = -1;
avgRightCoeff(1,15) = 1;

% avgLeft = mean(avgLeftCoeff);
% avgRight = mean(avgRightCoeff);

%% Scatter Matrices
%Within Class
siLeft = zeros(1,14);
siRight = zeros(1,14);
xL = []; xR = [];
[mL, nL] = size(leftCoeffMat); %65 x 15
[mR, nR] = size(rightCoeffMat);%66 x 15


for n = 1:mL
    for i = 1:(nL-1)
   %     siLeft(n,i) = ((leftCoeffMat(:,i) - avgLeftCoeff(1,i))*((leftCoeffMat(:,i) - avgLeftCoeff(1,i))'));
         xL(n,i) = (leftCoeffMat(n,i)-avgLeftCoeff(1,i));
    end  %[Sik:  you dont really have to use for loops for these operations.]
end
xLt = xL';
swLeft = xLt*xL;
% swLeft(1,nL) = -1;
% swLeft = sum(siLeft);

for n = 1:mR
    for  i = 1:(nR-1)
        %siRight(n,i) = ((rightCoeffMat(n,i) - avgRightCoeff(1,i))*((rightCoeffMat(n,i) - avgRightCoeff(1,i))'));
        xR(n,i) = (rightCoeffMat(n,i)-avgRightCoeff(1,i));
        %[Sik:  you dont really have to use for loops for these operations.]
    end
end
xRt = xR';
swRight = xRt*xR;
%swRight(1,nR) = 1;

sW = swLeft + swRight;

pause(10)
%Between Class
meanAvgLeft = sum(avgLeftCoeff(1:(nL-1)));%[Sik:  why remove last element. ]
meanAvgRight = sum(avgRightCoeff(1:(nR-1)));
xL = []; xR = [];
[mL, nL] = size(avgLeftCoeff);
[mR, nR] = size(avgRightCoeff);

for i = 1:(nL-1)
    xL(i) = avgLeftCoeff(i) - meanAvgLeft; %[Sik:  you dont really have to use for loops for these operations.]
end
xLt = xL';
sbLeft = (nL-1)*(xLt*xL);

for i = 1:(nR-1)
    xR(i) = avgRightCoeff(i) - meanAvgRight; %[Sik:  you dont really have to use for loops for these operations.]
end
xRt = xR';
sbRight = (nR-1)*(xRt*xR);

sB = sbLeft + sbRight;


%% Selecting the LD for feature subspace
invSW = inv(sW);
A = invSW*sB;
aLeft = swLeft\sbLeft;
aRight = swRight\sbRight;
[V,D] = eig(A);
for i = 1:length(D)
    dFix(i,1) = D(i,i);
end
sortValues = sort(D,'descend');

sortA = sort(A,'descend');
sortLeft = sort(aLeft,'descend');
sortRight = sort(aRight,'descend');
%[Sik:  you didnt do anything with the sorted values ...]

%% Looking at Eigenvalues and Vectors to determine features/classifiers.
%Chose meanC3Alpha and meanC3Beta

X = coeffMat(:,1:2);
W = V(1:2,:);

Y = X*W;
leftX = leftCoeffMat(:,1:2);
rightX = rightCoeffMat(:,1:2);
yLeft = leftX*W;
yRight = rightX*W;
%[Sik:  you dont have to split your Y. Y will be the model that you will run the
%   real data sets and perform LDA. Now as you perform LDA you will be also outputing
%   the classifications based on your feature extractions. ]
