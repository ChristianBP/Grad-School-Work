%% Load Images
brainH = im2double(imread("../data/brainH.jpg"));
brain_gaussion_noise = im2double(imread("../data/brain_gaussion_noise.jpg"));
brain_poisson_noise = im2double(imread("../data/brain_poisson_noise.jpg"));
brain_salt_and_pepper_noise = im2double(imread("../data/brain_salt_and_pepper_noise.jpg"));

% Signal to Noise function
SNR = @(I) 10 * log10(sum(I.^2,'all') / sum((I-brainH).^2, 'all'));

%% Brain H
figure
imshow(brainH)
title("Brain H")


%%
% For each filter, try different parameters and report the parameters corresponding to the best denoising performance you get.

%% AVERAGE FILTER
function average_filter(I, label, SNR)
    sizes = [3 5 7 11 15];
    padding_options = ["default", "symmetric", "replicate", "circular"];
    results = table(...
        'Size', [numel(sizes), numel(padding_options)], ...
        'RowNames', string(sizes), ...
        'VariableNames', padding_options, ...
        'VariableTypes', repmat({'double'}, 1, numel(padding_options)));

    fprintf(label + ' Noise\n')
    fprintf("Average Filter\n")
    for i = 1:numel(sizes)
        for j = 1:numel(padding_options)
            if padding_options(j) == "default"
                img = imfilter(I, fspecial('average', sizes(i)));
            else
                img = imfilter(I, fspecial('average', sizes(i)), padding_options(j));
            end
            results{i,j} = SNR(img);
        end
    end
    disp(results)
end

%% Gaussian
average_filter(brain_gaussion_noise, "Gaussian", SNR)

%% Poisson
average_filter(brain_poisson_noise, "Poisson", SNR)

%% Salt and Pepper
average_filter(brain_salt_and_pepper_noise, "Salt and Pepper", SNR)



%{

Best performance for Average Filter is:

     Noise           Padding              Size
-----------------------------------------------
    Gaussian       default (fill 0s)      3x3
    Poisson            tied               3x3
Salt and Pepper    default (fill 0s)      3x3

%}



%% MEDIAN FILTER
function median_filter(I, label, SNR)
    sizes = [3 5 7 11 15];
    padding_options = ["zeros", "symmetric", "indexed"];
    results = table(...
        'Size', [numel(sizes), numel(padding_options)], ...
        'RowNames', string(sizes), ...
        'VariableNames', padding_options, ...
        'VariableTypes', repmat({'double'}, 1, numel(padding_options)));

    fprintf(label + ' Noise\n')
    fprintf("Median Filter\n")
    for i = 1:numel(sizes)
        for j = 1:numel(padding_options)
            img = medfilt2(I, [sizes(i) sizes(i)], padding_options(j));
            results{i,j} = SNR(img);
        end
    end
    disp(results)
end

%% Gaussian
median_filter(brain_gaussion_noise, "Gaussian", SNR)

%% Poisson
median_filter(brain_poisson_noise, "Poisson", SNR)

%% Salt and Pepper
median_filter(brain_salt_and_pepper_noise, "Salt and Pepper", SNR)

%{

Best performance for Median Filter is:

     Noise           Padding              Size
-----------------------------------------------
    Gaussian          zeros               3x3
    Poisson   tied (zeros/symmetric)      3x3
Salt and Pepper       zeros               3x3

%}




%% GAUSSIAN FILTER
function gaussian_filter(I, label, SNR)
    sizes = [3 5 7 11 15];
    sigmas = [0.25 0.5 1 1.5 3];
    results = table(...
        'Size', [numel(sizes), numel(sigmas)], ...
        'RowNames', string(sizes), ...
        'VariableNames', string(sigmas), ...
        'VariableTypes', repmat({'double'}, 1, numel(sigmas)));


    fprintf(label + ' Noise\n')
    fprintf("Gaussian Filter\n")
    for i = 1:numel(sizes)
        for j = 1:numel(sigmas)
            img = imfilter(I, fspecial('gaussian', sizes(i), sigmas(j)));
            results{i,j} = SNR(img);
        end
    end
    disp(results)
end

%% Gaussian
gaussian_filter(brain_gaussion_noise, "Gaussian", SNR)

%% Poisson
gaussian_filter(brain_poisson_noise, "Poisson", SNR)

%% Salt and Pepper
gaussian_filter(brain_salt_and_pepper_noise, "Salt and Pepper", SNR)



%{

Best performance for Gaussian Filter is:

     Noise           Sigma              Size
--------------------------------------------------
    Gaussian           1                3x3
    Poisson           0.5       tied (5x5...15x15)
Salt and Pepper        1        tied (7x7...15x15)

%}




%% ANISOTROPIC DIFFUSION FILTER
function anisotropic_diffusion_filter(I, label, SNR)
    iterations = [5 10 20];
    gradient_thresholds = [0.01 0.05 0.1 0.5];
    results = table(...
        'Size', [numel(iterations), numel(gradient_thresholds)], ...
        'RowNames', string(iterations), ...
        'VariableNames', string(gradient_thresholds), ...
        'VariableTypes', repmat({'double'}, 1, numel(gradient_thresholds)));

    fprintf(label + ' Noise\n')
    fprintf("Anisotropic Diffusion Filter\n")
    for i = 1:numel(iterations)
        for j = 1:numel(gradient_thresholds)
            img = imdiffusefilt(I,...
                'NumberOfIterations', iterations(i),...
                'GradientThreshold', gradient_thresholds(j));
            results{i,j} = SNR(img);
        end
    end
    disp(results)
end

%% Gaussian
anisotropic_diffusion_filter(brain_gaussion_noise, "Gaussian", SNR)

%% Poisson
anisotropic_diffusion_filter(brain_poisson_noise, "Poisson", SNR)

%% Salt and Pepper
anisotropic_diffusion_filter(brain_salt_and_pepper_noise, "Salt and Pepper", SNR)


%{

Best performance from my testing for Anisotropic Diffusion Filter is:

     Noise       Iterations    Gradient Threshold
--------------------------------------------------
    Gaussian        20               0.1
    Poisson         5                0.1
Salt and Pepper     20               0.5

%}




%%
% Plots of the resulting images using parameters with best denoising performance.

function apply_filters(I, label, SNR, avg_params, gaussian_params, anisotropic_diffusion_params)
    avg_filter = fspecial('average', avg_params{:});
    gaussian_filter = fspecial('gaussian', gaussian_params{:});

    filter_labels = {"No",...
                    "Average",...
                    "Median",...
                    "Gaussian",...
                    "Anisotropic Diffusion"};
    images        = {I,...
                    imfilter(I, avg_filter),...
                    medfilt2(I),...
                    imfilter(I, gaussian_filter),...
                    imdiffusefilt(I, anisotropic_diffusion_params)};

    fprintf("Best Denoising Performance for %s Noise\n", label)
    fprintf("%s\n", repmat('-', 1, 40))
    fprintf("%-23s | SNR\n", "Filter");
    fprintf("%s\n", repmat('-', 1, 40))
    for i = 1:length(images)
        filter_label = filter_labels{i};
        img = images{i};

        figure
        imshow(img)
        title(filter_label + " Filter - " + label)
        fprintf("%-23s | %f\n", filter_label, SNR(img));
    end
    fprintf("\n")
end

%% Gaussian
gaussian_best_performance_params = {{}, {[3 3], 1}, struct('GradientThreshold', 0.1, 'NumberOfIterations', 20)};
apply_filters(brain_gaussion_noise, "Gaussian", SNR, gaussian_best_performance_params{:})

%% Poisson
poisson_best_performance_params = {{}, {[5 5], 0.5}, struct('GradientThreshold', 0.1, 'NumberOfIterations', 5)};
apply_filters(brain_poisson_noise, "Poisson", SNR, poisson_best_performance_params{:})

%% Salt and Pepper
snp_best_performance_params = {{}, {[7 7], 1}, struct('GradientThreshold', 0.5, 'NumberOfIterations', 20)};
apply_filters(brain_salt_and_pepper_noise, "Salt and Pepper", SNR, snp_best_performance_params{:})




%% Comment on which works best in enhancing each image. Evaluate the SNR (signal-to-noise-ratio) before denoising and after denoising for all methods.

%{

The best filter for both Gaussian and Salt and Pepper noise was the median filter. The filter had a dramatic effect on the image with Salt and Pepper noise.
That image began with an SNR of 4.94. After median filtering, the SNR was 16.72. This is significantly higher than the second best filter (Gaussian 10.85).

In comparison, the image with Gaussian noise began with SNR=8.49. After median filtering, the SNR was 12.45. The next best filter (Gaussian filter) was competitive at 12.04 SNR.

For Poisson noise, the image began with 14.97 SNR and the highest performance was the Gaussian filter with SNR 17.72. Anisotropic diffusion followed right behind at 17.21 SNR.

%}
