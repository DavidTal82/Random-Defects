clear
close all

Path1 = [cd,'\UnitCellArrays\'];%UnitCell PAth

Path2 = [cd,'\589483Elements\'];
% [cd,'\320349Elements\'];
% [cd,'\320349Elements\'];
% [cd,'\1445280Elements\'];
% [cd,'\3007270Elements\'];
% [cd,'\7544013Elements\'];
%%

load([Path1,'UnitCell45.mat'])

%% Loading Nodes and Elements
Nodes = csvread([Path2,'Nodes.txt']);
Elements = csvread([Path2,'Elements.txt']);

Sections = zeros(length(Elements),5);

%% Assighning Section to each element
% Section = [old element number,section,Xc,Yc,Zc];

for i=1:length(Elements);
    nodes = Elements(i,2:end);
    Points = Nodes(nodes',2:end);
    Sections(i,1) = Elements(i,1);
    Sections(i,3:end) = incenter(delaunayTriangulation(Points),1);
end
%Coordinates from the matlab arrays start at 1,
%Coordinates from the abaqus geometry start 0, 
Sections = round(Sections);
Sections(Sections(:,3)==0,3) = 3;
Sections(Sections(:,4)==0,4) = 3;
Sections(Sections(:,5)==0,5) = 3;

%Section assingment based on location
for i = 1:length(Sections)
    Sections(i,2) = UnitCell45(Sections(i,3),Sections(i,4),Sections(i,5)); 
end

%% Elements lists
FL_List = Sections(Sections(:,2)==1,1);% Second column - original
FL_List = [zeros(size(FL_List)),FL_List];
FL_List(:,1) = (1:length(FL_List))';

FT_List = Sections(Sections(:,2)==2,1);
FT_List = [zeros(size(FT_List)),FT_List];
FT_List(:,1) = (FL_List(end,1)+1:FL_List(end,1)+length(FT_List))';

MatrixList = Sections(Sections(:,2)==3,1);% First column - sorted by groups
MatrixList = [zeros(size(MatrixList)),MatrixList];
MatrixList(:,1) = (FT_List(end,1)+1:FT_List(end,1)+length(MatrixList))';

%Elements re-numbering
ConversionList = [FL_List;FT_List;MatrixList];
%Column 1 is the new numbering, 2 is the old
ElementsNew = Elements;
ElementsNew(ConversionList(:,2),1) = ConversionList(:,1);
ElementsNew = sortrows(ElementsNew);

%Creating new lists of elements
FL_List(:,2) = [];
l_FL = ceil(length(FL_List)/15);
FL_List = [FL_List;zeros(l_FL*15-length(FL_List),1)];
FL_List = reshape(FL_List,15,l_FL)';

FT_List(:,2) = [];
l_FT = ceil(length(FT_List)/15);
FT_List = [FT_List;zeros(l_FT*15-length(FT_List),1)];
FT_List = reshape(FT_List,15,l_FT)';

MatrixList(:,2) = [];
lM = ceil(length(MatrixList)/15);
MatrixList = [MatrixList;zeros(lM*15-length(MatrixList),1)];
MatrixList = reshape(MatrixList,15,lM)';


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

% dlmwrite([Path2,'FL_List45.txt'],FL_List,'precision','%.0f');
% dlmwrite([Path2,'FT_List45.txt'],FT_List,'precision','%.0f');
% dlmwrite([Path2,'MatrixList45.txt'],MatrixList,'precision','%.0f');
% 
% 
% dlmwrite([Path2,'ElementsNew45.txt'],ElementsNew,'precision','%.0f');

% dlmwrite([Path2,'BCx1List45.txt'],BCx1List,'precision','%.0f');
% dlmwrite([Path2,'BCx2List45.txt'],BCx2List,'precision','%.0f');

% dlmwrite([Path2,'BCy1List45.txt'],BCy1List,'precision','%.0f');
% dlmwrite([Path2,'BCy2List45.txt'],BCy2List,'precision','%.0f');

% dlmwrite([Path2,'BCz1List45.txt'],BCz1List,'precision','%.0f');
% dlmwrite([Path2,'BCz2List45.txt'],BCz2List,'precision','%.0f');

% dlmwrite([Path2,'BCsym1List45.txt'],BCsym1List,'precision','%.0f');
% dlmwrite([Path2,'BCsym2List45.txt'],BCsym2List,'precision','%.0f');
% dlmwrite([Path2,'BCsym3List45.txt'],BCsym3List,'precision','%.0f');
% dlmwrite([Path2,'BCsym4List45.txt'],BCsym4List,'precision','%.0f');


