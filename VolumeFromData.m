clear; close all; %clc;


el_dim = 50; % Ellipsoid array size = el_dim
Layer = 3; %number of layers around an ellipsoid

Flag = 3;
% FL: Flag = 1
% FT: Flag = 2
% M: Flag = 3




%% Unit Cell Without Defects
load('UnitCell.mat');
switch Flag
    case 1
        load('FLCell.mat');
        load('FLDefects.mat');
        phase = FLCell;
    case 2
        load('FTCell.mat');
        load('FTDefects.mat');
        phase = FTCell;
    case 3
        load('MCell.mat');
        load('MDefects.mat');
        phase = MCell;
end

[x_dim,y_dim,z_dim] = size(UnitCell);

[x,y,z] = meshgrid(1:x_dim,1:y_dim,1:z_dim);

volume_3D = false(size(x));


for m = 1:length(Defects)
    volume_3D_temp = false(size(x));
    
    xc = Defects(m,1);
    yc = Defects(m,2);
    zc = Defects(m,3);
    a = Defects(m,4);
    b = Defects(m,5);
    c = Defects(m,6);
    Phi = Defects(m,7);
    The = Defects(m,8);
    Psi = Defects(m,9);
    
    [XYZ_in,XYZ_out] = ...
        ellipsoid_generation(Layer,a,b,c,xc,yc,zc,Phi,The,Psi,el_dim);
    
    XYZ_in = unique(round(XYZ_in),'rows');
    XYZ_out = unique(round(XYZ_out),'rows');
 
    %%%% FL - FT adjustment
    linearInd_out = sub2ind(size(x),XYZ_out(:,1),XYZ_out(:,2),XYZ_out(:,3));
    linearInd_in = sub2ind(size(x),XYZ_in(:,1),XYZ_in(:,2),XYZ_in(:,3));
    volume_3D_temp(linearInd_out) = 1;

     volume_3D_temp = and(volume_3D_temp,phase);
    volume_3D(linearInd_in) = 1;

end

