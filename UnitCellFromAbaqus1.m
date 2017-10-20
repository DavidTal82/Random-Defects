clear all
close all
load('FTx.mat')
load('FTy.mat')
load('FTz.mat')

FTz = FTz + 1349;

FT = [FTx,FTz,FTy];
FTa = ceil(FT);FTb = floor(FT);
FT = [FTa;FTb]; clear FTa FTb
% FT = round(FT);
FT = unique(FT,'rows');
FT = uint16(FT);


FTx = FT(:,1);
FTy = FT(:,2);
FTz = FT(:,3);



FTCell = false(1349,1349,69);

%%

for k = 1:length(FTx)
    k
    FTCell(FTx(k),FTy(k),FTz(k))=1;
end

%{
for i = 1:1349
    i
    indFL = find(FLx==i);    
    
    if length(indFL) > 10000
        n = ceil(length(indFL)/1000);
        n
        for j = 1:n
            j
            if j==n
                tempind = indFL(1+(j-1)*1000 : end);
            else
                tempind = indFL(1+(j-1)*1000 : j*1000);
            end
            FLCell(i,FLy(tempind),FLz(tempind))=1;
        end
    else
        FLCell(i,FLy(indFL),FLz(indFL))=1;
    end
    
end

%}

%%
SE = strel('sphere', 12);

Addon = false(1349,1349,15);
FTCell2 = cat(3, Addon, FTCell);
FTCell3 = cat(3, FTCell2,Addon);
FTCell4 = imdilate(FTCell3,SE);
FTCell5 = imerode(FTCell4,SE);
