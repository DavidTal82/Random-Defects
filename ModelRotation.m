clear
%
angle = pi/4;

Path1 = [cd,'\UnitCellArrays\'];%UnitCell PAth
%%

load([Path1,'FLCell.mat'])
load([Path1,'FTCell.mat'])
load([Path1,'MCell.mat'])

FL = FLCell;
FT = FTCell;
Matrix = MCell;

clear FLCell FTCell MCell

UnitCell = uint8(zeros(size(Matrix)));
UnitCell(FL) = 1;
UnitCell(FT) = 2;
UnitCell(Matrix) = 3;
clear FL FT Matrix

[Xdim,Ydim,Zdim] = size(UnitCell);

lin_ind_FL = find(UnitCell==1);
[xFL,yFL,zFL] = ind2sub(size(UnitCell),lin_ind_FL);
clear lin_ind_FL
lin_ind_FT = find(UnitCell==2);
[xFT,yFT,zFT] = ind2sub(size(UnitCell),lin_ind_FT);
clear lin_ind_FT

figure
plot3(xFL,yFL,zFL,'.',xFT,yFT,zFT,'.','MarkerSize',1);
grid on,axis equal;
xlabel('x'),ylabel('y'),zlabel('z');view(3);
clear xFL yFL zFL xFT yFT zFT

%% Unit cell rotation about the Z direction (transverse)
RotMatrix = [cos(angle) sin(angle) 0;
            -sin(angle) cos(angle) 0;
             0          0          1];

T = maketform('affine',RotMatrix);
FramedUnitCell =repmat(UnitCell,3,3,1);
clear UnitCell

% lin_ind_FL = find(FramedUnitCell==1);
% [xFL,yFL,zFL] = ind2sub(size(FramedUnitCell),lin_ind_FL);
% clear lin_ind_FL 
% lin_ind_FT = find(FramedUnitCell==2);
% [xFT,yFT,zFT] = ind2sub(size(FramedUnitCell),lin_ind_FT);
% clear lin_ind_FT
% 
% figure
% plot3(xFL,yFL,zFL,'.',xFT,yFT,zFT,'.','MarkerSize',1);
% grid on,axis equal;
% xlabel('x'),ylabel('y'),zlabel('z');view(3);
% clear xFL yFL zFL xFT yFT zFT


RotatedUnitCell = imtransform(FramedUnitCell,T,'nearest');
clear FramedUnitCell 

[dimx,dimy,dimz] = size(RotatedUnitCell);
UnitCell45 = RotatedUnitCell((dimx-1)/2:(dimx-1)/2+Xdim-1,...
    (dimy-1)/2:(dimy-1)/2+Ydim-1,:);
clear RotatedUnitCell