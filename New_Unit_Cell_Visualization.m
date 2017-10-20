clear all
close all

PathName = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Existing_Data';

load([PathName,'\unit_cell_M.mat']);
load([PathName,'\unit_cell_FL.mat']);
load([PathName,'\unit_cell_FT.mat']);

[x_dim,y_dim,z_dim] = size(unit_cell_M);
[x,y,z] = ndgrid(1:x_dim,1:y_dim,1:z_dim);
    

lin_ind_M = find(unit_cell_M);
[x_el_M,y_el_M,z_el_M] = ind2sub(size(unit_cell_M),lin_ind_M);

lin_ind_FL = find(unit_cell_FL);
[x_el_FL,y_el_FL,z_el_FL] = ind2sub(size(unit_cell_FL),lin_ind_FL);

lin_ind_FT = find(unit_cell_FT);
[x_el_FT,y_el_FT,z_el_FT] = ind2sub(size(unit_cell_FT),lin_ind_FT);


%{
% The alpha radios is a problem
shp = alphaShape(x_el,y_el,z_el,1);
figure
plot(shp);
grid on;
xlabel('x'),ylabel('y'),zlabel('z');
%}
h1 = figure;
plot3(x_el_FL,y_el_FL,z_el_FL,'.','MarkerSize',1);
hold on
plot3(x_el_FT,y_el_FT,z_el_FT,'.','MarkerSize',1);
hold off
grid on,axis equal;
ax = gca;
ax.XTick = [];
ax.YTick = [];
ax.ZTick = [];
xlabel('Longitudinal tows'),ylabel('Transvers tows');
tightfig(h1);
h1 = rotate3d;
set(h1,'ActionPostCallback',@align_axislabels);



figure
p = patch(isosurface(x,y,z,volume_3D,0.5));
set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
view(3)
camlight
lighting gouraud
grid on,axis([1 x_dim 1 y_dim 1 z_dim]);
axis equal
xlabel('X'),ylabel('Y'),zlabel('Z')
