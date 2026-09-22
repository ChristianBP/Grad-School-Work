%% 1
I = [[0, 0, 1, 2, 4];
    [0, 1, 1, 3, 4];
    [1, 1, 3, 4, 1];
    [1, 3, 4, 1, 1];
    [3, 4, 1, 0, 0]];

J = imresize(I, [8 8], 'bilinear');
J(5,3);
figure
imagesc(I)
axis image;
figure
imagesc(J)
axis image;

%% 3
x=-5:0.05:5;
y=-6:0.05:6;
[X,Y] = meshgrid(x,y);

circle = X.^2 + Y.^2 <= 1.5;
rect = (X >= -2.5 & X <= 2.5) & (Y >= -3 & Y <= 3);
image = circle + rect;

imagesc(x, y, image);
axis image;
colormap([0 0 0
        0.5 0.5 0.5
        1 1 1]);


%% 4
brainH = imread("../data/brainH.jpg");
brainL = imread("../data/brainL.jpg");

nn_int = imresize(brainL, [256 256], Method="nearest");
bilinear_int = imresize(brainL, [256 256], Method="bilinear");
bicubic_int = imresize(brainL, [256 256], Method="bicubic");

figure
imshow(brainL)
title("Brain L")

figure
imshow(brainH)
title("Brain H")

figure
imshow(nn_int)
title("Nearest Neighbor")

figure
imshow(bilinear_int)
title("Bilinear")

figure
imshow(bicubic_int)
title("Bicubic")