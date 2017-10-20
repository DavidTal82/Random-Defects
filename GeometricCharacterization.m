function [D_Geo,Cracks,Pores,V,Del] = ...
    GeometricCharacterization(D_processed,FT,FL)
%GeometricCharacterization extracts the geometric parameters of defects
%   The function does the following:
%   1. Takes defects from the processed images and extract their
%      geometric parameter (ellipses - Xc, Yc, a, b, angle, b/a, area)
%   2. Divides defects to categories: cracks, pores, voids & delamination
%      based on the determined parameters
%   3. Divides defects to phases: longitudinal fibers, transverse fibers
%      & matrix.
%   4. Returns the geometric parameters 

num_images = size(D_processed,3);

%Geometric Parameters
a_crack_max = 50;
v_voids_max = 500;
a_voids_max = 100;
R_crack_max = 0.75; %minor-major axis ratio
R_delami_max = 0.1;

% D_Geo - the geometric parameters of all the defects
D_Geo = zeros(300*num_images,7);
C = zeros(300*num_images,7);
P = zeros(300*num_images,7);
V = zeros(300*num_images,7);
Del = zeros(300*num_images,7);

C_FT = zeros(300*num_images,7);
C_FL = zeros(300*num_images,7);
C_M = zeros(300*num_images,7);

P_FT = zeros(300*num_images,7);
P_FL = zeros(300*num_images,7);
P_M = zeros(300*num_images,7);

for im = 1:num_images;    
    %geo=[x,y,a,b,angle(rad),b/a,volume];
    geo_temp = get_Image_Data(D_processed(:,:,im));
    
    %Separation between the transverse and longditudinal fibers
    geo_temp_FT = get_Image_Data(D_processed(:,:,im) & FT(:,:,im));
    geo_temp_FL = get_Image_Data(D_processed(:,:,im) & FL(:,:,im));
    geo_temp_M = get_Image_Data(D_processed(:,:,im) & ~(FT(:,:,im) | FL(:,:,im))); 
    
    Cracks_temp = geo_temp(geo_temp(:,3) <= a_crack_max,:);
    Pores_temp = Cracks_temp(Cracks_temp(:,6) >= R_crack_max, :);
    Cracks_temp(Cracks_temp(:,6) >= R_crack_max, :) = [] ;
    
    Cracks_temp_FT = geo_temp_FT(geo_temp_FT(:,3) <= a_crack_max,:);
    Pores_temp_FT = Cracks_temp_FT(Cracks_temp_FT(:,6) >= R_crack_max, :);
    Cracks_temp_FT(Cracks_temp_FT(:,6) >= R_crack_max, :) = [] ;
    
    Cracks_temp_FL = geo_temp_FL(geo_temp_FL(:,3) <= a_crack_max,:);
    Pores_temp_FL = Cracks_temp_FL(Cracks_temp_FL(:,6) >= R_crack_max, :);
    Cracks_temp_FL(Cracks_temp_FL(:,6) >= R_crack_max, :) = [] ;
    
    Cracks_temp_M = geo_temp_M(geo_temp_M(:,3) <= a_crack_max,:);
    Pores_temp_M = Cracks_temp_M(Cracks_temp_M(:,6) >= R_crack_max, :);
    Cracks_temp_M(Cracks_temp_M(:,6) >= R_crack_max, :) = [] ;
    
    Voids_temp = geo_temp(geo_temp(:,3) > a_crack_max,:);
    %Delamination based on R
    Delamination_temp_R = Voids_temp(Voids_temp(:,6) <= R_delami_max,:);
    Voids_temp(Voids_temp(:,7) <= R_delami_max,:) = [];
    %Delamination based on volume
    Delamination_temp_V = Voids_temp(Voids_temp(:,7) >= v_voids_max,:);
    Voids_temp(Voids_temp(:,7) >= v_voids_max,:) = [];
    
    Delamination_temp = [Delamination_temp_R;Delamination_temp_V];
    clear Delamination_temp_R Delamination_temp_V
    
    Cracks_Im(im).M = Cracks_temp_M;
    Cracks_Im(im).FL = Cracks_temp_FL;
    Cracks_Im(im).FT = Cracks_temp_FT;
    
    Pores_Im(im).M = Pores_temp_M;
    Pores_Im(im).FL = Pores_temp_FL;
    Pores_Im(im).FT = Pores_temp_FT;
 
    l_all = size(geo_temp,1);
    l_cracks = size(Cracks_temp,1);
    l_pores = size(Pores_temp,1);
    l_voids = size(Voids_temp,1);
    l_dlami = size(Delamination_temp,1);
    
    l_cracks_FT = size(Cracks_temp_FT,1);
    l_pores_FT = size(Pores_temp_FT,1);
    l_cracks_FL = size(Cracks_temp_FL,1);
    l_pores_FL = size(Pores_temp_FL,1);
    l_cracks_M = size(Cracks_temp_M,1);
    l_pores_M = size(Pores_temp_M,1);
    
    
    [r_all,~] = find(~D_Geo,1,'first');
    [r_cracks,~] = find(~C,1,'first');
    [r_pores,~] = find(~P,1,'first');
    [r_voids,~] = find(~V,1,'first');
    [r_dlami,~] = find(~Del,1,'first');
    
    [r_cracks_FT,~] = find(~C_FT,1,'first');
    [r_pores_FT,~] = find(~P_FT,1,'first');
    [r_cracks_FL,~] = find(~C_FL,1,'first');
    [r_pores_FL,~] = find(~P_FL,1,'first');
    [r_cracks_M,~] = find(~C_M,1,'first');
    [r_pores_M,~] = find(~P_M,1,'first');
   
    
    D_Geo(r_all:(r_all+l_all-1),:) = geo_temp;
    C(r_cracks:(r_cracks+l_cracks-1),:) = Cracks_temp;
    P(r_pores:(r_pores+l_pores-1),:) = Pores_temp;
    V(r_voids:(r_voids+l_voids-1),:) = Voids_temp;
    Del(r_dlami:(r_dlami+l_dlami-1),:) = Delamination_temp;
    
    
    C_FT(r_cracks_FT:(r_cracks_FT+l_cracks_FT-1),:) = Cracks_temp_FT;
    P_FT(r_pores_FT:(r_pores_FT+l_pores_FT-1),:) = Pores_temp_FT;
    
    C_FL(r_cracks_FL:(r_cracks_FL+l_cracks_FL-1),:) = Cracks_temp_FL;
    P_FL(r_pores_FL:(r_pores_FL+l_pores_FL-1),:) = Pores_temp_FL;
    
    C_M(r_cracks_M:(r_cracks_M+l_cracks_M-1),:) = Cracks_temp_M;
    P_M(r_pores_M:(r_pores_M+l_pores_M-1),:) = Pores_temp_M;
    
    %{
    Show_Image_Plot(Images(:,:,im),Defect_mask(:,:,im),...
        segout(:,:,im),Defect_processed(:,:,im),geo_temp)
    Show_Defects_Plot(Defect_processed(:,:,im),...
        Cracks_temp,Pores_temp,Voids_temp,Delamination_temp)
    Show_Defects_Plot_Fibers(Images(:,:,im),...
        Cracks_temp_FT,Pores_temp_FT,Cracks_temp_FL,Pores_temp_FL)
    %}
 
clear geo_temp Voids_temp Cracks_temp Pores_temp Delamination_temp 
clear Cracks_temp_FL Cracks_temp_FT Cracks_temp_M 
clear geo_temp_FL geo_temp_FT geo_temp_M
clear Pores_temp_FL Pores_temp_FT Pores_temp_M
    
end

% clear a_crack_max a_voids_max All_masks Defect_mask Defect_processed
% clear Fiber_L Fiber_mask Fiber_T FileName FilesNames firs_file_name
% clear firstImg I1 I2 I3 I4 I5 I6 im Images l_all l_cracks
% clear l_cracks_FL l_cracks_FT l_dlami l_pores l_pores_FL l_pores_FT l_voids
% clear Matrix Matrix_mask num_images PathName r_all R_crack_max r_cracks 
% clear r_cracks_FL r_cracks_FT R_delami_max r_dlami r_pores r_pores_FL 
% clear r_pores_FT r_voids segout Thresh v_voids_max

D_Geo( ~any(D_Geo,2), : ) = [];
Del( ~any(Del,2), : ) = [];
C( ~any(C,2), : ) = [];
P( ~any(P,2), : ) = [];
V( ~any(V,2), : ) = [];

C_FT( ~any(C_FT,2), : ) = [];
P_FT( ~any(P_FT,2), : ) = [];
C_FL( ~any(C_FL,2), : ) = [];
P_FL( ~any(P_FL,2), : ) = [];
C_M( ~any(C_M,2), : ) = [];
P_M( ~any(P_M,2), : ) = [];

Cracks = struct('All',C,'FT',C_FT,'FL',C_FL,'M',C_M);
Pores = struct('All',P,'FT',P_FT,'FL',P_FL,'M',P_M);


end

