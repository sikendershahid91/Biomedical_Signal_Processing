[m n] = size(eeg_train(:,:,1));
% coeffMat = zeros(131,14);

%% Decomposition

wvname = 'sym4';
for i = 1:n
C3 = eeg_train(:,i,1);
C4 = eeg_train(:,i,2);

[c3,l3] = wavedec(C3,5,wvname);
[c4,l4] = wavedec(C4,5,wvname);

C3Beta = wrcoef('d',c3,l3,wvname,3);
C3Alpha = wrcoef('d',c3,l3,wvname,4);

C4Beta = wrcoef('d',c4,l4,wvname,3);
C4Alpha = wrcoef('d',c4,l4,wvname,4);

%% Features from Coefficients

index = 1;
%Normalize
c3Alpha(1:length(C3Alpha),i) = C3Alpha/max(C3Alpha);
c3Beta(1:length(C3Beta),i) = C3Beta/max(C3Beta);
c4Alpha(1:length(C4Alpha),i) = C4Alpha/max(C4Alpha);
c4Beta(1:length(C4Beta),i) = C4Beta/max(C4Beta);

end

%Averaged
meanC3Alpha = mean(c3Alpha);
meanC3Beta  = mean(c3Beta);
meanC4Alpha = mean(c4Alpha);
meanC4Beta  = mean(c4Beta);

stdC3Alpha = std(c3Alpha);
stdC3Beta = std(c3Beta);
stdC4Alpha = std(c4Alpha);
stdC4Beta = std(c4Beta);

powC3Alpha = abs(c3Alpha).^2;
powC3Beta = abs(c3Beta).^2;
powC4Alpha = abs(c4Alpha).^2;
powC4Beta = abs(c4Beta).^2;

powC3Alpha = mean(powC3Alpha);
powC3Beta = mean(powC3Beta);
powC4Alpha = mean(powC4Alpha);
powC4Beta = mean(powC4Beta);


X = [meanC3Alpha; meanC3Beta; meanC4Alpha; meanC4Beta; powC3Alpha; powC3Beta; powC4Alpha; powC4Beta]';
[mX nX] = size(X);

%Splitting in Left and Right Classes
leftInd = find(label_train == -1);
rightInd = find(label_train == 1);

rightMat = zeros(4,length(rightInd));
for i = 1:length(rightInd)
    idx = 1; 
    rightMat(idx,i)= meanC3Alpha(rightInd(i))';
    idx   = idx +   1;
    rightMat(idx,i)= meanC3Beta(rightInd(i))';
    idx   = idx +   1;
    rightMat(idx,i)= meanC4Alpha(rightInd(i))';
    idx   = idx +   1;
    rightMat(idx,i)= meanC4Beta(rightInd(i))';
    idx   = idx +   1;
    rightMat(idx,i)= powC3Alpha(rightInd(i))';
    idx   = idx +   1;
    rightMat(idx,i)= powC3Beta(rightInd(i))';
    idx   = idx +   1;
    rightMat(idx,i)= powC4Alpha(rightInd(i))';
    idx   = idx +   1;
    rightMat(idx,i)= powC4Beta(rightInd(i))';
end

leftMat = zeros(4,length(leftInd));
for i = 1:length(leftInd)
    idx = 1; 
    leftMat(idx,i)= meanC3Alpha(leftInd(i))';
    idx   = idx +   1;
    leftMat(idx,i)= meanC3Beta(leftInd(i))';
    idx   = idx +   1;
    leftMat(idx,i)= meanC4Alpha(leftInd(i))';
    idx   = idx +   1;
    leftMat(idx,i)= meanC4Beta(leftInd(i))';
    idx   = idx +   1;
    leftMat(idx,i)= powC3Alpha(leftInd(i))';
    idx   = idx +   1;
    leftMat(idx,i)= powC3Beta(leftInd(i))';
    idx   = idx +   1;
    leftMat(idx,i)= powC4Alpha(leftInd(i))';
    idx   = idx +   1;
    leftMat(idx,i)= powC4Beta(leftInd(i))';
end

%Even the sizes of the Matrices
if length(rightMat)>(length(leftMat))
    rightOrig = rightMat;
    rightMat = rightMat(:,1:length(leftMat));
else
    leftOrig = leftMat;
    leftMat = leftMat(:,1:length(rightMat));
end    

coeffMat = cat(3,leftMat,rightMat);

%% Mean of features and concatenating into one matrix

meanMat = cat(2,mean(leftMat,2),mean(rightMat,2));

%% Scatter Matrices
sWLeft = zeros(nX,nX); sWRight = zeros(nX,nX);
%Within-Class
for i = 1:length(leftMat)
xL = (leftMat(:,i) - meanMat(:,1));
xR = (rightMat(:,i)- meanMat(:,2));
xLt = xL';
xRt = xR';
sWLeft = sWLeft + (xL*xLt);
sWRight = sWRight + (xR*xRt);
end
% % sWLeft = xL*xLt;
% % sWRight = xR*xRt;

sW = sWLeft + sWRight;

%Between-Class
% % leftMean = mean(meanMat(:,1));
% % rightMean = mean(meanMat(:,2));
overallMean = mean(meanMat);
overallMean = mean(overallMean);

for i = 1:length(meanMat(:,1))
xL(i,1) = meanMat(i,1) - overallMean;
xLt = xL';
xR(i,1) = meanMat(i,2) - overallMean;
xRt = xR';
end
sBLeft = (length(meanMat(:,1))/mX)*(xL*xLt);
sBRight = (length(meanMat(:,2))/mX)*(xR*xRt);

sB = sBLeft + sBRight;

%% Eigen of Inverse sW * sB

A = sW\sB;

[V,D] = eig(A);

[mV,nV] = size(V);
[mD,nD] = size(D);
for i = 1:nD
    eigval(1,i) = (D(i,i));
    %eigval(2,i) = i;
end
% % eigval = real(eigval);
% % eigvalSort = sort(eigval,2,'descend');

%Construction of projection eigenvector matrix
% W = cat(2,V(:,1),V(:,2));
W = V(:,1)
if (exist('leftOrig','var'))
    Y1 = leftOrig'*W;
else
    Y1 = coeffMat(:,:,1)'*W;
end
if (exist('rightOrig','var'))
    Y2 = rightOrig'*W;
else
    Y2 = coeffMat(:,:,2)'*W;
end
% % Y = cat(1,Y1,Y2);
Y = X*W;

