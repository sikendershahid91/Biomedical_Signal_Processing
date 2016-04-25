function [ output_model ] = LDA( feature_matrix )
% function: Short description
%
% Extended description
sW = createScatterMatrixWeight(feature_matrix);
sB = createScatterMatrixBetween(feature_matrix);


end  % function

function [ scatter_weight ] = createScatterMatrixWeight( in )
% function: Short description
%
% Extended description

end  % function

function [ scatter_between_classes] = createScatterMatrixBetween( in)

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
