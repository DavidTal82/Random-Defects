clear all
close all
tic
load('FLCell.mat')
load('FTCell.mat')
load('MCell.mat')
% 

toc
% load('FLDefects3D.mat'); FLDefects = volume_3D;clear volume_3D
% load('FTDefects3D.mat'); FTDefects = volume_3D;clear volume_3D
% load('MDefects3D.mat'); MDefects = volume_3D;clear volume_3D
% 

% toc
% DefectedFLCell = and(FLCell,~FLDefects);
% DefectedFTCell = and(FTCell,~FTDefects);
% DefectedMCell = and(MCell,~MDefects);

% toc
% Weave = or(DefectedFTCell,DefectedFLCell);
% Matrix = DefectedMCell;

toc
UnitCell = uint8(zeros(size(MCell)));
toc

% [x,y,z] = ndgrid(1:1349,1:1349,1:99);

UnitCell(FLCell) = 1;
UnitCell(FTCell) = 1;
UnitCell(MCell) = 2;
toc


clear FLCell FTCell MCell FLDefects FTDefects MDefects 
clear DefectedFLCell DefectedFTCell DefectedMCell
clear Weave Matrix
%%
tic
Nodes = csvread('Nodes.txt');
Elements = csvread('Elements.txt');

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

%VoidsList = Sections(Sections(:,2)==0,1);% First column - sorted by groups
WeaveList = Sections(Sections(:,2)==1,1);% Second column - original
MatrixList = Sections(Sections(:,2)==2,1);%

%VoidsList = [zeros(size(VoidsList)),VoidsList];
WeaveList = [zeros(size(WeaveList)),WeaveList];
MatrixList = [zeros(size(MatrixList)),MatrixList];

%VoidsList(:,1) = (1:length(VoidsList))';
WeaveList(:,1) = (1:length(WeaveList))';
MatrixList(:,1) = (WeaveList(end,1)+1:WeaveList(end,1)+length(MatrixList))';
toc

%%
tic
ConversionList = [WeaveList;MatrixList];
%Column 1 is the new numbering, 2 is the old
ElementsNew = Elements;
ElementsNew(ConversionList(:,2),1) = ConversionList(:,1);
ElementsNew = sortrows(ElementsNew);
toc

WeaveList(:,2) = [];
MatrixList(:,2) = [];

tic

lW = ceil(length(WeaveList)/15);
lM = ceil(length(MatrixList)/15);

WeaveList = [WeaveList;zeros(lW*15-length(WeaveList),1)];
MatrixList = [MatrixList;zeros(lM*15-length(MatrixList),1)];


WeaveList = reshape(WeaveList,15,lW)';
MatrixList = reshape(MatrixList,15,lM)';


toc

tic
BC1ind = Nodes(:,2)==min(Nodes(:,2));
BC1=Nodes(BC1ind,1);

BC2ind = Nodes(:,2)==max(Nodes(:,2));
BC2=Nodes(BC2ind,1);

lBC1 = ceil(length(BC1)/15);
lBC2 = ceil(length(BC2)/15);

BC1List = [BC1;zeros(lBC1*15-length(BC1),1)];
BC2List = [BC2;zeros(lBC2*15-length(BC2),1)];

BC1List = reshape(BC1List,15,lBC1)';
BC2List = reshape(BC2List,15,lBC2)';

% dlmwrite('VoidsList.txt',VoidsList,'precision','%.0f');
% dlmwrite('WeaveList.txt',WeaveList,'precision','%.0f');
% dlmwrite('MatrixList.txt',MatrixList,'precision','%.0f');
% 
% 
dlmwrite('ElementsNewNoDefects.txt',ElementsNew,'precision','%.0f');
% dlmwrite('BC1List.txt',BC1List,'precision','%.0f');
% dlmwrite('BC2List.txt',BC2List,'precision','%.0f');
toc