function [XYZ_in,XYZ_out] = ...
    ellipsoid_generation(Layer,a,b,c,xc,yc,zc,Phi,The,Psi,el_dim)
%ellipsoid_generation creats an ellipsoid
%   Input - center of ellipsoid, angle of rotation and dimension of a
%           volume binary array
%   Output - x,y and z coordinates of the rotated ellipsoid located in it's
%            center

% % Debugging
% Layer = 3;
% a = 16;b = 10;c = 6;
% xc = 0;yc = 0;zc = 0;
% Phi = pi/4;The = pi/6;Psi = pi/18;
% el_dim = 50;

if (~exist('el_dim','var'))
    el_dim = 50;
end

% Structuring element neighborhood
SE = false(3,3,3);
SE(2,2,:) = 1;
SE(2,:,2) = 1;
SE(:,2,2) = 1;

[x,y,z] = meshgrid(-el_dim:0.5:el_dim,...
    -el_dim:0.5:el_dim,...
    -el_dim:0.5:el_dim);

% Rotation with respect to (0,0,0)
T_rotx = [1 0         0        0;
    0 cos(Phi) -sin(Phi) 0;
    0 sin(Phi)  cos(Phi) 0;
    0 0         0        1];

T_roty = [cos(The) 0 -sin(The) 0;
    0        1  0        0;
    sin(The) 0  cos(The) 0;
    0        0  0        1];

T_rotz = [cos(Psi) -sin(Psi) 0 0;
    sin(Psi)  cos(Psi) 0 0 ;
    0         0        1 0
    0         0        0 1];

% Translation to xc, yc, zc
T_trans = [1   0   0   0;
    0   1   0   0;
    0   0   1   0;
    xc yc zc  1];

% Rotation with respect to x, y and z -- center at (0,0,0)
% Translation to the (xc,yc,zc)
T = T_rotx * T_roty * T_rotz * T_trans;

tform = maketform('affine', T);

% Notice!!!
% When generating ellipsoids (3D) out of the data from the 2D ellipses:
%	• a, and b - are the AXES of the 2D ellipse in the equation (x/a)^2+(y/b)^2 = 1;
%	• a, b and c - are the SEMI AXES of the 3D ellipsoid in the equation (x/a)^2+(y/b)^2 (z/c)^2 = 1;

% Original ellipsoid
ellipsoid_3D = (((x)/(a/2)).^2+((y)/(b/2)).^2+((z)/(c/2)).^2) <= 1;
vol_temp = ellipsoid_3D;

[x_out,y_out,z_out] = ...
    tformfwd(tform,x(vol_temp),y(vol_temp),z(vol_temp));

XYZ_in = [x_out,y_out,z_out];
clear x_out y_out z_out;

if Layer
    
    XYZ = cell(Layer,1);
    num_points = 0;
    % Dialating the original ellipsoid and adding layers
    for i = 1:Layer
        ellipsoid_3D = imdilate(ellipsoid_3D,SE);
        vol_temp = and(ellipsoid_3D,~vol_temp);
        
        [x_out,y_out,z_out] = ...
            tformfwd(tform,x(vol_temp),y(vol_temp),z(vol_temp));
        vol_temp = ellipsoid_3D;
        
        XYZ{i,1} = [x_out,y_out,z_out];
        num_points = num_points + length(x_out);
        clear x_out y_out z_out;
    end
    
    XYZ_out = zeros(num_points,3);
    
    for i = 1:(length(XYZ))
        
        x_out = XYZ{i,1}(:,1);
        y_out = XYZ{i,1}(:,2);
        z_out = XYZ{i,1}(:,3);
        
        if i==1
            row = 1;
        else
            row = find(XYZ_out(:,1),1,'last') + 1;
        end
        
        len = length(x_out(:,1));
        
        XYZ_out(row:(row + len - 1),1) = x_out;
        XYZ_out(row:(row + len - 1),2) = y_out;
        XYZ_out(row:(row + len - 1),3) = z_out;
        
        clear x_out y_out z_out;
    end
end

end

