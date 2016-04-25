function [ output_model ] = LDA( feature_matrix )
% function: Short description
%
% Extended description
sW = createScatterMatrixWeight(feature_matrix);
sB = createScatterMatrixBetween(feature_matrix);


end  % function

function [ scatter_weight ] = createScatterMatrixWeight( in )
% function: Short description
%S_i is the scatter matrix for every class
% Extended description
[~,1]=size(in(:,1:5)); %Size of in
classes = unique(in(:,6)); %Class vector
totalclasses = length(classes); %Number of classes
within_scatter = zeros(131,6); %initialize within matrix
meanofdata = mean(in(:,1:5)); %Mean of features overall
for n = 1:totalclasses
  class_data = find( in(:,6)==classes(n)); %Get feature for each class
  x = in(class_data,:);

  m = mean(x); %mean of each class
  x = x-repmat(m,length(class_data),1); %xi - mi
  within_scatter = within_scatter + x' * x;
end
end  % function

function [ scatter_between_classes] = createScatterMatrixBetween( in)

end

function [ out_matrix ] = sortingByEigen( in )
% function: Short description
%
% Extended description

end  % function

function [ out_subspaceY ] = TransformNewSubSpaceY( in )
% function: Short description
%
% Extended description

end  % function
