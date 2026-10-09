imgtest = im2double(imread('../data/imgtest.tif'));
imgtrain = im2double(imread('../data/imgtrain.tif'));

truthtest = imread('../data/truthtest.png');
truthtrain = imread('../data/truthtrain.png');

%%
X_test = reshape(imgtest, [], 3);
X_train = reshape(imgtrain, [], 3);

Y_test = reshape(truthtest, [], 1);
Y_train = reshape(truthtrain, [], 1);

%% Use "imgtrain.tif" and "truthtrain.png" to train the neural network
Mdl = fitcnet(X_train, Y_train, LayerSizes=10);

%% (a) Report the segmented test image.
labels = predict(Mdl, X_test);
imshow(reshape(labels, size(truthtest)));

%% (b) Compare your result with the ground truth image. Report the overall error.
error = mean(labels ~= Y_test) * 100
%{
error =

   18.5796
%}


%% In addition, compute the 2x2 confusion matrix C
confusionmat = confusionmat(Y_test, labels)
confusionchart(Y_test, labels)
%{
confusionmat =

       63375       11995
       10765       36365
%}