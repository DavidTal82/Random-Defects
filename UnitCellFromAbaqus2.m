clear all
close all

load('FLCell5.mat')
load('FTCell5.mat')

FL = smooth3(FLCell5);
FT = smooth3(FTCell5);

FLCell = false(1349,1349,99);
FTCell = false(1349,1349,99);

indFL = find(FL>0.3);
indFT = find(FT>0.3);

FLCell(indFL) = 1;
FTCell(indFT) = 1;


