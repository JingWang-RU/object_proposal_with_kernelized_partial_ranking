clear;
%blaslib = fullfile(matlabroot,'extern','lib',computer('arch'),'microsoft', 'libmwblas.lib');

mex COPTIMFLAGS='-O3 -DNDEBUG' -largeArrayDims mex_CWS.cpp -lmwblas

n = 5;
D = 2;
K = 10;

R = gamrnd(2, 1, [D, K]);
C = gamrnd(2, 1, [D, K]);
Beta = unifrnd(0, 1, [D, K]);
X = randi(100, n, D);

b = 8;

logX = log(X);

y_mex = mex_CWS(R, C, Beta, logX, b);

%
inc = 0:2^b:(n-1)*2^b;

y_matlab = zeros(n, 2^b * K);
for k = 1:K
    r = ones(n, 1) * R(:, k)';
    c = ones(n, 1) * C(:, k)';
    
    beta = ones(n, 1) * Beta(:, k)';
    
    t = floor(logX ./ r + beta); 
    y = exp((t-beta) .* r);
    a = c ./ (y .* exp(r));
    
    [~, istar] = min(a, [], 2);
    
    istar = mod(istar-1, 2^b) + 1;
    istar = istar' + inc;

    tmp = zeros(2^b, n);
    tmp(istar) = 1;
    
    y_matlab(:, (k-1)*(2^b)+1:k*(2^b)) = sparse(tmp');

end
y_matlab = sparse(y_matlab);

fprintf('diff = %g\n', norm(y_mex - y_matlab, 'fro'));
