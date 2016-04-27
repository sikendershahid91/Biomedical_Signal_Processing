function [ projection_matrix ] = LDA1(data_matrix ,feature_matrix)

% creating scatter weight matrix
scatter_weight = feature_matrix;
meanFeature = mean(features_matrix);
for i=1:length(meanFeature)
  scatter_weight(i, :) = scatter_weight(i, :) - meanFeature(i);
end
scatter_weight = scatter_weight*scatter_weight';

%c creating scatter between matrix
scatter_between = mean(feature_matrix) - mean2(feature_matrix);
