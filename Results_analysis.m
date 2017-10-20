clear
close all

path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main');
path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Main_Functions');

PathName = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Reconstructed\20150908_Paper\';
PathName1 = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Existing_Data\20150908_Paper\';


%%
%%{
load([PathName,'Volum_3D_M.mat'])
M_3D_Defects = volume_3D;
clear volume_3D

load([PathName,'Volum_3D_FL.mat'])
FL_3D_Defects = volume_3D;
clear volume_3D

load([PathName,'Volum_3D_FT.mat'])
FT_3D_Defects = volume_3D;
clear volume_3D

% M_small = M_3D_Defects(1:500,1:500,:);
% FL_small = FL_3D_Defects(1:500,1:500,:);
% FT_small = FT_3D_Defects(1:500,1:500,:);

% Unit_Cell_Visualization(M_small)
% Unit_Cell_Visualization(FL_small)
% Unit_Cell_Visualization(FT_small)

lin_ind_M = find(M_3D_Defects);
lin_ind_FL = find(FL_3D_Defects);
lin_ind_FT = find(FT_3D_Defects);

[x_M,y_M,z_M] = ind2sub(size(M_3D_Defects),lin_ind_M);
[x_FL,y_FL,z_FL] = ind2sub(size(FL_3D_Defects),lin_ind_FL);
[x_FT,y_FT,z_FT] = ind2sub(size(FT_3D_Defects),lin_ind_FT);

figure
plot3(x_M,y_M,z_M,'.',x_FL,y_FL,z_FL,'.',x_FT,y_FT,z_FT,'.');
grid on
axis equal
xlabel('X'),ylabel('Y'),zlabel('Z');

load('C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Saved_Data\Existing_Data\unit_cell_M.mat')
load('C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Saved_Data\Existing_Data\unit_cell_FT.mat')
load('C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Saved_Data\Existing_Data\unit_cell_FL.mat')

unit_cell_FL2 = logical(interp3(single(unit_cell_FL),2));
unit_cell_FT2 = logical(interp3(single(unit_cell_FT),2));
unit_cell_M2 = logical(interp3(single(unit_cell_M),2));

% unit_cell_defects = ones(size(M_3D));
% unit_cell_defects(M_3D) = 10;
% unit_cell_defects(FL_3D) = 20;
% unit_cell_defects(FT_3D) = 30;

unit_cell = uint8(zeros(size(unit_cell_M2)));
unit_cell(unit_cell_M2) = 0;
unit_cell(unit_cell_FL2) = 50;
unit_cell(unit_cell_FT2) = 100;

unit_cell(M_3D_Defects) = 155;
unit_cell(FL_3D_Defects) = 205;
unit_cell(FT_3D_Defects) = 255;

unit_cell(1,:,1) = 0;
unit_cell(1,:,2) = 50;
unit_cell(1,:,3) = 100;
unit_cell(1,:,4) = 155;
unit_cell(1,:,5) = 205;
unit_cell(1,:,6) = 255;

%% Video
%{ 
F1(1000) = struct('cdata',[],'colormap',[]);
F2(1000) = struct('cdata',[],'colormap',[]);
scrsz = get(groot,'ScreenSize');

for i = 1000
    
    figure('Position',[1 1 scrsz(3) scrsz(4)])
    figure
    subplot(5,2,[1,2,3,4]),imagesc(squeeze(unit_cell(:,i,:))');
    set(gca, 'YDir', 'normal');axis equal,axis([0 500 0 69])
    
    subplot(5,2,5),imagesc(squeeze(unit_cell_M2(:,i,:))');
    set(gca, 'YDir', 'normal');axis equal,axis([0 500 0 69])
    subplot(5,2,7),imagesc(squeeze(unit_cell_FL2(:,i,:))');
    set(gca, 'YDir', 'normal');axis equal,axis([0 500 0 69])
    subplot(5,2,9),imagesc(squeeze(unit_cell_FT2(:,i,:))');
    
    set(gca, 'YDir', 'normal');axis equal,axis([0 500 0 69])
    subplot(5,2,6),imagesc(squeeze(M_3D_Defects(:,i,:))');
    set(gca, 'YDir', 'normal');axis equal,axis([0 500 0 69])
    subplot(5,2,8),imagesc(squeeze(FL_3D_Defects(:,i,:))');
    set(gca, 'YDir', 'normal');axis equal,axis([0 500 0 69])
    subplot(5,2,10),imagesc(squeeze(FT_3D_Defects(:,i,:))');
    set(gca, 'YDir', 'normal');axis equal,axis([0 500 0 69])
    
    F1(i) = getframe;
    close
    
    
    
    figure('Position',[1 450 scrsz(3) scrsz(4)/2])
    imagesc(squeeze(unit_cell(:,i,:))');
    set(gca, 'YDir', 'normal');axis equal,axis([0 500 0 69])
    colorbar('Ticks',[0,50,100,155,205,255],...
        'TickLabels',{'M','FL','FT','M-Defects','FL-Defects','FT-Defects'})
    'TickLabels',{'M','LT','TT','M-Defects','LT-Defects','TT-Defects'})
    
    F2(i) = getframe;
    close
    
end

UnitCellVideo1 = VideoWriter('UnitCellVideo1.avi');
open(UnitCellVideo1);
writeVideo(UnitCellVideo1,F1);
close(UnitCellVideo1);

UnitCellVideo2 = VideoWriter('UnitCellVideo2.avi');
open(UnitCellVideo2);
writeVideo(UnitCellVideo2,F2);
close(UnitCellVideo2);

%}



%% Model Plots

%figure,imagesc(squeeze(unit_cell(:,110,:))'),axis equal,axis([1 1349 1 69]);
%figure,imagesc(squeeze(unit_cell(:,111,:))'),axis equal,axis([1 1349 1 69]);
%figure,imagesc(squeeze(unit_cell(:,112,:))'),axis equal,axis([1 1349 1 69]);
%figure,imagesc(squeeze(unit_cell(:,113,:))'),axis equal,axis([1 1349 1 69]);
%figure,imagesc(squeeze(unit_cell(:,114,:))'),axis equal,axis([1 1349 1 69]);

%for i = 10:1330
%     h = figure;
%     imagesc(squeeze(unit_cell(:,i,:))'),axis equal,axis([1 1349 1 69]);
%     ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];
%     tightfig(h);

h1 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,60,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h1);
h2 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,61,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h2);
h3 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,62,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h3);
h4 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,63,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h4);
h5 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,64,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h5);
h6 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,65,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h6);
h7 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,66,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h7);
h8 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,67,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h8);
h9 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,68,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h9);
h10 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,69,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h10);
h11 = figure;
subplot(5,1,3),imagesc(squeeze(unit_cell(:,70,:))'),axis equal,axis([1 1349 1 69]);
ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];%tightfig(h11);



%end

figure
imagesc(squeeze(unit_cell(:,114,:))'),axis equal,axis([1 1349 1 69]);

figure
imagesc(squeeze(unit_cell(:,114,:))'),axis equal,axis([1 500 1 69]);

ax = gca;ax.XTick = [];ax.YTick = [];ax.ZTick = [];

%%}


%% Statistical plots

load([PathName,'Defects_M.mat'])
load([PathName1,'CP_M.mat'])
CP_Rec_M = Defects;
clear Defects

load([PathName,'Defects_FL.mat'])
load([PathName1,'CP_FL.mat'])
CP_Rec_FL = Defects;
clear Defects

load([PathName,'Defects_FT.mat'])
load([PathName1,'CP_FT.mat'])
CP_Rec_FT = Defects;
clear Defects

load([PathName1,'CP_All.mat'])
CP_Rec_All = [CP_Rec_M;CP_Rec_FL;CP_Rec_FT];

%%
% figure;h_rec_ab = histogram2(CP_Rec_All(:,4),CP_Rec_All(:,5),'Normalization','probability',...
%     'XBinLimits',[0 50],'XBinLimits',[0 20],'FaceColor','flat');
% zlim([0 0.03]);
% figure;histogram2(CP_All(:,3),CP_All(:,4),15,'Normalization','pdf',...
%     'XBinLimits',[0 50],'XBinLimits',[0 20],...
%      'XBinEdges',h_rec_ab.XBinEdges,'YBinEdges',h_rec_ab.YBinEdges,'FaceColor','flat');
%%
h_sub1 = figure;
subplot_tight(2,1,1,0.05);
histogram(CP_All(:,1),30,'Normalization','probability');
grid on;legend('Experimental');
xlim([50 450]);

subplot_tight(2,1,2,0.05);
histogram(CP_Rec_All(:,1),'FaceColor',[0.85 0.325 0.098],...
    'Normalization','probability');
grid on;legend('Generated');xlabel('X_C [pixels]');
xlim([50 1300]);

suplabel('Normalized frequency','y');

h_sub1 = tightfig(h_sub1);
%%
h_sub2 = figure;
subplot_tight(2,1,1,0.05);
histogram(CP_All(:,5),20,'Normalization','probability');
grid on;legend('Experimental');
xlim([0 pi]),ylim([0 0.5]);

subplot_tight(2,1,2,0.05);
histogram(CP_Rec_All(:,7),20,'FaceColor',[0.85 0.325 0.098],...
    'Normalization','probability');
grid on;legend('Generated');xlabel('Orientation angle [rad]');
xlim([0 pi]);ylim([0 0.5]);

suplabel('Normalized frequency','y');

h_sub2 = tightfig(h_sub2);

%%

% figure;
% subplot(3,5,1),plot_hist(Defects_M(:,1),'X_c');
% subplot(3,5,2),plot_hist(Defects_M(:,2),'Y_c');
% subplot(3,5,3),plot_hist(Defects_M(:,4),'Major axis');
% subplot(3,5,4),plot_hist(Defects_M(:,5),'Minor axis');
% subplot(3,5,5),plot_hist(Defects_M(:,7),'Orientation'),xlim([0 pi]);
% 
% subplot(3,5,6),plot_hist(Defects_FL(:,1),'X_c');
% subplot(3,5,7),plot_hist(Defects_FL(:,2),'Y_c');
% subplot(3,5,8),plot_hist(Defects_FL(:,4),'Major axis');
% subplot(3,5,9),plot_hist(Defects_FL(:,5),'Minor axis');
% subplot(3,5,10),plot_hist(Defects_FL(:,7),'Orientation'),xlim([0 pi]);
% 
% subplot(3,5,11),plot_hist(Defects_FT(:,1),'X_c');
% subplot(3,5,12),plot_hist(Defects_FT(:,2),'Y_c');
% subplot(3,5,13),plot_hist(Defects_FT(:,4),'Major axis');
% subplot(3,5,14),plot_hist(Defects_FT(:,5),'Minor axis');
% subplot(3,5,15),plot_hist(Defects_FT(:,7),'Orientation'),xlim([0 pi]);
%%



% plot_hist(Defects_M(:,1),'X_c');
% figure;plot_hist(Defects_M(:,2),'Y_c');
% figure;plot_hist(Defects_M(:,4),'Major axis');
% figure;plot_hist(Defects_M(:,5),'Minor axis');
% figure;plot_hist(Defects_M(:,7),'Orientation'),xlim([0 pi]);




