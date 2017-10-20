function [I,Defects_mask,Matrix_mask,Fiber_mask] = mask_separation(File_name,Thresh)

I = rgb2gray(imread(File_name));
I = histeq(I);
I(I < 1) = 1;

I_background = ~clear_backgroung(I);
I(I_background) = 0;


% Defects_mask = zeros(size(I),'uint8');
% Matrix_mask = zeros(size(I),'uint8');
% Fiber_mask = zeros(size(I),'uint8');

Defects_mask = false(size(I));
Matrix_mask = false(size(I));
Fiber_mask = false(size(I));

Defects_mask(I <= Thresh.Defect.max) = 1;
Defects_mask(~I) = 0;

Fiber_mask(I >= Thresh.Fiber.min)= 1;

% Matrix_mask(I >= Thresh.Matrix.min) = 1;
% Matrix_mask( I > Thresh.Matrix.max )= 0;

Matrix_mask(~(I_background | Defects_mask | Fiber_mask)) = 1;

end



