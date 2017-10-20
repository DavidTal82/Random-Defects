clear
close all


Path1 = [cd,'\UnitCellArrays\'];
tic
load([Path1,'0PercentVF\','FLCell.mat'])
load([Path1,'0PercentVF\','FTCell.mat'])
load([Path1,'0PercentVF\','MCell.mat'])
% 

toc
load([Path1,'0PercentVF\','FLDefects3D.mat']); FLDefects = volume_3D;clear volume_3D
load([Path1,'0PercentVF\','FTDefects3D.mat']); FTDefects = volume_3D;clear volume_3D
load([Path1,'0PercentVF\','MDefects3D.mat']); MDefects = volume_3D;clear volume_3D
% 

toc
DefectedFLCell = and(FLCell,~FLDefects);
DefectedFTCell = and(FTCell,~FTDefects);
DefectedMCell = and(MCell,~MDefects);

toc
Weave = or(DefectedFTCell,DefectedFLCell);
Matrix = DefectedMCell;

toc
UnitCell = uint8(zeros(size(Matrix)));
toc


UnitCell(Weave) = 1;
toc
UnitCell(Matrix) = 2;
toc

clear FLCell FTCell MCell FLDefects FTDefects MDefects 
clear DefectedFLCell DefectedFTCell DefectedMCell
clear Weave Matrix


%%
Path2 = [cd,'\Meshes\MeshPartition\698259Elements\'];
tic
Nodes = csvread([Path2,'Nodes.txt']);
Elements = csvread([Path2,'Elements.txt']);
%Elements(:,1) = 1:length(Elements);

Sections = zeros(length(Elements),5);
toc

%%
tic
for i=1:length(Elements);
    nodes = Elements(i,2:end);
    Points = Nodes(nodes',2:end);
    Sections(i,1) = Elements(i,1);
    Sections(i,3:end) = incenter(delaunayTriangulation(Points),1);
end
toc
%%
Sections = round(Sections);
Sections(Sections(:,3)==0,3) = 1;
Sections(Sections(:,4)==0,4) = 1;
Sections(Sections(:,5)==0,5) = 1;


%%
tic
for i = 1:length(Sections)
    Sections(i,2) = UnitCell(Sections(i,3),Sections(i,4),Sections(i,5)); 
end
toc
%%
tic


WeaveList = Sections(Sections(:,2)==1,1);% Second column - original
MatrixList = Sections(Sections(:,2)==2,1);%
VoidsList = Sections(Sections(:,2)==0,1);% First column - sorted by groups


WeaveList = [zeros(size(WeaveList)),WeaveList];
MatrixList = [zeros(size(MatrixList)),MatrixList];
VoidsList = [zeros(size(VoidsList)),VoidsList];

WeaveList(:,1) = (1:length(WeaveList))';
MatrixList(:,1) = (WeaveList(end,1)+1:WeaveList(end,1)+length(MatrixList))';
VoidsList(:,1) = (MatrixList(end,1)+1:MatrixList(end,1)+length(VoidsList))';
toc


%%
tic
ConversionList = [WeaveList;MatrixList;VoidsList];
%Column 1 is the new numbering, 2 is the old
ElementsNew = Elements;
ElementsNew(ConversionList(:,2),1) = ConversionList(:,1);
ElementsNew = sortrows(ElementsNew);
toc

Elements2Delete = ElementsNew(VoidsList(1,1):VoidsList(end,1),:);
ElementsNew(VoidsList(1,1):VoidsList(end,1),:) = [];

NodesTemp = Elements2Delete(:,2:end);
Nodes2Delete = NodesTemp(:);
Nodes2Delete = unique(sortrows(Nodes2Delete));

NodesTemp = ElementsNew(:,2:end);
Nodes2Keep = NodesTemp(:);
Nodes2Keep= unique(sortrows(Nodes2Keep));

%Lia = ismember(A,B);Determine which elements of A are also in B.
List = ~ismember(Nodes2Delete,Nodes2Keep);

if (List)
    s = 'Need to delete nodes'
else
    s = 'No Need to delete nodes'
end

WeaveList(:,2) = [];
MatrixList(:,2) = [];
VoidsList(:,2) = [];

tic

lW = ceil(length(WeaveList)/15);
lM = ceil(length(MatrixList)/15);
lV = ceil(length(VoidsList)/15);


WeaveList = [WeaveList;zeros(lW*15-length(WeaveList),1)];
MatrixList = [MatrixList;zeros(lM*15-length(MatrixList),1)];
VoidsList = [VoidsList;zeros(lV*15-length(VoidsList),1)];


WeaveList = reshape(WeaveList,15,lW)';
MatrixList = reshape(MatrixList,15,lM)';
VoidsList = reshape(VoidsList,15,lV)';

toc

tic
%% Node Sets and Lists
%%% X Node sets
% x=0
BCx1ind = Nodes(:,2)==min(Nodes(:,2));
BCx1=Nodes(BCx1ind,1);lBCx1 = ceil(length(BCx1)/15);
BCx1List = [BCx1;zeros(lBCx1*15-length(BCx1),1)];
BCx1List = reshape(BCx1List,15,lBCx1)';
% x=max
BCx2ind = Nodes(:,2)==max(Nodes(:,2));
BCx2=Nodes(BCx2ind,1);lBCx2 = ceil(length(BCx2)/15);
BCx2List = [BCx2;zeros(lBCx2*15-length(BCx2),1)];
BCx2List = reshape(BCx2List,15,lBCx2)';

%%% Y Node sets
% y=0
BCy1ind = Nodes(:,3)==min(Nodes(:,3));
BCy1=Nodes(BCy1ind,1);
lBCy1 = ceil(length(BCy1)/15);
BCy1List = [BCy1;zeros(lBCy1*15-length(BCy1),1)];
BCy1List = reshape(BCy1List,15,lBCy1)';
% y=max
BCy2ind = Nodes(:,3)==max(Nodes(:,3));
BCy2=Nodes(BCy2ind,1);
lBCy2 = ceil(length(BCy2)/15);
BCy2List = [BCy2;zeros(lBCy2*15-length(BCy2),1)];
BCy2List = reshape(BCy2List,15,lBCy2)';

%%% Z Node sets
% z=0
BCz1ind = Nodes(:,4)==min(Nodes(:,4));
BCz1=Nodes(BCz1ind,1);
lBCz1 = ceil(length(BCz1)/15);
BCz1List = [BCz1;zeros(lBCz1*15-length(BCz1),1)];
BCz1List = reshape(BCz1List,15,lBCz1)';
% z=max
BCz2ind = Nodes(:,4)==max(Nodes(:,4));
BCz2=Nodes(BCz2ind,1);
lBCz2 = ceil(length(BCz2)/15);
BCz2List = [BCz2;zeros(lBCz2*15-length(BCz2),1)];
BCz2List = reshape(BCz2List,15,lBCz2)';

%% Symmerty BC Sets
%BC at X min
BCsym1List = BCx1List;
%BC at y min
BCsym2List = BCy1List;
%BC at z min
BCsym3List = BCz1List;

%% Loading BC Sets
% For tension in 0/90 deg - only DispX
% For tension in +/-45 deg - DispX and DispY
DispX = BCx2List;
DispY = BCy2List;




%% txt files writing
% dlmwrite([Path2,'ElementsNew0Percent.txt'],ElementsNew,'precision','%.0f');
% dlmwrite([Path2,'ElementsNew45.txt'],ElementsNew,'precision','%.0f');
%
% dlmwrite([Path2,'FL_ListPercent.txt'],FL_List,'precision','%.0f');
% dlmwrite([Path2,'FT_ListPercent.txt'],FT_List,'precision','%.0f');
% dlmwrite([Path2,'WeaveList0Percent.txt'],WeaveList,'precision','%.0f');
% dlmwrite([Path2,'MatrixList0Percent.txt'],MatrixList,'precision','%.0f');
%
% dlmwrite([Path2,'FL_List45.txt'],FL_List,'precision','%.0f');
% dlmwrite([Path2,'FT_List45.txt'],FT_List,'precision','%.0f');
% dlmwrite([Path2,'MatrixList45.txt'],MatrixList,'precision','%.0f');
% 
% 
% dlmwrite([Path2,'BCx1List.txt'],BCx1List,'precision','%.0f');
% dlmwrite([Path2,'BCx2List.txt'],BCx2List,'precision','%.0f');
% 
% dlmwrite([Path2,'BCy1List.txt'],BCy1List,'precision','%.0f');
% dlmwrite([Path2,'BCy2List.txt'],BCy2List,'precision','%.0f');
% 
% dlmwrite([Path2,'BCz1List.txt'],BCz1List,'precision','%.0f');
% dlmwrite([Path2,'BCz2List.txt'],BCz2List,'precision','%.0f');

% dlmwrite([Path2,'BCsym1List.txt'],BCsym1List,'precision','%.0f');
% dlmwrite([Path2,'BCsym2List.txt'],BCsym2List,'precision','%.0f');
% dlmwrite([Path2,'BCsym3List.txt'],BCsym3List,'precision','%.0f');
% dlmwrite([Path2,'BCsym4List.txt'],BCsym4List,'precision','%.0f');
toc