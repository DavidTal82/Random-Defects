function [I_temp]=clear_backgroung(I)
%Clearing the outer parimeter of an image
% This clears the backgroung of the image
% The function returnes a logical array where 0 is background and 1 is
% image

SE1 = strel('square', 10);
SE2 = strel('square', 10);
SE3 = strel('square', 20);

%figure,imshow(I);

[~, threshold] = edge(I, 'sobel');
fudgeFactor = 0.5;

I_temp = edge(I,'sobel', threshold * fudgeFactor);
%figure,imshow(I_temp);

I_temp = imdilate(I_temp, SE1);
%figure,imshow(I_temp);

I_temp = imfill(I_temp, 'holes');
%figure,imshow(I_temp);

I_temp = imdilate(I_temp, SE2);
%figure,imshow(I_temp);

I_temp = imerode(I_temp,SE3);
%figure,imshow(I_temp);

end