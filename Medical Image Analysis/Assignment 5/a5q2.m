function [J] = sim_annealing(I, n_iter, c, C)
    arguments
        I (:,:) double
        n_iter (1,1) double = 100
        c (1,1) double = 100
        C (1,1) double = 10
    end

    [n, m] = size(I);

    J = randi([0 1], n, m);
    J_new = J;

    for k = 1:n_iter
        T = C / log(1 + k);

        for row = 1:n
            for col = 1:m

                I_alpha = I(row, col);
                J_beta = [];
                if row > 1, J_beta(end+1) = J(row-1, col); end
                if row < n, J_beta(end+1) = J(row+1, col); end
                if col > 1, J_beta(end+1) = J(row, col-1); end
                if col < m, J_beta(end+1) = J(row, col+1); end

                E = @(J_alpha) -c*(( I_alpha - J_alpha ).^ 2) - sum((J_beta - J_alpha) .^ 2);

                p = exp(E(1)/T) / ( exp(E(1)/T) + exp(E(0)/T) );

                if rand < p
                    J_new(row, col) = 1;
                else
                    J_new(row, col) = 0;
                end
            end
        end
    end

    J = J_new;
end

%%
HW5Image = load('../data/HW5Image.mat');
img = HW5Image.I;

%%
cValues = [1, 5, 20, 50, 100];
CValues = [1, 5, 20, 50, 100];
nIter = 1000;

figure;
tiledlayout(5,5);

for i = 1:length(cValues)
    c = cValues(i);
    for j = 1:length(CValues)
        C = CValues(j);

        J = sim_annealing(img, nIter, c, C);

        nexttile;
        imagesc(J);
        colormap(gca, gray);
        axis image off;
        title(sprintf('c = %.1f, C = %.1f', c, C));
    end
end
