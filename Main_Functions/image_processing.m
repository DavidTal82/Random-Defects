function [I_out,Segout]=image_processing(I1_in,I2_in)



%% Clearing Borders
I1 = imclearborder(I2_in, 4);

%% Image Morphology: Image opening and closing using a disc
se = strel('disk',2);
I_out = imclose(imopen(logical(I1),se),se);
%I_out = image_morphology(I1);

%% Image Outline
outline = bwperim(I_out);
Segout = I1_in;
Segout(outline) = 255;


