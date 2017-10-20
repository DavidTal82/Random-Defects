clear all
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

% load([PathName1,'unit_cell_M.mat']);
load([PathName1,'unit_cell_FT.mat']);
load([PathName1,'unit_cell_FL.mat']);

% unit_cell_M2 = logical(interp3(single(unit_cell_M),2));
unit_cell_FL2 = logical(interp3(single(unit_cell_FL),2));
unit_cell_FT2 = logical(interp3(single(unit_cell_FT),2));


%%
FL_processed = false(size(unit_cell_FL2));
FT_processed = false(size(unit_cell_FT2));

dx = 100;

A = false(size(unit_cell_FL2,1),dx);

for i = 10%1:size(unit_cell_FL2,1);
    
    B = squeeze(unit_cell_FL2(i,:,:));
    C = [A,B,A];
    
    
    C = (imopen(C,strel('disk',5)));
    C = (imclose(C,strel('disk',5)));
    
    C(:,1:dx) = [];
    C(:,size(unit_cell_FL2,3)+1:end) = [];
    FL_processed(i,:,:) = C;
  
    
end

A = false(size(unit_cell_FT2,2),dx);

for j = 1:size(unit_cell_FT2,2);
    
    B = squeeze(unit_cell_FT2(:,j,:));
    C = [A,B,A];
    
    
    C = (imopen(C,strel('disk',10)));
    C = (imclose(C,strel('disk',10)));
    
    C(:,1:dx) = [];
    C(:,size(unit_cell_FL2,3)+1:end) = [];
    FT_processed(:,j,:) = C;
end

M_processed = ~(FT_processed | FL_processed);


%{
for j = 1:100%size(unit_cell_FL2,1);
    
   figure;
   imshow(squeeze(FT_processed(:,j,:))');

end
%}




