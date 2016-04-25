function [ output_model ] = LDA( feature_matrix )
% function: Short description
%
% Extended description
sW = createScatterMatrixWeight(feature_matrix);
sB = createScatterMatrixBetween(feature_matrix);


end  % function

function [ scatter_weight ] = createScatterMatrixWeight(input_feature, class_index )
% function: Short description
%class_index is the sixth column of the coeiffienct matrix from the WT
%S_i is the scatter matrix for every class
% Extended description
max_class = max(class_index);
size_input = size(input_feature,2)
total_mean = mean(input_feature)

%computing the scatter matrix
for i = 1:max_class
  dx = find(class_index==i);
  mu_mean(i,:) = mean(input_feature(dx,:),1);
end
[~ j] = size(input_feature(:,1:5));
for n:1:j
  mu_mean = mu_mean(:,n) - mean(mu_mean(:,n));
end
between_matrix = 0;
%"USING MATLAB'S NUMERICAL COMPUTATIONAL SKILLS DAWG" - SIKENDER
for i=1:max_class
  between_matrix = between_matrix + (mu_mean(i,:)'*mu_mean(i,:));
end
between_matrix = (1/max_class) * between_matrix;

%Computing the within scatter
within_scatter = zeros(size(between_matrix));
for i = 1:max_class
  dx = find(class_index==i);
  x = bsxfun(@minus, X(dx,:), mu_mean(i,:));
  within_scatter = within_scatter + (x' * x);
end
  within_scatter = (1/max_ckass) * within_scatter;
end  % function



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

  % threshold 0.25 removal of matrix
  threshold = ceil((length(eigen_values))*0.25);
  eigen_values(end-threshold:end) = [];
  eigen_vector_postions = values(eigen_vector_dictionary, mat2cell(eigen_values));
  out_matrix = eigen_vector(cell2mat(eigen_vector_postions));
end

function [ weight_matrix ] = Diagonalise(scatter_b_matrix, eigen_vector_matrix, eigen_value_matrix)
  % function:
  eigen_value_matrix = diag(eigen_value_matrix);
  matrix_k = sqrt(inv(eigen_value_matrix)) * eigen_vector_matrix' * scatter_b_matrix ...
           * eigen_vector_matrix * sqrt(inv(eigen_value_matrix));
  matrix_k = (matrix_k + matrix_k') / 2;
  [eig_vector_k, eig_value_k] = eigh(matrix_k);
  eig_vector_k = eig_vector_k';

  weight_matrix = eigen_vector_matrix' * sqrt(inv(eigen_value_matrix')) * eig_vector_k';
  weight_matrix = weight_matrix';

  eig_value_k = diag(eig_value_k);
  [~, range] = sort(eig_value_k, 'descend');
  weight_matrix = weight_matrix(range, :);
  eig_value_k = eig_value_k(range);
end

function [ new_subspace ] = TransformNewSubSpace(data_matrix, weight_matrix)
  % function: Input of data_matrix whether test or train set and eigen matrix
  % calculating the dot product will produced a new subspace

  new_subspace = dot(data_matrix, weight_matrix);
end  % function
