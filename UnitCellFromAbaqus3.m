clear all
close all
% 
load('FLCell.mat')
load('FTCell.mat')
load('MCell.mat')
% 
load('FLDefects3D.mat'); FLDefects = volume_3D;clear volume_3D
load('FTDefects3D.mat'); FTDefects = volume_3D;clear volume_3D
load('MDefects3D.mat'); MDefects = volume_3D;clear volume_3D
% 
DefectedFLCell = and(FLCell,~FLDefects);
DefectedFTCell = and(FTCell,~FTDefects);
DefectedMCell = and(MCell,~MDefects);
Weave = or(DefectedFTCell,DefectedFLCell);
Matrix = DefectedMCell;
clear FLCell FTCell MCell FLDefects FTDefects MDefects DefectedFLCell DefectedFTCell DefectedMCell



Weave(1:3,:,:) = [];Weave(:,1:3,:) = [];
Weave(end-3:end,:,:) = [];Weave(:,end-3:end,:) = [];

Matrix(1:3,:,:) = [];Matrix(:,1:3,:) = [];
Matrix(end-3:end,:,:) = [];Matrix(:,end-3:end,:) = [];
 
n = 10;%number of subdevisions
N = n^2;
Ls = 1340/n;
for i = 1:1
    for j=1:1
    brickW = Weave(1+Ls*(1-i):Ls*i,1+Ls*(1-j):Ls*j,:);
    %brickM = Matrix(1+Ls*(1-i):Ls*i,1+Ls*(1-j):Ls*j,:);
    
    indW = find(brickW);
    %indM = find(brickM);
    
    [xW,yW,zW] = ind2sub(size(brickW),indW); %clear brickW indW
    %[xM,yM,zM] = ind2sub(size(brickM),indM); %clear brickM indM
    
    DT_W = delaunayTriangulation(xW,yW,zW);
    %DT_M = delaunayTriangulation(xM,yM,zM);
    end
end

model = createpde();
[G,mesh] = geometryFromMesh(model,DT_W.Points',DT_W.ConnectivityList');
generateMesh(model,'GeometricOrder','linear','Hmin',1,'Hmax',15);
no = model.Mesh.Nodes';
el = model.Mesh.Elements';

elements = zeros(length(el),5);
nodes = zeros(length(no),4);
nodes(:,1) = 1:length(nodes);
elements(:,1) = 1:length(elements);
nodes(:,2:4) = no;
elements(:,2:5) = el;
csvwrite('Nodes.txt',nodes);
csvwrite('Elements.txt',elements);




%DT_W = delaunayTriangulation(xFT,yFT,zFT);
%DT_M = delaunayTriangulation(xM,yM,zM);
%  
% 
% 
% model = createpde();
% tic
% geometryFromMesh(model,DT.Points',DT.ConnectivityList');
% toc
% tic
% generateMesh(model,'GeometricOrder','linear','Hmax',10,'Hmin',1)
% toc
% 
% N = model.Mesh.Nodes';
% E = model.Mesh.Elements';
% Nodes = zeros(length(N),4);
% Elements = zeros(length(E),5);
% Nodes(:,1) = 1:length(Nodes);
% Elements(:,1) = 1:length(Elements);
% Nodes(:,2:end) = N;
% Elements(:,2:end) = E;
% csvwrite('Nodes.txt',Nodes);
% csvwrite('Elements.txt',Elements);
% 
% 
