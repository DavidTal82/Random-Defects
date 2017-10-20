function [unit_cell,unit_cell_FL,unit_cell_FT,unit_cell_M] = FE_Unit_Cell_No_Defects(Path)
%Create_UnitCell converts the FE model to a Matlab 3D array
%   Detailed explanation goes here

%% Loading Data
load([Path,'8HW_UnitCell\S200HFiberL.mat']);
load([Path,'8HW_UnitCell\S200HFiberT.mat']);
load([Path,'8HW_UnitCell\S200HMatrix.mat']);

M = S200HMatrix(:,2:4);
FL = S200HFiberL(:,2:4);
FT = S200HFiberT(:,2:4);

% figure;
% subplot(131),plot3(FT(:,1),FT(:,2),FT(:,3),'b.'),grid on;
% subplot(132),plot3(FL(:,1),FL(:,2),FL(:,3),'r.'),grid on;
% subplot(133),plot3(M(:,1),M(:,2),M(:,3),'g.'),grid on;


%% Shifting everything to the origin
x_shift = abs(min(M(:,1)));
y_shift = abs(min(M(:,2)));
z_shift = abs(min(M(:,3)));

FL(:,1) = FL(:,1) + x_shift;
FL(:,2) = FL(:,2) + y_shift;
FL(:,3) = FL(:,3) + z_shift;

FT(:,1) = FT(:,1) + x_shift;
FT(:,2) = FT(:,2) + y_shift;
FT(:,3) = FT(:,3) + z_shift;

M(:,1) = M(:,1) + x_shift;
M(:,2) = M(:,2) + y_shift;
M(:,3) = M(:,3) + z_shift;



%% Multiplication factor
m_f = 10^3;

FL  = (round(m_f.*FL));
FT = (round(m_f.*FT));
M = (round(m_f.*M));

FL = unique(FL,'rows');
FL = FL + 1;

FT = unique(FT,'rows');
FT = FT + 1;

M = unique(M,'rows');
M = M + 1;

% figure;
% subplot(131),plot3(FT(:,1),FT(:,2),FT(:,3),'b.'),axis equal,grid on;
% subplot(132),plot3(FL(:,1),FL(:,2),FL(:,3),'r.'),axis equal,grid on;
% subplot(133),plot3(M(:,1),M(:,2),M(:,3),'g.'),axis equal,grid on;


% figure,plot3(FL(:,1),FL(:,2),FL(:,3),'r.');
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;
% 
% figure,plot3(FT(:,1),FT(:,2),FT(:,3),'b.');
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;
% 
% figure,plot3(M(:,1),M(:,2),M(:,3),'g.');
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;
% 

% figure
% hold on
% plot3(FL(:,1),FL(:,2),FL(:,3),'r.');
% plot3(FT(:,1),FT(:,2),FT(:,3),'b.');
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;
% hold off

shp_FL = alphaShape(FL(:,1),FL(:,2),FL(:,3),5);
alpha_R_FL = ceil(shp_FL.Alpha);
% figure,plot(shp_FL);
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;


shp_FT = alphaShape(FT(:,1),FT(:,2),FT(:,3),5);
alpha_R_FT = ceil(shp_FT.Alpha);
% figure,plot(shp_FT);
% xlabel('x'),ylabel('y'),zlabel('z'),axis equal,grid on;


%% Unit Cell size
x_size = max(M(:,1))- min(M(:,1)) + 1;
y_size = max(M(:,2))- min(M(:,2)) + 1;
z_size = max(M(:,3))- min(M(:,3)) + 1;

unit_cell = zeros(x_size,y_size,z_size);
unit_cell_M = false(x_size,y_size,z_size);
unit_cell_FL = false(x_size,y_size,z_size);
unit_cell_FT = false(x_size,y_size,z_size);

[qx,qy,qz] = meshgrid(1:x_size,1:y_size,1:z_size);

in_FL = inShape(shp_FL,qx,qy,qz);
in_FT = inShape(shp_FT,qx,qy,qz);

% figure;plot3(qx(in_FL),qy(in_FL),qz(in_FL),'b.');grid on;axis equal;
% figure;plot3(qx(in_FT),qy(in_FT),qz(in_FT),'r.');grid on;axis equal;
% figure;plot3(qx(in_FL),qy(in_FL),qz(in_FL),'b.',...
%     qx(in_FT),qy(in_FT),qz(in_FT),'r.');grid on;axis equal;

unit_cell_FL(in_FL) = 1;
unit_cell_FT(in_FT) = 1;
unit_cell_M(~(unit_cell_FL | unit_cell_FT)) = 1;

unit_cell(unit_cell_M) = 1;
unit_cell(unit_cell_FL) = 2;
unit_cell(unit_cell_FT) = 3;

% figure,imagesc((squeeze(unit_cell(50,:,:)))');
% for i=1:338
%     imagesc((squeeze(unit_cell(i,:,:)))');
% end






end

