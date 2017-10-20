clear
%close all

angle = 90;
% 0/90 or +/-45 deg
Criteria = 1;
% 1 - centroid location
% 2 - nodes location
% 3 - fibers - all nodes in the same phase

Path1 = [cd,'\UnitCellArrays\0PercentVF\'];%UnitCell PAth

Path2 = [cd,'\Meshes\MeshPartition\767260Elements\'];
% [cd,'\320349ElementsNoDefects\'];
% [cd,'\320349Elements\'];
% [cd,'\2148424Elements\'];
% [cd,'\7544013Elements\'];
% [cd,'\1445280Elements\'];
% [cd,'\589483Elements\'];
% [cd,'\3007270Elements\'];
%% loading data
switch angle
    case 45
        load([Path1,'UnitCell45.mat'])
        UnitCell = UnitCell45;
        clear UnitCell45        
    case 90
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
end

%% Loading Nodes and Elements
Nodes = csvread([Path2,'Nodes.txt']);
Elements = csvread([Path2,'Elements.txt']);
%Elements(:,1) = 1:length(Elements);

%% Assighning Section to each element

switch Criteria
    case 1
        % Section = [old element number,section,Xc,Yc,Zc];
        Sections = zeros(length(Elements),5);
        for i=1:length(Elements);
            nodes = Elements(i,2:end);
            Points = Nodes(nodes',2:end);
            Sections(i,1) = Elements(i,1);
            Sections(i,3:end) = round(incenter(delaunayTriangulation(Points),1));
        end
        %Coordinates from the matlab arrays start at 1,
        %Coordinates from the abaqus geometry start 0,
        Sections(Sections(:,3)==0,3) = 3;
        Sections(Sections(:,4)==0,4) = 3;
        Sections(Sections(:,5)==0,5) = 3;
        %Section assingment based on location
        for i = 1:length(Sections)
            Sections(i,2) = UnitCell(Sections(i,3),Sections(i,4),Sections(i,5));
        end
    case 2
        % Section = [old element number,section,Xc,Yc,Zc];
        Sections = zeros(length(Elements),5);
              
        for i=1:length(Elements);
            Sec = zeros(3,1);
            
            nodes = Elements(i,2:end);
            Points = Nodes(nodes',2:end);
            Sections(i,1) = Elements(i,1);
            Sections(i,3:end) = round(incenter(delaunayTriangulation(Points),1));
                        
            Points = round(Points);
            Points(Points(:,1)==0,1) = 1;
            Points(Points(:,2)==0,2) = 1;
            Points(Points(:,3)==0,3) = 1;
            
            node1 = UnitCell(Points(1,1),Points(1,2),Points(1,3));
            node2 = UnitCell(Points(2,1),Points(2,2),Points(2,3));
            node3 = UnitCell(Points(3,1),Points(3,2),Points(3,3));
            node4 = UnitCell(Points(4,1),Points(4,2),Points(4,3));
            
            Sec(1) = sum(ismember([node1,node2,node3,node4],1));
            Sec(2) = sum(ismember([node1,node2,node3,node4],2));
            Sec(3) = sum(ismember([node1,node2,node3,node4],3));
                       
            switch max(Sec)
                case {4,3}
                    [~,indSec] = max(Sec);
                    Sections(i,2) = indSec;
                case 2
                    Sections(i,2) = UnitCell(Sections(i,3),Sections(i,4),Sections(i,5));
            end           
        end
%{   
    case 3
        % Section = [old element number,section,Xc,Yc,Zc];
        Sections = zeros(length(Elements),5);
        for i=1:length(Elements);            
            nodes = Elements(i,2:end);
            Points = Nodes(nodes',2:end);
            Sections(i,1) = Elements(i,1);
            Sections(i,3:end) = round(incenter(delaunayTriangulation(Points),1));
            Points = round(Points);
            Points(~Points) = 1;
            
            node1 = UnitCell(Points(1,1),Points(1,2),Points(1,3));
            node2 = UnitCell(Points(2,1),Points(2,2),Points(2,3));
            node3 = UnitCell(Points(3,1),Points(3,2),Points(3,3));
            node4 = UnitCell(Points(4,1),Points(4,2),Points(4,3));
            
            if (node1 == 3 || node2 == 3 || node3 == 3 || node4 == 3)
                Sections(i,2) = 3;
            elseif (node1 == 2 && node2 == 2 && node3 == 2 && node4 == 2)
                Sections(i,2) = 2;
            elseif (node1 == 1 && node2 == 1 && node3 == 1 && node4 == 1)
                Sections(i,2) = 1;
            else
                Sections(i,2) = UnitCell(Sections(i,3),Sections(i,4),Sections(i,5));
            end
            
        end
        %Coordinates from the matlab arrays start at 1,
        %Coordinates from the abaqus geometry start 0,
        Sections(Sections(:,3)==0,3) = 3;
        Sections(Sections(:,4)==0,4) = 3;
        Sections(Sections(:,5)==0,5) = 3;
        %Section assingment based on location
        for i = 1:length(Sections)
            Sections(i,2) = UnitCell(Sections(i,3),Sections(i,4),Sections(i,5));
         end
%}      

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
% dlmwrite([Path2,'ElementsNew.txt'],ElementsNew,'precision','%.0f');
% dlmwrite([Path2,'ElementsNew45.txt'],ElementsNew,'precision','%.0f');
%
% dlmwrite([Path2,'FL_List.txt'],FL_List,'precision','%.0f');
% dlmwrite([Path2,'FT_List.txt'],FT_List,'precision','%.0f');
% dlmwrite([Path2,'MatrixList.txt'],MatrixList,'precision','%.0f');
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