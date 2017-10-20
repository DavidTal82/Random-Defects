function [ I_out_T , I_out_L ] = tow2TransLong( I_in , max_dist_T , max_dist_L )
%tow2TransLong separates the fiber phase in to transverse and
%longitudinal fiber

if ~exist('max_dist_T','var'); max_dist_T = 5; end
if ~exist('max_dist_L','var'); max_dist_L = 30; end

se = strel('disk',3);
se_T = strel('diamond',max_dist_T);
se_L = strel('diamond',max_dist_L-10);

I_out_T = bwareafilt(I_in,[1 5]);
I_out_L = bwareafilt(I_in,[10 10000]);

% figure;
% subplot(1,2,1),imshow(I_out_T)
% subplot(1,2,2),imshow(I_out_L)

I_out_T = imopen(imclose(logical(I_out_T),se),se);
I_out_L = imopen(imclose(logical(I_out_L),se),se);

D_T = bwdist(I_out_T);
D_L = bwdist(I_out_L);

% figure;
% subplot(1,2,1),imshow(I_out_T)
% subplot(1,2,2),imshow(I_out_L)

I_out_T = logical(D_T <= max_dist_T );
I_out_L = logical(D_L <= max_dist_L );

% figure;
% subplot(1,2,1),imshow(I_out_T)
% subplot(1,2,2),imshow(I_out_L)

I_out_T = imfill(I_out_T,'holes');
I_out_L = imfill(I_out_L,'holes');

% figure;
% subplot(1,2,1),imshow(I_out_T)
% subplot(1,2,2),imshow(I_out_L)

I_out_T = imerode(I_out_T,se_T);
I_out_L = imerode(I_out_L,se_L);

% figure;
% subplot(1,2,1),imshow(I_out_T)
% subplot(1,2,2),imshow(I_out_L)

I_out_T = smooth_objects(I_out_T);
I_out_L = smooth_objects(I_out_L);

% figure;
% subplot(1,2,1),imshow(I_out_T)
% subplot(1,2,2),imshow(I_out_L)

end

