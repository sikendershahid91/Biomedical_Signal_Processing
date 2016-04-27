
function [projected_matrix, eigen_vector, eigen_value] = LDA(data_matrix, feature_matrix)

    Classes=unique(feature_matrix, end)';
    k=numel(Classes);
    n=zeros(k,1);
    C=cell(k,1);
    M=mean(data_matrix);
    S=cell(k,1);
    Scatter_eigen_vector=0;
    Scatter_b=0;
    for j=1:k
        data_matrixj=data_matrix(feature_matrix==Classes(j),:);
        n(j)=size(data_matrixj,1);
        C{j}=mean(data_matrixj);
        S{j}=0;
        for i=1:n(j)
            S{j}=S{j}+(data_matrixj(i,:)-C{j})'*(data_matrixj(i,:)-C{j});
        end
        Scatter_eigen_vector=Scatter_eigen_vector+S{j};
        Scatter_b=Scatter_b+n(j)*(C{j}-M)'*(C{j}-M);
    end

    % extracting eigen vector & value information
    [eigen_vector, eigen_value]=eig(Scatter_b,Scatter_eigen_vector);

    % aligning the eigen values n X 1
    eigen_value=diag(eigen_value);

    % Sorting the eigen_vector with most relevant informative vector at top
    [eigen_value, decending_order]=sort(eigen_value,'descend');
    eigen_vector=eigen_vector(:,decending_order);

    projected_matrix=data_matrix*eigen_vector;

end
