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

unit_cell_small = uint8(zeros(size(M_small)));

unit_cell_small(M_D_small) = 1;
unit_cell_small(FL_D_small) = 1;
unit_cell_small(FT_D_small) = 1;

unit_cell_small(M_small) = 50;
unit_cell_small(FL_small) = 100;
unit_cell_small(FT_small) = 150;








