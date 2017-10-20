clear
close all

Rmin = 5;

Path = 'C:\Users\operator\Documents\MATLAB\Matlab_Research\';
Data_Path = 'Main\Saved_Data\Reconstructed\20150908_Paper\';

%xc,yc,zc,a,b,c,Phi,The,Psi

load([Path,Data_Path,'Volum_3D_FL.mat']);
FL_3D_Defects = volume_3D; clear volume_3D;

% load([Path,Data_Path,'Volum_3D_FT.mat']);
% FT_3D_Defects = volume_3D; clear volume_3D;

% load([Path,Data_Path,'Volum_3D_M.mat']);
% M_3D_Defects = volume_3D; clear volume_3D;

temp = FL_3D_Defects(:,681:850,:); 


ker = 1;
temp = smooth3(temp,'gaussian',[ker,ker,ker]);
%ker = ker+2; temp = smooth3(temp,'gaussian',[ker,ker,ker]);

[x_dim,y_dim,z_dim] = size(temp);
[Xgrid,Ygrid,Zgrid] = ndgrid(1:x_dim,1:y_dim,1:z_dim);
DL = isosurface(Xgrid,Ygrid,Zgrid,temp,0.5);

% stlwrite('defects_FL1.stl', DL);

lin_ind = find(temp);
[x,y,z] = ind2sub(size(temp),lin_ind);

figure
plot3(x,y,z,'.','MarkerSize',1);
grid on,axis equal;
xlabel('x'),ylabel('y'),zlabel('z');

points = [x,y,z];
save('D_FL8.txt','points','-ascii');

lin_ind = find(temp);
[x,y,z] = ind2sub(size(temp),lin_ind);

shp = alphaShape(x,y,z,0.9);
figure
plot(shp);
grid on;
xlabel('x'),ylabel('y'),zlabel('z');

[x_dim,y_dim,z_dim] = size(temp);
[Xgrid,Ygrid,Zgrid] = ndgrid(1:x_dim,1:y_dim,1:z_dim);
DL = isosurface(Xgrid,Ygrid,Zgrid,temp,0.5);

figure
p = patch(DL);
set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
view(3)
camlight
lighting gouraud
grid on;
axis equal;
xlabel('X'),ylabel('Y'),zlabel('Z')

%%
%{
figure
plot(shp);
grid on;
xlabel('x'),ylabel('y'),zlabel('z');

figure
plot3(x,y,z,'.','MarkerSize',1);
grid on,axis equal;
xlabel('x'),ylabel('y'),zlabel('z');

figure
p = patch(isosurface(Xgrid,Ygrid,Zgrid,temp,0.5));
set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
view(3)
camlight
lighting gouraud
grid on;
axis equal
xlabel('X'),ylabel('Y'),zlabel('Z')
%}
%%
% points = [x,y,z];
% save('points.txt','points','-ascii');


