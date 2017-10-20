%function [ output_args ] = UnitCellConstruction(Mu,Sigma,)
%UnitCellConstruction creats a 8HW unit cell with defects.
%   Detailed explanation goes here

%%
%%{
clear; close all; %clc;
path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main');
path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Main_Functions');
%%}

Path = 'C:\Users\operator\Documents\MATLAB\Matlab_Research\';
Data_Path = 'Main\Saved_Data\Stats_data\20150908_Paper\';

% Need to be in GUI:
el_dim = 50; % Ellipsoid array size = el_dim
Layer = 1; %number of layers around an ellipsoid

Flag = 3;
% FL: Flag = 1
% FT: Flag = 2
% M: Flag = 3

%% Loading Statistical Data
% Will be input for the function
switch Flag
    case {1,2}
        load([Path,Data_Path,'RV_FL.mat']);
        load([Path,Data_Path,'F_FL.mat']);
        load([Path,Data_Path,'Mu_FL.mat']);
        load([Path,Data_Path,'Sigma_FL.mat']);
        % pd is necessery for the angle distribution
        load([Path,Data_Path,'pd_FL.mat']);
        
        load([Path,Data_Path,'RV_FT.mat']);
        load([Path,Data_Path,'F_FT.mat']);
        load([Path,Data_Path,'Mu_FT.mat']);
        load([Path,Data_Path,'Sigma_FT.mat']);
        load([Path,Data_Path,'pd_FT.mat']);
        
    case 3
        load([Path,Data_Path,'RV_M.mat']);
        load([Path,Data_Path,'F_M.mat']);
        load([Path,Data_Path,'Mu_M.mat']);
        load([Path,Data_Path,'Sigma_M.mat']);
        load([Path,Data_Path,'pd_M.mat']);
end


%% Unit Cell Without Defects

% choice_unit_cell = ...
%     questdlg('Create or Load Unit Cell?','Unit Cell','Create','Load','Cancel','Cancel');
% switch choice_unit_cell
%     case 'Cancel'
%     case 'Create'
%         [unit_cell,unit_cell_FL,unit_cell_FT,unit_cell_M] = ...
%             FE_Unit_Cell_No_Defects(Path);
%     case 'Load'
% Need to be with GUI - Load selected files
load([Path,'Main\Saved_Data\Existing_Data\unit_cell.mat']);
switch Flag
    case 1
        load([Path,'Main\Saved_Data\Existing_Data\unit_cell_FL.mat']);
    case 2
        load([Path,'Main\Saved_Data\Existing_Data\unit_cell_FT.mat']);
    case 3
        load([Path,'Main\Saved_Data\Existing_Data\unit_cell_M.mat']);
end


%% Sacle Conversion
% Transformation between pixels to mm/in
SF = 2;

unit_cell = interp3(unit_cell,SF);
%{
switch Flag
    case 1
        unit_cell_FL = logical(interp3(single(unit_cell_FL),SF));
        vol = sum(sum(sum(unit_cell_FL)));
        
        FL_ind = find(unit_cell_FL);
        [x_FL,y_FL,z_FL] = ind2sub(size(unit_cell_FL),FL_ind);
        coor_xyz = [x_FL,y_FL,z_FL];
        clear FL_ind x_FL y_FL z_FL
        
    case 2
        unit_cell_FT = logical(interp3(single(unit_cell_FT),SF));
        vol = sum(sum(sum(unit_cell_FT)));
        
        FT_ind = find(unit_cell_FT);
        [x_FT,y_FT,z_FT] = ind2sub(size(unit_cell_FT),FT_ind);
        coor_xyz = [x_FT,y_FT,z_FT];
        clear FT_ind x_FT y_FT z_FT
        
    case 3
        unit_cell_M = logical(interp3(single(unit_cell_M),SF));
        vol = sum(sum(sum(unit_cell_M)));
        
        M_ind = find(unit_cell_M);
        [x_M,y_M,z_M] = ind2sub(size(unit_cell_M),M_ind);
        coor_xyz = [x_M,y_M,z_M];
        clear M_ind x_M y_M z_M
end
%}
switch Flag
    case 1
        phase = logical(interp3(single(unit_cell_FL),SF));
    case 2
        phase = logical(interp3(single(unit_cell_FT),SF));
    case 3
        phase = logical(interp3(single(unit_cell_M),SF));
end
vol = sum(sum(sum(phase)));

phase_ind = find(phase);
[x_phase,y_phase,z_phase] = ind2sub(size(phase),phase_ind);
coor_xyz = [x_phase,y_phase,z_phase];
clear x_phase y_phase z_phase
% end


%% Array Alocation

% Defected_UC = uint8(zeros(size(unit_cell)));
Defects = zeros(50000,9);
Defects_rejected = zeros(50000,9);

%% Volume Fraction

% prompt = {'Enter Volume Fraction of Defects:'};
% dlg_title = 'Volume Fraction Input';
% num_lines = 1;
% def = {'0.01'};
% inp = inputdlg(prompt,dlg_title,num_lines,def);
% vf = str2double(inp);


%% Embadding Defects in the Unit Cell

% if ~exist('vf','var')
vf = 0.03;
% end

[x_dim,y_dim,z_dim] = size(unit_cell);

[x,y,z] = meshgrid(1:x_dim,1:y_dim,1:z_dim);
% xx=x(:);yy=y(:);zz=z(:);

volume_3D = false(size(x));
volume_3D_re = false(size(x));


switch Flag
    case {1,2}
        Yq = RV_FT(:,2); % query points for b-c data
        % a-b are taken from FL
        % b is a query point for FT (b_FL -> a_FT)
        % providing a distribution of c given b
    case 3
end

% Embbading defects for FL
%%%%%%%%%%%%%%%%%%%%%%%%%%
% volume_3D_temp = false(size(x));
% ellipsoid_3D  = false(size(x));

vf_temp = 0;
n = 0;
m = 0;
rejected_b = 0;
rejected_p = 0;

while (vf_temp < vf)
    m = m+1;
    % volume_3D_temp = volume_3D;
    volume_3D_temp = false(size(x));
    
    switch Flag
        case {1,2}
            pd_angle_FL = pd_FL{1,5};% In rad
            pd_angle_FT = pd_FT{1,5};% in rad
            %%% Ellipsoid Axis
            r = mvnrnd(Mu_FL,Sigma_FL);
            a = r(1);
            b = r(2);
        case 3
            pd_angle_M = pd_M{1,5};% in rad
            r = mvnrnd(Mu_M,Sigma_M);
            a = r(1);
            b = r(2);
    end
    
    %     %%% Ellipsoid Axis
    %     r = mvnrnd(Mu_FL,Sigma_FL);
    %     a = r(1);
    %     b = r(2);
    
    if b < 1 || a < 1 || a < b
        continue
    end
    
    switch Flag
        case {1,2}
            % finding c given b
            Xq = b*ones(size(Yq));
            Fc_pdf = interp2(RV_FT(:,1),RV_FT(:,2),F_FT,Xq,Yq);
            % PDF of c given b
            Fc_pdf =  Fc_pdf / sum(Fc_pdf);
            
            % The support of c
            Yq_c = Yq( round(cumsum(Fc_pdf),5) < 1);
            % The pdf of c
            Fc_pdf(round(cumsum(Fc_pdf),5) >= 1) = [];
            % Kernel pd of c
            if isempty(Yq_c) || any(isnan(Yq_c)) || any(isinf(Yq_c));
                continue
            end
            pd_c = pdf2pd(Yq_c,Fc_pdf);
            % Random c from the pd of c
            c = random(pd_c);
        case 3
            c = b*rand;
    end
    
    
    
    if b < c
        continue
    end
    
    %     dis_xy = round(a + 10);
    %     if dis_xy >= (min([x_dim,y_dim])/2)
    %         continue
    %     end
    %%% Ellipsoid Axis
    
    %%% Ellipsoid Center
    %{
    % Random x,y,z from the unit cell dimensions
    xc = randi([dis_xy,x_dim-dis_xy]);
    yc = randi([dis_xy,y_dim-dis_xy]);
    zc = randi([0,z_dim]);
    %}
    
    % Random x,y,z based on the FL location
    % coor_xyz: all the x,y,z coordinates of the phase
    % one row of coor_xyz is selcted randomly
    % randi(imax) returns a pseudorandom scalar integer between 1 and imax
    coor_ind = randi(length(coor_xyz));
    xc = coor_xyz(coor_ind,1);
    yc = coor_xyz(coor_ind,2);
    zc = coor_xyz(coor_ind,3);
    %%% Ellipsoid Center
    
    %%% Ellipsoid Rotation
    switch Flag
        case 2
            The = random(pd_angle_FL);
            % Rotation in the x-z plane (about y) taken from FL
            Phi = random(pd_angle_FT);
            % Rotation in the y-z plane (about x) taken from FT
            % Psi - no pd and using pd_FT
            Psi = random(pd_angle_FT);
        case 1
            Phi = random(pd_angle_FL);
            % Rotation in the x-z plane (about y) taken from FL
            The = random(pd_angle_FT);
            % Rotation in the y-z plane (about x) taken from FT
            % Psi - no pd and using pd_FT
            Psi = random(pd_angle_FT);
        case 3
            Phi = random(pd_angle_M);
            The = random(pd_angle_M);
            Psi = random(pd_angle_M);
    end
    %%% Ellipsoid Rotation
    
    %{
    %Testing Data
    a=32.637585092215360;
    b=8.538935144647539;
    c=5.924421744393616;
    
    Phi = 3.007199709894202;
    Psi = 2.814812279522977;
    The = 3.188948205655232;
    
    xc = 122;
    yc = 898;
    zc = 12;
    %}
    
    %%% Ellipsoid Generation
    %     [XYZ_in,XYZ_out] = ...
    %         Modification_ellipsoid_generation(Layer,a,b,c,xc,yc,zc,Phi,The,Psi,el_dim);
    
    [XYZ_in,XYZ_out] = ...
        ellipsoid_generation(Layer,a,b,c,xc,yc,zc,Phi,The,Psi,el_dim);
    
    XYZ_in = unique(round(XYZ_in),'rows');
    XYZ_out = unique(round(XYZ_out),'rows');
    
    % plot3(x_el,y_el,z_el,'.',coor(:,1),coor(:,2),coor(:,3),'o');
    % axis equal;grid on;
    
    % Dissagreement between the X,Y,Z in coordinates and in array indices
    
    % Rejecting the objects that are outside the unit cell
    if     min(XYZ_out(:,1)) < 1 || max(XYZ_out(:,1)) > x_dim
        disp('Out of Bounderies');
        rejected_b = rejected_b + 1;
        continue
    elseif min(XYZ_out(:,2)) < 1 || max(XYZ_out(:,2)) > y_dim
        disp('Out of Bounderies');
        rejected_b = rejected_b + 1;
        continue
    elseif min(XYZ_out(:,3)) < 1 || max(XYZ_out(:,3)) > z_dim
        disp('Out of Bounderies');
        rejected_b = rejected_b + 1;
        continue
    end
    
    % Deleting the points outside the unit cell
    %{
    coor(coor(:,1) < 2,:) = [];
    coor(coor(:,1) > x_dim - 1,:) = [];
    coor(coor(:,2) < 2,:) = [];
    coor(coor(:,2) > y_dim - 1,:) = [];
    coor(coor(:,3) < 2,:) = [];
    coor(coor(:,3) > z_dim - 1,:) = [];
    %}
    
    %%%% XYZ 1 2 3 OR 2 1 3 ?!?!? CHECK!!!!
    %%%% FL - FT adjustment
    linearInd_out = sub2ind(size(x),XYZ_out(:,1),XYZ_out(:,2),XYZ_out(:,3));
    linearInd_in = sub2ind(size(x),XYZ_in(:,1),XYZ_in(:,2),XYZ_in(:,3));
    volume_3D_temp(linearInd_out) = 1;
    
    if any(any(any(and(volume_3D_temp,~phase))));
        volume_3D_re(linearInd_in) = 1;
        disp('Out of Phase');
        rejected_p = rejected_p +1;
        Defects_rejected(rejected_p,:) = [xc,yc,zc,a,b,c,Phi,The,Psi];
        continue
    else
        volume_3D_temp = and(volume_3D_temp,phase);
    end
    
    
    % Unit_Cell_Visualization(volume_3D_temp)
    
    if (any(any(any(and(volume_3D_temp,volume_3D)))))
        disp('Over Lapping');
        continue
    else
        volume_3D(linearInd_in) = 1;
        n = n+1;
        vf_temp = sum(sum(sum(volume_3D)))/vol;
        Defects(n,:) = [xc,yc,zc,a,b,c,Phi,The,Psi];
        disp1 = sprintf('%d',n);
        disp2 = sprintf('%0.4f',vf_temp);
        disp([disp1,'   ',disp2]);
    end
    
    % lin_ind = find(ellipsoid_3D);
    % [x_el,y_el,z_el] = ind2sub(size(ellipsoid_3D),lin_ind);
    % shp = alphaShape(x_el,y_el,z_el);
    % plot(shp);
end
Defects(n+1:end,:) = [];
Defects_rejected(rejected_p+1:end,:) = [];
vf_temp


%%
% end %end of function
