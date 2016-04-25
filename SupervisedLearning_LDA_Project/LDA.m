function [ output_model ] = LDA( feature_matrix )
% function: Short description
%
% Extended description
sW = createScatterMatrixWeight(feature_matrix);
sB = createScatterMatrixBetween(feature_matrix);


end  % function

function [ scatter_weight ] = createScatterMatrixWeight(input_feature)
% function: Short description
%Calculating the within scatter matrix
%
%computing the scatter matrix

within_scatter_matrix = input_feature - ones(size(input_feature))*diag(mean(input_feature));
within_scatter_matrix(:,end) = input_feature(:,end);
within_scatter_matrix = within_scatter_matrix*within_scatter_matrix';
within_scatter_matrix(:,end) = input_feature(:,end);
scatter_weight = within_scatter_matrix;
end  % function

function [ scatter_between ] = function( input_feature)
% function: Short description
%Calculating the Between scatter matrix
% Extended description
between_scatter_matrix = (mean(input_feature) - mean2(input_feature));
between_scatter_matrix = length(input_feature)*between_scatter_matrix*between_scatter_matrix';
between_scatter_matrix(:,end) = input_feature(:,end);
scatter_between = between_scatter_matrix;
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
