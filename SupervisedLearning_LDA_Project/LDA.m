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
  ~,1]=size(in(:,1:5)); %Size of in
  classes = unique(in(:,6)); %Class vector
  totalclasses = length(classes); %Number of classes
  between_matrix_scatter = zeros(131,6); %initialize within matrix
  meanofdata = mean(in(:,1:5)); %Mean of features overall
  for n = 1:totalclasses
    class_data = find( in(:,6)==classes(n)); %Get feature for each class
    x = in(class_data,:);

    m = mean(x); %mean of each class
    x = x-repmat(m,length(class_data),1); %xi - mi
    between_matrix = between_matrix(class_data)*(m-meanofdata)'*(mci-meanofdata)
end

function [ out_matrix ] = sortingByEigen(scatter_w, scatter_b)
% function: Short description
%
% Extended description
[eigen_vector, eigen_values] = eig(inv(scatter_w)*scatter_b);
eigen_values = diag(eigen_values);
eigen_vector_location = zeros(length(eigen_values),1);
for i = 1:1:length(eigen_values)
  eigen_vector_location(i) = i;
end
eigen_values_dictionary = containers.Map(eigen_values, eigen_vector_location);
eigen_values = sort(eigen_values, 'descend');
max_eigen_vector = eigen_vector_dictionary(eigen_values(1));


end  % function

function [ out_subspaceY ] = TransformNewSubSpaceY( in )
% function: Short description
%
% Extended description

end  % function
