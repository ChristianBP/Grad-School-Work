brain = load('../data/brain.mat').brain;

%%
imageSegmenter(brain);

%%
mask = roipoly(mat2gray(brain));

%%
imshow(mask)

%%
bw = activecontour(brain,mask,1000,"edge");

figure
imshow(brain,[])
hold on
visboundaries(bw,'Color','r');
hold off

%%
bw = activecontour(brain,mask,1000);

figure
imshow(brain,[])
hold on
visboundaries(bw,'Color','r');
hold off

