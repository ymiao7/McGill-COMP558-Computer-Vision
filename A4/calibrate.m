function  [P, K, R, C] =  calibrate(XYZ, xy)

%  Create the data matrix to be used for the least squares.
%  and perform SVD to find matrix P.

%  BEGIN CODE STUB (REPLACE WITH YOUR OWN CODE)

% Initializing the 2N x 11 matrix A on the left-hand side of the equation
N = size(XYZ,1);
A = zeros(2*N,12);

% Assigning values to matrix A
count = 1;
for i = 1:2:2*N
    A(i,:) = [XYZ(count,1) XYZ(count,2) XYZ(count,3) 1.0 ...
              0 0 0 0 ...
              -xy(count,1)*XYZ(count,1) -xy(count,1)*XYZ(count,2) -xy(count,1)*XYZ(count,3) -xy(count,1)];
    count = count+1;
end

count = 1;
for i = 2:2:2*N
    A(i,:) = [0 0 0 0 ...
              XYZ(count,1) XYZ(count,2) XYZ(count,3) 1.0 ...
              -xy(count,2)*XYZ(count,1) -xy(count,2)*XYZ(count,2) -xy(count,2)*XYZ(count,3) -xy(count,2)];
    count = count+1;
end

% Take SVD of A
[~,~,V] = svd(A);

% Get the column of V with the smallest singular value (last column of V)
P_temp = V(:,size(V,2));

% Calculating matrix P
% P = pinv(D)*R;
%P(12) = 1;
P = reshape(P_temp,4,3);
P = P';

% Factoring P into a product of K,R and C
[K, R, C] = decomposeProjectionMatrix(P);


%  END CODE STUB 

P = K * R * [eye(3), -C];
[K, R, C] = decomposeProjectionMatrix(P);
