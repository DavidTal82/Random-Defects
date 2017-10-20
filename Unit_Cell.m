% This script loads the unit cell nodes and creats a 3D binary data files
% that are the unit cell phases (matrix, LT and TT)

clear
close all

%% Loading
load('C:\Users\operator\Documents\MATLAB\Matlab_Research\8HW_UnitCell\S200HFiberL.mat');
load('C:\Users\operator\Documents\MATLAB\Matlab_Research\8HW_UnitCell\S200HFiberT.mat');
load('C:\Users\operator\Documents\MATLAB\Matlab_Research\8HW_UnitCell\S200HMatrix.mat');

M = S200HMatrix(:,2:4);
FL = S200HFiberL(:,2:4);
FT = S200HFiberT(:,2:4);

% figure;
% subplot(131),plot3(FT(:,1),FT(:,2),FT(:,3),'b.'),grid on;
% subplot(132),plot3(FL(:,1),FL(:,2),FL(:,3),'r.'),grid on;
% subplot(133),plot3(M(:,1),M(:,2),M(:,3),'g.'),grid on;


%% Shifting everything to the origin
x_shift = abs(min(M(:,1)));
y_shift = abs(min(M(:,2)));
z_shift = abs(min(M(:,3)));

FL(:,1) = FL(:,1) + x_shift;
FL(:,2) = FL(:,2) + y_shift;
FL(:,3) = FL(:,3) + z_shift;

FT(:,1) = FT(:,1) + x_shift;
FT(:,2) = FT(:,2) + y_shift;
FT(:,3) = FT(:,3) + z_shift;

M(:,1) = M(:,1) + x_shift;
M(:,2) = M(:,2) + y_shift;
M(:,3) = M(:,3) + z_shift;



%% Multiplication factor
m_f = 10^3;

FL  = (round(m_f.*FL));
FT = (round(m_f.*FT));
M = (round(m_f.*M));

FL = unique(FL,'rows');
FL = FL + 1;

FT = unique(FT,'rows');
FT = FT + 1;

M = unique(M,'rows');
M = M + 1;


shp_FL = alphaShape(FL(:,1),FL(:,2),FL(:,3));
alpha_R_FL = ceil(shp_FL.Alpha);
shp_FL = alphaShape(FL(:,1),FL(:,2),FL(:,3),alpha_R_FL);

shp_FT = alphaShape(FT(:,1),FT(:,2),FT(:,3));
alpha_R_FT = ceil(shp_FT.Alpha);
shp_FT = alphaShape(FT(:,1),FT(:,2),FT(:,3),alpha_R_FT);

% figure;
% subplot(131),plot3(FT(:,1),FT(:,2),FT(:,3),'b.'),axis equal,grid on;
% subplot(132),plot3(FL(:,1),FL(:,2),FL(:,3),'r.'),axis equal,grid on;
% subplot(133),plot3(M(:,1),M(:,2),M(:,3),'g.'),axis equal,grid on;


% figure,plot3(FL(:,1),FL(:,2),FL(:,3),'b.');
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;
% 
% figure,plot3(FT(:,1),FT(:,2),FT(:,3),'r.');
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;
% 
% figure,plot3(M(:,1),M(:,2),M(:,3),'g.');
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;
%  
% figure,plot(shp_FL);
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;
% 
% figure,plot(shp_FT);
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;


%% Unit Cell size
x_size = max(M(:,1))- min(M(:,1)) + 1;
y_size = max(M(:,2))- min(M(:,2)) + 1;
z_size = max(M(:,3))- min(M(:,3)) + 1;


%%
unit_cell = zeros(x_size,y_size,z_size);
unit_cell_M = false(x_size,y_size,z_size);
unit_cell_FL = false(x_size,y_size,z_size);
unit_cell_FT = false(x_size,y_size,z_size);


[qx,qy,qz] = meshgrid(1:x_size,1:y_size,1:z_size);

in_FL = inShape(shp_FL,qx,qy,qz);
in_FT = inShape(shp_FT,qx,qy,qz);

unit_cell_FL(in_FL) = 1;
unit_cell_FT(in_FT) = 1;
unit_cell_M(~(unit_cell_FL | unit_cell_FT)) = 1;

unit_cell(unit_cell_M) = 1;
unit_cell(unit_cell_FL) = 2;
unit_cell(unit_cell_FT) = 3;

% figure;plot3(qx(in_FL),qy(in_FL),qz(in_FL),'b.');grid on;axis equal;
% figure;plot3(qx(in_FT),qy(in_FT),qz(in_FT),'r.');grid on;axis equal;
% figure;plot3(qx(in_FL),qy(in_FL),qz(in_FL),'b.',...
%     qx(in_FT),qy(in_FT),qz(in_FT),'r.');grid on;axis equal;
% 
% figure,imagesc((squeeze(unit_cell(50,:,:)))');

%{
%% FL Morpholgy
temp = false(x_size+20,y_size+20,z_size+20);

linearInd = sub2ind(size(unit_cell_FL),FL(:,1),FL(:,2),FL(:,3));
unit_cell_FL(linearInd) = 1;

temp(11:end-10,11:end-10,11:end-10) = unit_cell_FL;

R = alpha_R_FL;
[xgrid, ygrid, zgrid] = meshgrid(-R:R);
SE = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= R);

%temp = imdilate(temp,SE);
temp = imfill(imdilate(temp,SE), 'holes');

SE1 = strel('disk',R+1);
for i = 1:size(temp,2)
    slice = squeeze(temp(:,i,:));
    slice = imerode(slice,SE1);
    temp(:,i,:) = reshape(slice,size(temp(:,i,:)));    
end
unit_cell_FL = temp(11:end-10,11:end-10,11:end-10);

%% FT Morpholgy
temp = false(x_size+20,y_size+20,z_size+20);

linearInd = sub2ind(size(unit_cell_FT),FT(:,1),FT(:,2),FT(:,3));
unit_cell_FT(linearInd) = 1;

temp(11:end-10,11:end-10,11:end-10) = unit_cell_FT;

R = alpha_R_FT;
[xgrid, ygrid, zgrid] = meshgrid(-R:R);
SE = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= R);

%temp = imdilate(temp,SE);
temp = imfill(imdilate(temp,SE), 'holes');

SE1 = strel('disk',R);
for i = 1:size(temp,1)
    slice = squeeze(temp(i,:,:));
    slice = imerode(slice,SE1);
    temp(i,:,:) = reshape(slice,size(temp(i,:,:)));    
end
unit_cell_FT = temp(11:end-10,11:end-10,11:end-10);

%%
unit_cell_M(~(unit_cell_FL | unit_cell_FT)) = 1;

figure,
subplot(5,2,1),imshow((squeeze(unit_cell_M(:,48,:)))');
subplot(5,2,3),imshow((squeeze(unit_cell_M(:,49,:)))');
subplot(5,2,5),imshow((squeeze(unit_cell_M(:,50,:)))');
subplot(5,2,7),imshow((squeeze(unit_cell_M(:,51,:)))');
subplot(5,2,9),imshow((squeeze(unit_cell_M(:,52,:)))');
subplot(5,2,2),imshow((squeeze(unit_cell_M(48,:,:)))');
subplot(5,2,4),imshow((squeeze(unit_cell_M(49,:,:)))');
subplot(5,2,6),imshow((squeeze(unit_cell_M(50,:,:)))');
subplot(5,2,8),imshow((squeeze(unit_cell_M(51,:,:)))');
subplot(5,2,10),imshow((squeeze(unit_cell_M(52,:,:)))');
%}

