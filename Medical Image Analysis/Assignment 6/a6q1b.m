
function [u_k] = denoise(u_0, n_iter, alpha, lambda)
    arguments
        u_0 (:,:) double
        n_iter (1,1) double = 1000
        alpha (1,1) double = 0.01
        lambda (1,1) double = 0.1
    end

    [n,~] = size(u_0);

    u_k = u_0;

    gradient = @(u, i) ...
        u(i) - u_0(i) - lambda * (...
            u(min(i+1,n)) + ...
            u(max(i-1,n)) + ...
            2*u(i));

    for k = 1:n_iter
        u_k_1 = u_k;

        for i = 1:n
            u_k_1(i) = u_k(i) - alpha * gradient(u_k, i);
        end

        u_k = u_k_1;
    end
end

%%
hw6data = load('../data/hw6data.mat');
u_0 = hw6data.u0;

%%
alphaValues = [0.01, 0.025, 0.05];
lambdaValues = [0.1, 0.25, 0.5, 0.65, 0.75];
nIter = 1000;

figure;
tiledlayout(3,5);

for i = 1:length(alphaValues)
    alpha = alphaValues(i);
    for j = 1:length(lambdaValues)
        lambda = lambdaValues(j);

        u = denoise(u_0, nIter, alpha, lambda);

        nexttile;
        imagesc(u);
        title(sprintf('alpha = %.2f, lambda = %.2f', alpha, lambda));
    end
end
