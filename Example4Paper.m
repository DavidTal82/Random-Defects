clear
close all

path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main');
path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Main_Functions');

PathName = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Reconstructed\20150908_Paper\';
PathName1 = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Existing_Data\';


load([PathName,'Volum_3D_M.mat'])
M_3D_Defects = volume_3D;
clear volume_3D

load([PathName,'Volum_3D_FL.mat'])
FL_3D_Defects = volume_3D;
clear volume_3D

load([PathName,'Volum_3D_FT.mat'])
FT_3D_Defects = volume_3D;
clear volume_3D

load([PathName1,'unit_cell_M.mat']);
load([PathName1,'unit_cell_FT.mat']);
load([PathName1,'unit_cell_FL.mat']);

unit_cell_FL2 = logical(interp3(single(unit_cell_FL),2));
unit_cell_FT2 = logical(interp3(single(unit_cell_FT),2));
unit_cell_M2 = logical(interp3(single(unit_cell_M),2));

%{
M_small = M_3D_Defects(1:500,1:500,:);
FL_small = FL_3D_Defects(1:500,1:500,:);
FT_small = FT_3D_Defects(1:500,1:500,:);
Unit_Cell_Visualization(M_small)
Unit_Cell_Visualization(FL_small)
Unit_Cell_Visualization(FT_small)
%}


%%%%%%%%%%%%%%%%%%%

M_small = unit_cell_M2(1:100,1:100,1:50);
FL_small = unit_cell_FL2(1:100,1:100,1:50);
FT_small = unit_cell_FT2(1:100,1:100,1:50);

M_D_small = M_3D_Defects(1:100,1:100,1:50);
FL_D_small = FL_3D_Defects(1:100,1:100,1:50);
FT_D_small = FT_3D_Defects(1:100,1:100,1:50);

M_cell = M_small;
FL_cell = FL_small;
FT_cell = FT_small;

clear unit_cell_M2 unit_cell_FL2 unit_cell_FT2
clear  M_3D_Defects FL_3D_Defects FT_3D_Defects

FL_cell(FL_D_small) = 0;
FT_cell(FT_D_small) = 0;
M_cell(M_D_small) = 0;


%{
cell = uint8(zeros(size(M_small)));
cell(M_small) = 0;
cell(FL_small) = 50;
cell(FT_small) = 100;

cell(M_D_small) = 155;
cell(FL_D_small) = 205;
cell(FT_D_small) = 255;

cell(1,:,1) = 0;
cell(1,:,2) = 50;
cell(1,:,3) = 100;
cell(1,:,4) = 155;
cell(1,:,5) = 205;
cell(1,:,6) = 255;

figure;
subplot(5,1,1),imagesc(squeeze(cell(:,50,:))'),axis equal,axis([1 100 1 50]);
subplot(5,1,2),imagesc(squeeze(cell(:,51,:))'),axis equal,axis([1 100 1 50]);
subplot(5,1,3),imagesc(squeeze(cell(:,52,:))'),axis equal,axis([1 100 1 50]);
subplot(5,1,4),imagesc(squeeze(cell(:,53,:))'),axis equal,axis([1 100 1 50]);
subplot(5,1,5),imagesc(squeeze(cell(:,54,:))'),axis equal,axis([1 100 1 50]);
%}



% [x_dim,y_dim,z_dim] = size(FT_cell);
% [x,y,z] = ndgrid(1:x_dim,1:y_dim,1:z_dim);
    

lin_ind_M = find(M_cell);
lin_ind_FL = find(FL_cell);
lin_ind_FT = find(FT_cell);

lin_ind_M_D = find(M_D_small);
lin_ind_FT_D = find(FT_D_small);
lin_ind_FL_D = find(FL_D_small);

[x_M,y_M,z_M] = ind2sub(size(M_cell),lin_ind_M);
[x_FL,y_FL,z_FL] = ind2sub(size(FL_cell),lin_ind_FL);
[x_FT,y_FT,z_FT] = ind2sub(size(FT_cell),lin_ind_FT);

[x_M_D,y_M_D,z_M_D] = ind2sub(size(M_cell),lin_ind_M_D);
[x_FL_D,y_FL_D,z_FL_D] = ind2sub(size(FL_cell),lin_ind_FL_D);
[x_FT_D,y_FT_D,z_FT_D] = ind2sub(size(FT_cell),lin_ind_FT_D);



% DT = delaunayTriangulation(x_FL,y_FL,z_FL);
shpM = alphaShape(x_M,y_M,z_M,1);
shpFL = alphaShape(x_FL,y_FL,z_FL,1);
shpFT = alphaShape(x_FT,y_FT,z_FT,1);

DT_M = delaunayTriangulation(shpM.Points(:,1),shpM.Points(:,2),shpM.Points(:,3));
DT_FL = delaunayTriangulation(shpFL.Points(:,1),shpFL.Points(:,2),shpFL.Points(:,3));
DT_FT = delaunayTriangulation(shpFT.Points(:,1),shpFT.Points(:,2),shpFT.Points(:,3));




figure
plot3(x_M,y_M,z_M,'.', x_FL,y_FL,z_FL,'.',x_FT,y_FT,z_FT,'.',...
    x_M_D,y_M_D,z_M_D,'.',x_FL_D,y_FL_D,z_FL_D,'.',x_FT_D,y_FT_D,z_FT_D,'.');
grid on,axis([1 45 1 100 1 50]);
xlabel('x'),ylabel('y'),zlabel('z');


figure
plot3(x_M,y_M,z_M,'.',x_FL,y_FL,z_FL,'.',x_FT,y_FT,z_FT,'.');
grid on
axis equal
xlabel('X'),ylabel('Y'),zlabel('Z');



figure
p = patch(isosurface(x_M,y_M,z_M,volume_3D,0.5));
set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
view(3)
camlight
lighting gouraud
grid on,axis([1 x_dim 1 y_dim 1 z_dim]);
axis equal
xlabel('X'),ylabel('Y'),zlabel('Z')


