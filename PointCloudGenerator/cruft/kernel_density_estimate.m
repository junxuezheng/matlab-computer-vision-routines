%KERNEL_DENSITY_ESTIMATE
%k number of nearest neighbours to use
% can formulate X_vec using X_vec = [ X1_vec', X2_vec', X3_vec' ];
% index is the row vector for which we will calculate the kernel density
function [q_x,id,dist_x,f,f_fixed_h] = kernel_density_estimate( X_vec,index,k,n,h,h_fixed )
    if nargin == 2, k = 10; end % k-value for k nearest neighbours
    dim = size( X_vec,2 );
    [id,dist_x] = kNearestNeighbors( X_vec,X_vec(index,:),k);
    Y = X_vec(index,:);
    X = X_vec(id,:);
    dist_mahal = cvMahaldist(Y',X');
    q_x = 0;
    f = 0;
    f_fixed_h = 0;
    if n > k, error( 'n must be less than or equal to k' ), end
    for i=2:k
        [id_n,dist_n] = kNearestNeighbors( X_vec,X_vec(id(i),:),k);
        h_x = h * dist_n(1,n);
        %h_x = 0.001;
        %rd_k = max(dist_n(1,k),dist(1,i));
        f = f + 1/((2*pi)^(dim/2)*(h_x)^dim) * exp( -1 * (dist_mahal(1,i)^2) / (2*h_x^2) );
        f_fixed_h = f_fixed_h + 1/((2*pi)^(dim/2)*(h_fixed)^dim) * exp( -1 * (dist_mahal(1,i)^2) / (2*h_fixed^2) );
        q_x = q_x + 1/((2*pi)^(dim/2)*(h_x)^dim) * exp( -1 * (dist_x(1,i)^2)/(2*h_x^2));
        %q_x = q_x + 1/((2*pi)^(dim/2)*(h_x)^dim) * exp( -1 * (rd_k^2)/(2*h_x^2));
    end
    % 1/m
    q_x = q_x / (k-1);
    f = f / (k-1);
    f_fixed_h = f_fixed_h / (k-1);
end