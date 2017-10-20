
Path1 = [cd,'\UnitCellArrays\'];%UnitCell PAth
Path2 = [cd,'\MeshPartition\1377751Elements\'];

load([Path1,'FLCell.mat'])
load([Path1,'FTCell.mat'])
load([Path1,'MCell.mat'])
        %{
FLCell(:,:,80:end)=0;
MCell(:,:,80:end)=1;
        %}
        
        
FL = FLCell;
FT = FTCell;
Matrix = MCell;
clear FLCell FTCell MCell

%% clearing overlaps
UnitCell = uint8(zeros(size(Matrix)));
UnitCell(FL) = 1;
UnitCell(FT) = 2;
UnitCell(and(FL,FT)) = 0;
overLap= ~(and(FL,FT));
[~,IDX] = bwdist(overLap);
IDX(~and(FL,FT)) = 0;
d = IDX(IDX~=0);
UnitCell(logical(IDX(:))) = UnitCell(d);
UnitCell(Matrix) = 3;

clear FL FT Matrix
%Nodes = csvread([Path2,'Nodes.txt']);

for i=1:50
    A = squeeze(UnitCell(:,i,:))';
    B = squeeze(UnitCell(i,:,:))';
    C = squeeze(UnitCell(:,:,i));
   
    figure;
    subplot(2,2,1),imagesc(A);
    subplot(2,2,3),imagesc(B);
    subplot(2,2,[2 4]),imagesc(C);
end