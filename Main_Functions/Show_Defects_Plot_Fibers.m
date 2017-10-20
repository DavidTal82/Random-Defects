%function Show_Defects_Plot_Fibers(I,Cracks_FT,Pores_FT,Cracks_FL,Pores_FL)



%%{
clear
close all

PathName = 'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Saved_Data\Existing_Data';
load([PathName,'\segout.mat']);
load([PathName,'\Images']);
load([PathName,'\20150908_Paper\Cracks_Im.mat']);
load([PathName,'\20150908_Paper\Pores_Im.mat']);
%%}


%geo=[x,y,a,b,angle(rad),b/a,volume];

% figure;
% subplot(2,2,1),imshow(I),title('Original Image');
% subplot(2,2,2),imshow(Defects),title('Defects Mask');
% subplot(2,2,3),imshow(Segout),title('Outlined');
% subplot(2,2,4),imshow(Defects_processed),ellipse(geo(:,1),geo(:,2),geo(:,3)/2,geo(:,4)/2,angle(:),'r');

for im = 1:size(Images,3)
    Cracks_FL = Cracks_Im(im).FL;
    Cracks_FT = Cracks_Im(im).FT;
    Pores_FL = Pores_Im(im).FL;
    Pores_FT = Pores_Im(im).FT;
    
h = figure;
imshow(Images(:,:,im)),
ellipse(Cracks_FT(:,1),Cracks_FT(:,2),Cracks_FT(:,3)/2,Cracks_FT(:,4)/2,Cracks_FT(:,5),'g');
ellipse(Pores_FT(:,1),Pores_FT(:,2),Pores_FT(:,3)/2,Pores_FT(:,4)/2,Pores_FT(:,5),'g');
ellipse(Cracks_FL(:,1),Cracks_FL(:,2),Cracks_FL(:,3)/2,Cracks_FL(:,4)/2,Cracks_FL(:,5),'y');
ellipse(Pores_FL(:,1),Pores_FL(:,2),Pores_FL(:,3)/2,Pores_FL(:,4)/2,Pores_FL(:,5),'y');

h = tightfig(h);
end