function [Y, varargout] = lda2(X,C,varargin)

% Need to check if we have continuous class label. i.e. can't have 1,2,5
% because it makes no sense.
if (max(C) ~= size((unique(C)),2))
    error('LDA:classlabels','Class labels are not continuous.');
end

if nargin == 3
    conc = varargin{1};
    if conc > 1
        error('LDA:concentration','''conc'' can''t be greater than 1.');
    end
else
    conc = 0.99;
end

Nc = max(C);
N = size(X,2);
overall_mu = mean(X);

% Compute between class scatter matrix -> Sb
for i=1:Nc
    idx = find(C==i);
    mu(i,:) = mean(X(idx,:),1);
end
mu = bsxfun(@minus, mu, overall_mu);
Sb = 0;
for i=1:Nc
    Sb = Sb + (mu(i,:)'*mu(i,:));
end
Sb = (1/Nc) * Sb;

% Compute within class scatter matrix -> Sw
Sw = zeros(size(Sb));
for i=1:Nc
    idx = find(C==i);
    d = bsxfun(@minus, X(idx,:), mu(i,:));
    Sw = Sw + (d'*d);
end
Sw = (1/Nc) * Sw;


% For details, see Fukunaga's "Introduction to Statistical Pattern
% Recognition". See pg 31 - "Simultaneous Diagonalization".

[Vw, Dw] = eig(Sw);
Vw = Vw';
Dw = diag(Dw);
[~, idx] = sort(Dw, 'descend');
Dw = Dw(idx);

% Find where the energy in the eigenvectors is concentrated, use
% this as a threshold for the projection.

thresh = find((cumsum(Dw)/sum(Dw)) > conc);
Dw = diag(Dw(1:thresh(1)));
Vw = Vw(idx(1:thresh(1)),:);

% Diagonalise according to Fukunaga, pg 31 eqns 2.93, 2.95, 2.96
K = sqrt(inv(Dw)) * Vw * Sb * Vw' * sqrt(inv(Dw));
K = (K + K') / 2;

% apply orthonormal transform to diagonalise K, see Fukunaga pg 33 eqn 2.97
% onwards
[VK, DK] = eig(K);
VK = VK';

% projection matrix is thus
W = (Vw' * sqrt(inv(Dw')) * VK'); % eqn 2.99, 2.100
W = W';

D = diag(DK);
[~,idx] = sort(D, 'descend');
W = W(idx,:);
D = D(idx);

% Set up the variable returns
Y = X * W'; % projection

if nargout == 2
    varargout{1} = W;
elseif nargout == 3
    varargout{1} = W;
    varargout{2} = D;
end
end
