clear all
close all

el_dim = 100;

load('C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Reconstructed\20150908_Paper\Defects_FL.mat');
% Angles = [[-0.112382071741810,1.16146829068649,1.30419939540021];
%     [0.118230964659001,0.831282230756061,3.34984817053831];
%     [1.36468248420699,3.17433927593708,2.96097893316312];
%     [3.39159917507311,3.15999722901228,1.29256305313948];
%     [3.20035628018430,0.185411050999044,3.31259524646596];
%     [-0.779520129418730,3.10992305814011,0.439403596424014];
%     [3.23178308070895,2.79769382719761,2.59537963152719];
%     [2.60951030385303,3.07269680474709,3.60033757155660];
%     [3.70646218348725,2.80775344257117,0.412523766501428];
%     [1.02091592476846,2.40407220904054,3.04804813862572];
%     [1.70674591953021,0.448153819654032,2.91581257543869];
%     [3.05957746233930,0.926382062264180,3.43068557755895]];

for i = 1:12
    
   
    Angle = Defects(i,7:9);
    radtodeg(Angle)
    phi = Angle(1);the = Angle(2); psi = Angle(3);
    
    [x,y,z] = meshgrid(-el_dim:0.5:el_dim,...
        -el_dim:0.5:el_dim,...
        -el_dim:0.5:el_dim);
    
    
    T_rotx = [1 0         0        0;
        0 cos(phi) -sin(phi) 0;
        0 sin(phi)  cos(phi) 0;
        0 0         0        1];
    
    T_roty = [cos(the) 0 -sin(the) 0;
        0        1  0        0;
        sin(the) 0  cos(the) 0;
        0        0  0        1];
    
    T_rotz = [cos(psi) -sin(psi) 0 0;
        sin(psi)  cos(psi) 0 0 ;
        0         0        1 0
        0         0        0 1];
    
    % Translation to xc, yc, zc
    T_trans = [1   0   0   0;
        0   1   0   0;
        0   0   1   0;
        0 0 0  1];
    
    % Rotation with respect to x, y and z -- center at (0,0,0)
    % Translation to the (xc,yc,zc)
    T_1 = T_rotx;
    T_2 = T_rotx * T_roty;
    T_3= T_rotx * T_roty * T_rotz;
    
    T = T_rotx * T_roty * T_rotz * T_trans;
    
    a = Defects(i,4)*10; b = Defects(i,5)*10; c = Defects(i,6)*10;
    tform0 = maketform('affine', T_trans);
    tform1 = maketform('affine', T_1);
    tform2 = maketform('affine', T_2);
    tform3 = maketform('affine', T_3);
    tform = maketform('affine', T);
    
    % Notice!!!
    % When generating ellipsoids (3D) out of the data from the 2D ellipses:
    %	• a, and b - are the AXES of the 2D ellipse in the equation (x/a)^2+(y/b)^2 = 1;
    %	• a, b and c - are the SEMI AXES of the 3D ellipsoid in the equation (x/a)^2+(y/b)^2 (z/c)^2 = 1;
    
    % Original ellipsoid
    ellipsoid_3D = (((x)/(a/2)).^2+((y)/(b/2)).^2+((z)/(c/2)).^2) <= 1;
    vol_temp = ellipsoid_3D;
    
    [x_r0,y_r0,z_r0] = ...
        tformfwd(tform0,x(vol_temp),y(vol_temp),z(vol_temp));
    
    [x_r1,y_r1,z_r1] = ...
        tformfwd(tform1,x(vol_temp),y(vol_temp),z(vol_temp));
    
    [x_r2,y_r2,z_r2] = ...
        tformfwd(tform2,x(vol_temp),y(vol_temp),z(vol_temp));
    
    [x_r3,y_r3,z_r3] = ...
        tformfwd(tform3,x(vol_temp),y(vol_temp),z(vol_temp));
    
    [x_out,y_out,z_out] = ...
        tformfwd(tform,x(vol_temp),y(vol_temp),z(vol_temp));
    
    
%     figure
%     plot3(x_r3,y_r3,z_r3,'.','MarkerSize',1);grid on,axis equal;
%     xlabel('x'),ylabel('y'),zlabel('z');view(0,90);
%     figure
%     plot3(x_r2,y_r2,z_r2,'.','MarkerSize',1);grid on,axis equal;
%     xlabel('x'),ylabel('y'),zlabel('z');view(0,0);
%     figure
%     plot3(x_r1,y_r1,z_r1,'.','MarkerSize',1);grid on,axis equal;
%     xlabel('x'),ylabel('y'),zlabel('z');view(90,180);camroll(90)
%     
    figure
    plot3(x_out,y_out,z_out,'.','MarkerSize',1);grid on,axis equal;
    xlabel('x'),ylabel('y'),zlabel('z');view(0,90);
    figure
    plot3(x_out,y_out,z_out,'.','MarkerSize',1);grid on,axis equal;
    xlabel('x'),ylabel('y'),zlabel('z');view(0,0);
    figure
    plot3(x_out,y_out,z_out,'.','MarkerSize',1);grid on,axis equal;
    xlabel('x'),ylabel('y'),zlabel('z');view(90,180);camroll(90)
    
end

% figure
% plot3(x_out,y_out,z_out,'.','MarkerSize',1);
% grid on,axis equal;xlabel('x'),ylabel('y'),zlabel('z');