function [ output_model ] = LDA( feature_matrix )
% function: Short description
%
% Extended description
sW = createScatterMatrixWeight(feature_matrix);
sB = createScatterMatrixBetween(feature_matrix);


end  % function

function [ scatter_weight ] = createScatterMatrixWeight(scatter_w )
% function: Short description
%S_i is the scatter matrix for every class
% Extended description
[~,1]=size(scatter_w(:,1:5)); %Size of in
classes = unique(scatter_w(:,6)); %Class vector
totalclasses = length(classes); %Number of classes
within_scatter = zeros(131,6); %initialize within matrix
meanofdata = mean(scatter_w(:,1:5)); %Mean of features overall
for n = 1:totalclasses
  class_data = find( scatter_w(:,6)==classes(n)); %Get feature for each class
  x = scatter_w(class_data,:);

  m = mean(x); %mean of each class
  x = x-repmat(m,length(class_data),1); %xi - mi
  within_scatter = within_scatter + x' * x;
end
end  % function

function [ scatter_between_classes] = createScatterMatrixBetween(scatter_b)
  [~,1]=size(scatter_b(:,1:5)); %Size of in
  classes = unique(scatter_b(:,6)); %Class vector

  totalclasses = length(classes); %Number of classes
  between_matrix_scatter = zeros(131,6); %initialize within matrix
  meanofdata = mean(scatter_b(:,1:5)); %Mean of features overall
  for n = 1:totalclasses
    class_data = find( scatter_b(:,6)==classes(n)); %Get feature for each class
    x = scatter_b(class_data,:);

    m = mean(x); %mean of each class
    x = x-repmat(m,length(class_data),1); %xi - mi
    between_matrix = between_matrix(class_data)*(m-meanofdata)'*(mci-meanofdata)
end
end

function [ out_matrix ] = sortingByEigen(scatter_w, scatter_b)
% function: input of scatter-weighted Matrix and scatter-between matrix
% calculating the eigen value and vector, the output will containe a reduced
% matrix based on the reduced eigen vectors.

[eigen_vector, eigen_values] = eig(inv(scatter_w)*scatter_b);
eigen_values = diag(eigen_values);
eigen_vector_location = zeros(length(eigen_values),1);
for i = 1:1:length(eigen_values)
  eigen_vector_location(i) = i;
end
eigen_values_dictionary = containers.Map(eigen_values, eigen_vector_location);
eigen_values = sort(eigen_values, 'descend');
max_eigen_vector = eigen_vector_dictionary(eigen_values(1));
halfReduction = ceil((length(eigen_values))/2);
eigen_vector(:, halfReduction:end) = [];
out_matrix = eigen_vector;
end  % function

function [ new_subspace ] = TransformNewSubSpace(data_matrix, eigen_matrix)
% function: Input of data_matrix whether test or train set and eigen matrix
% calculating the dot product will produced a new subspace

new_subspace = dot(data_matrix, eigen_matrix);
end  % function
