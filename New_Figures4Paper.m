%% Loading data

clear
close all

path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Main_Functions');


PathName1 = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Existing_Data\20150908_Paper';
PathName2 = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Stats_data\20150908_Paper';
PathName3 = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Reconstructed\20150908_Paper';


load([PathName1,'\Cracks.mat']);
load([PathName1,'\Pores.mat']);
%load([PathName1,'\Voids.mat']);
geo_CP = [Cracks.All;Pores.All];

% vars = [Cracks.All;Pores.All];
% vars(:,6:7) = [];

varNames = {'X_c';'Y_c';'a';'b';'\theta'};


%% color map of the different phases
%{
b1 = [0.8 0 0];
b2 = [1.0 0.8 0];
b3 = [0.4 0.4 1.0];

C = zeros(495,660,3);

C(:,:,1) = b1(1)*I2 + b2(1)*I3 + b3(1)*I4;
C(:,:,2) = b1(2)*I2 + b2(2)*I3 + b3(2)*I4;
C(:,:,3) = b1(3)*I2 + b2(3)*I3 + b3(3)*I4;

cmap = [b1;b2;b3];
colormap(cmap);
%}

%% Image after histogram
%{
h1 = figure;
imshow(I1);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
h1 = tightfig(h1);

h2 = figure;
image(C);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
h2 = tightfig(h2);

hold on
L = line(ones(3),ones(3), 'LineWidth',2);
set(L,{'color'},mat2cell(cmap,ones(1,3),3));
legend('Defects','Matrix','Tow')
hold off
%%}
%%

%% Long-Trans separation - before image closing and opening
%%{
a1 = [0.7294    0.8314    0.9569];
a2 = [1.0000    1.0000    0.6000];

D = zeros(495,660,3);
D(:,:,1) = a1(1)*I_out_L + a2(1)*I_out_T;
D(:,:,2) = a1(2)*I_out_L + a2(2)*I_out_T;
D(:,:,3) = a1(3)*I_out_L + a2(3)*I_out_T;

cmap = [a1;a2];
colormap(cmap);

h3 = figure;
image(D);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
h3 = tightfig(h3);

hold on
L = line(ones(2),ones(2), 'LineWidth',2);
set(L,{'color'},mat2cell(cmap,ones(1,2),3));
legend('Longitudinal Tow','Transverse Tow')
hold off
%%}
%%

%% Ellipse approximation
%{
ell = 98;
h4 = figure;
% imshow(I1),
% ellipse(geo(:,1),geo(:,2),geo(:,3)/2,geo(:,4)/2,geo(:,5),'r');
imshow(I1),
ellipse(geo(ell,1),geo(ell,2),geo(ell,3)/2,geo(ell,4)/2,geo(ell,5),[0.929 0.694 0.125]);
h4 = tightfig(h4);

%major axis
A = tan(geo(ell,5));
B = geo(ell,2) - A*geo(ell,1);
x1 = 246; y1 = A*x1 + B; 
x2 = 286; y2 = A*x2 + B;
%minor axis
A90 = tan(geo(ell,5) + pi/2); 
B90 = geo(ell,2) - A90*geo(ell,1);
y3 = 325; x3 = (y3 -B90)/A90;
y4 = 305; x4 = (y4 -B90)/A90;

h5 = figure;
hold on
imshow(I1),
ellipse(geo(ell,1),geo(ell,2),geo(ell,3)/2,geo(ell,4)/2,geo(ell,5),[0 0.447 0.741]);
xlim([210 325]);
ylim([268 354]);
line([x1,x2],[y1,y2],'Color',[0.929 0.694 0.125],'LineWidth',2)
line([x3,x4],[y3,y4],'Color',[0.929 0.694 0.125],'LineWidth',2)
h5 = tightfig(h5);
hold off
%}
%%

%% Statistical analysis
%{
color_mat = [0     0.447 0.741;
             0.850 0.325 0.098;
             0.929 0.694 0.125];

% Old Data - It has voids in it!!!
PathName = 'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Saved_Data\Existing_Data\20150722';
load([PathName,'\Cracks.mat']);
load([PathName,'\Pores.mat']);
load([PathName,'\Voids.mat']);
load([PathName,'\geo_CP.mat']);

varNames = {'X_c';'Y_c';'a';'b';'\theta'};

vars_cracks = Cracks(:,1:5);
group_cracks = ones(length(Cracks),1);

vars_pores  = Pores(:,1:5);
group_pores = 2.*ones(length(Pores),1);

vars_voids  = Voids(:,1:5);
group_voids = 3.*ones(length(Voids),1);

vars_all = [vars_cracks;vars_pores;vars_voids];
group_all = [group_cracks;group_pores;group_voids];

h6 = figure;
[~,ax6,bigax6] = gplotmatrix(vars_all,[],group_all,color_mat,[],[4 4 4],'on','stairs',varNames);
h6.OuterPosition = [130 150 855 765];
L=length(ax6(:));
%for l=1:L;ax6(l).LabelFontSizeMultiplier = 0.8;end
lh = findobj('Tag','legend');
set(lh,'String',{'Cracks','Pores','Voids'});
%set(lh,'Orientation','horizontal');
% newPosition = [0.4 0.4 0.1 0.1];
% newUnits = 'normalized';
% set(lh,'Position', newPosition,'Units', newUnits);
h6 = tightfig(h6);


h7 = figure;
[~,ax7,bigax7] = gplotmatrix([vars_cracks;vars_pores],[],[],...
    [0 0.447 0.741],[],[],[],'hist',varNames);
h7.OuterPosition = [130 150 855 765];
L=length(ax7(:));
%for l=1:L;ax7(l).LabelFontSizeMultiplier = 0.8;end
h7 = tightfig(h7);
%}

%% Cracks - Pores Historams 
%{
%Cracks and Poers Xc location
nbins = 30;

%{
h8a = figure;
histogram(Cracks(:,1),nbins,'Normalization','probability');
grid on;
set(gca,'XLim',[0 max(Cracks(:,1))]);
set(gca,'YTick',[0 0.01 0.02 0.03 0.04 0.05])
xlabel('X_C');
ylabel('Normalized frequency');
h8a = tightfig(h8a);

h8b = figure;
histogram(Pores(:,1),nbins,'FaceColor',[0.850 0.325 0.098],'Normalization','probability');
grid on;
set(gca,'XLim',[0 max(Pores(:,1))]);
set(gca,'YTick',[0 0.01 0.02 0.03 0.04 0.05])
xlabel('X_C');
ylabel('Normalized frequency');
h8b = tightfig(h8b);

%Cracks an Poers major axis
h8c = figure;histogram(Cracks(:,3),nbins,'Normalization','probability');
grid on;
set(gca,'XLim',[0 max(Cracks(:,3))]);
xlabel('Major axis length');
ylabel('Normalized frequency');
% set(gca,'YLim',[0 0.5]);
% set(gca,'YTick',[0 0.1 0.2 0.3 0.4 0.5])
h8c = tightfig(h8c);

h8d = figure;histogram(Pores(:,3),nbins,'FaceColor',[0.850 0.325 0.098],'Normalization','probability');
grid on;
set(gca,'XLim',[0 max(Pores(:,3))]);
xlabel('Major axis length');
ylabel('Normalized frequency');
% set(gca,'YLim',[0 0.5]);
% set(gca,'YTick',[0 0.1 0.2 0.3 0.4 0.5])
h8d = tightfig(h8d);


h8A = figure;
hold on;
histogram(Cracks(:,1),nbins,'Normalization','probability');
histogram(Pores(:,1),nbins,'FaceColor',[0.850 0.325 0.098],...
    'FaceAlpha',0.3,'Normalization','probability');
set(gca,'XLim',[0 max(Cracks(:,1))]);
set(gca,'YTick',[0 0.01 0.02 0.03 0.04 0.05])
grid on;
xlabel('X_C');
ylabel('Normalized frequency');
legend('Cracks','Pores')
h8A = tightfig(h8A);
hold off;

h8B = figure;
hold on;
histogram(Cracks(:,3),nbins,'Normalization','probability');
histogram(Pores(:,3),nbins,'FaceColor',[0.850 0.325 0.098],...
    'FaceAlpha',0.3,'Normalization','probability');
set(gca,'XLim',[0 max(Cracks(:,3))]);
set(gca,'YLim',[0 0.5]);
set(gca,'YTick',[0 0.1 0.2 0.3 0.4 0.5])
grid on;
xlabel('Major axis length');
ylabel('Normalized frequency');
legend('Cracks','Pores')
h8B = tightfig(h8B);
hold off;
%}
h8a = figure;

subplot_tight(2,1,1,0.05);
histogram(Cracks(:,1),nbins,'Normalization','probability');
grid on;legend('Cracks');
set(gca,'XLim',[0 max([Cracks(:,1);Pores(:,1)])]);
set(gca,'XTickLabel',[])

subplot_tight(2,1,2,0.05);
histogram(Pores(:,1),nbins,'FaceColor',[0.850 0.325 0.098],'Normalization','probability');
grid on;legend('Pores');xlabel('X_C');
set(gca,'XLim',[0 max([Cracks(:,1);Pores(:,1)])]);

suplabel('Normalized frequency','y');

h8B = tightfig(h8a);


h8b = figure;

subplot_tight(2,1,1,0.05);
histogram(Cracks(:,3),nbins,'Normalization','probability');
grid on;legend('Cracks');
set(gca,'XLim',[0 max([Cracks(:,3);Pores(:,3)])]);
set(gca,'XTickLabel',[])

subplot_tight(2,1,2,0.05);
histogram(Pores(:,3),nbins,'FaceColor',[0.850 0.325 0.098],'Normalization','probability');
grid on;legend('Pores');xlabel('Major axis');
set(gca,'XLim',[0 max([Cracks(:,3);Pores(:,3)])]);

suplabel('Normalized frequency','y');

h8b = tightfig(h8b);
%}

%% Kernel Plots (NO FT-FL separation)
%%{
vars = geo_CP(:,1:5);
parameter={'X_c';'Y_c';'Major Axis';'Minor Axis';'Oriantation'};

hname = {'Normal';'Epanechnikov';'Box';'Triangle'};
lines = {'-';'-.';'--';':'};
x_label = {'X_c [pixels]';
           'Y_c [pixels]';
           'Major Axis [pixels]';
           'Minor Axis [pixels]';
           'Oriantation angle [rad]'};

pd = cell(length(hname),length(parameter));
histo = cell(1,length(parameter));

for p=1:length(parameter);
    % Generate kernel distribution objects and plot
    
    h9 = figure;
    if strcmp(parameter{p},'Oriantation')
        histo{p} = histogram(vars(:,p),6,'Normalization','pdf');
        set(get(gca,'Children'),'FaceColor',[0.870 0.921 0.980]);
        xlim([0 pi+0.4]);
        ylim([0 1]);
    else
        histo{p} = histogram(vars(:,p),'Normalization','pdf');
        set(get(gca,'Children'),'FaceColor',[0.870 0.921 0.980]);
    end
    

    
    hold on;
    for j=1:4
        if strcmp(parameter{p},'Oriantation')
            pd{j,p} = fitdist(sort(vars(:,p)),'Kernel','Kernel',hname{j},'width',0.3);
        else
            pd{j,p} = fitdist(sort(vars(:,p)),'Kernel','Kernel',hname{j});
        end
        y = pdf(pd{j,p},sort(vars(:,p)));
        plot(sort(vars(:,p)),y,'LineStyle',lines{j});
        clear y;
    end
    hold off;
    
    grid on;
    leg = ['Hisogram';hname];
    if strcmp(parameter{p},'Oriantation')
       legend(leg{:},'Location','northwest');
    else
    legend(leg{:});    
    end    
    xlabel(x_label(p));
    ylabel('Normalized frequency');
    %{
    switch parameter{p}
        case {'X_c','Y_c'};
            set(gca,'YLim',[0 4.5e-3]);
        case {'Major Axis';'Minor Axis'};
            set(gca,'XLim',[0 ab_xmax],'YLim',[0 0.45]);
    end
    %}
    tightfig(h9);
 end
%%}


%% Kernel Plots (With FT-FL separation)
%{


load([PathName1,'\CP_M.mat']);
load([PathName1,'\CP_FL.mat']);
load([PathName1,'\CP_FT.mat']);



parameter={'X_c';'Y_c';'Major Axis';'Minor Axis';'Oriantation'};

hname = {'Normal';'Epanechnikov';'Box';'Triangle'};
lines = {'-';'-.';'--';':'};

pd = cell(length(hname),length(parameter),3);
histo = cell(1,length(parameter));

for phase=1:3
    
    switch phase
        case 1
            vars = CP_M;
        case 2
            vars = CP_FL;
        case 3 
            vars = CP_FT;
    end
    
    
    for p=1:length(parameter);
        % Generate kernel distribution objects and plot
        
        h10 = figure;
        histo{p} = histogram(vars(:,p),'Normalization','pdf');
        set(get(gca,'Children'),'FaceColor',[0.870 0.921 0.980])
        
        
        hold on;
        for j=1:4
            if strcmp(parameter{p},'Oriantation')
                pd{j,p,phase} = fitdist(sort(vars(:,p)),'Kernel','Kernel',hname{j},'width',0.3);
            else
                pd{j,p,phase} = fitdist(sort(vars(:,p)),'Kernel','Kernel',hname{j});
            end
            y = pdf(pd{j,p,phase},sort(vars(:,p)));
            plot(sort(vars(:,p)),y,'LineStyle',lines{j});
            clear y;
        end
        hold off;
        
        grid on;
        leg = ['Hisogram';hname];
        legend(leg{:});
        %{
    switch parameter{p}
        case {'X_c','Y_c'};
            set(gca,'YLim',[0 4.5e-3]);
        case {'Major Axis';'Minor Axis'};
            set(gca,'XLim',[0 ab_xmax],'YLim',[0 0.45]);
    end
        %}
        
        tightfig(h10);
    end
end
%}


%% Multi-Variat plots (NO FT-LT separation)

%%{

load([PathName2,'\RV_All.mat']);
load([PathName2,'\F_All.mat']);
%load([PathName1,'\geo_CP.mat']);

load([PathName3,'\Defects_M.mat'])
load([PathName1,'\CP_M.mat'])
CP_Rec_M = Defects;
clear Defects

load([PathName3,'\Defects_FL.mat'])
load([PathName1,'\CP_FL.mat'])
CP_Rec_FL = Defects;
clear Defects

load([PathName3,'\Defects_FT.mat'])
load([PathName1,'\CP_FT.mat'])
CP_Rec_FT = Defects;
clear Defects

CP_Rec_All = [CP_Rec_M;CP_Rec_FL;CP_Rec_FT];


RV1 = RV_All(:,1);
RV2 = RV_All(:,2);
F = F_All;

h11 = figure;
mesh(RV1,RV2,F);
xlabel('Major axis [pixels]');
ylabel('Minor axis [pixels]');
zlabel('Probability Density');
grid on
xlim([0 30]);
ylim([0 20]);
tightfig(h11);
       

h13a = figure;
hist3_normelized([geo_CP(:,3),geo_CP(:,4)],...
    [15,15],'Normalization',max(max(F)));
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%ax = gca;
grid on
xlabel('Major axis [pixels]');
ylabel('Minor axis [pixels]');
zlabel('Normalized frequency');
xlim([0 30]);
ylim([0 20]);
tightfig(h13a);

geo_CP_a = [Pores.M;Pores.FL;Pores.FT;Cracks.M;Cracks.FL;Cracks.FT];
h13b = figure;
hist3_normelized([geo_CP_a(:,3),geo_CP_a(:,4)],...
    [15,15],'Normalization',max(max(F)));
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%ax = gca;
grid on
xlabel('Major axis [pixels]');
ylabel('Minor axis [pixels]');
zlabel('Normalized frequency');
xlim([0 30]);
ylim([0 20]);
tightfig(h13b);

h14a = figure;
hist3_normelized([CP_Rec_All(:,4),CP_Rec_All(:,5)],...
    [15,15],'Normalization',max(max(F)));
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%ax = gca;
grid on
xlabel('Major axis [pixels]');
ylabel('Middle axis [pixels]');
zlabel('Normalized frequency');
xlim([0 30]);
ylim([0 20]);
tightfig(h14a);


%%%%%%%%%%%%%%%%%%%%%%
% htesting = figure;
% histogram2(geo_CP(:,3),geo_CP(:,4),[15,15],...
%     'Normalization','pdf','FaceColor','flat');
% % set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
% %ax = gca;
% grid on
% xlabel('Major axis [pixels]');
% ylabel('Minor axis [pixels]');
% zlabel('Normalized frequency');
% xlim([0 30]);
% ylim([0 20]);
% tightfig(htesting);
% 
% htesting1 = figure;
% histogram2(CP_Rec_All(:,4),CP_Rec_All(:,5),[30,30],...
%     'Normalization','pdf','FaceColor','flat');
% % set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
% %ax = gca;
% grid on
% xlabel('Major axis [pixels]');
% ylabel('Minor axis [pixels]');
% zlabel('Normalized frequency');
% xlim([0 30]);
% ylim([0 20]);
% tightfig(htesting1);

%%%%%%%%%%%%%%%%%%%%%%

%{
h13b = figure;
hist3_normelized([CP_FL(:,3),CP_FL(:,4)],...
    [15,15],'Normalization',max(max(F)));
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%ax = gca;
grid on
xlabel('Major axis [pixels]');
ylabel('Minor axis [pixels]');
zlabel('Normalized frequency');
xlim([0 30]);
ylim([0 20]);
tightfig(h13b);


h14b = figure;
hist3_normelized([CP_Rec_FL(:,4),CP_Rec_FL(:,5)],...
    [15,15],'Normalization',max(max(F)));
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%ax = gca;
grid on
xlabel('Major axis [pixels]');
ylabel('Minor axis [pixels]');
zlabel('Normalized frequency');
xlim([0 30]);
ylim([0 20]);
tightfig(h14b);

h13c = figure;
hist3_normelized([CP_FT(:,3),CP_FT(:,4)],...
    [15,15],'Normalization',max(max(F)));
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%ax = gca;
grid on
xlabel('Major axis [pixels]');
ylabel('Minor axis [pixels]');
zlabel('Normalized frequency');
xlim([0 30]);
ylim([0 20]);
tightfig(h13c);


h14c = figure;
hist3_normelized([CP_Rec_FT(:,4),CP_Rec_FT(:,5)],...
    [15,15],'Normalization',max(max(F)));
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%ax = gca;
grid on
xlabel('Major axis [pixels]');
ylabel('Minor axis [pixels]');
zlabel('Normalized frequency');
xlim([0 30]);
ylim([0 20]);
tightfig(h14c);
%}



%%
% h15a = figure;
% subplot_tight(2,1,1,0.05);
% histogram(geo_CP(:,1),30,'Normalization','pdf');
% grid on;legend('Experimental');
% xlim([50 450]);
% subplot_tight(2,1,2,0.05);
% histogram(CP_Rec_All(:,1),'FaceColor',[0.85 0.325 0.098],...
%     'Normalization','pdf');
% grid on;legend('Generated');xlabel('X_C [pixels]');
% xlim([50 1300]);
% suplabel('Normalized frequency','y');
% h15a = tightfig(h15a);
% 
% h15b = figure;
% subplot_tight(2,1,1,0.05);
% histogram(geo_CP(:,2),30,'Normalization','pdf');
% grid on;legend('Experimental');
% xlim([50 450]);
% 
% subplot_tight(2,1,2,0.05);
% histogram(CP_Rec_All(:,2),'FaceColor',[0.85 0.325 0.098],...
%     'Normalization','pdf');
% grid on;legend('Generated');xlabel('Y_C [pixels]');
% xlim([50 1300]);
% 
% suplabel('Normalized frequency','y');
% 
% h15b = tightfig(h15b);



%%

h16a1 = figure;
histogram(vars(:,2),'Normalization','pdf');
grid on;legend('Experimental');
xlabel('X_c [pixels]');
ylabel('Normalized frequency');
%xlim([0 50])%ylim([0 0.5]);
h16a1 = tightfig(h16a1);


h16a2 = figure;
histogram(CP_Rec_All(:,1),'Normalization','pdf','FaceColor',[0.850 0.325 0.098]);
grid on;legend('Generated');
xlabel('X_c [pixels]');
ylabel('Normalized frequency');
%xlim([0 50])%ylim([0 0.5]);
h16a2 = tightfig(h16a2);


h16b1 = figure;
histogram(vars(:,2),'Normalization','pdf');
grid on;legend('Experimental');
xlabel('Y_c [pixels]');
ylabel('Normalized frequency');
%xlim([0 50]);%ylim([0 0.5]);
h16b1 = tightfig(h16b1);


h16b2 = figure;
histogram(CP_Rec_All(:,2),'Normalization','pdf','FaceColor',[0.850 0.325 0.098]);
grid on;legend('Generated');
xlabel('Y_c [pixels]');
ylabel('Normalized frequency');
%xlim([0 50]);%ylim([0 0.5]);
h16b2 = tightfig(h16b2);

h17a = figure;
hist_ang = histogram(vars(:,5),6,'Normalization','pdf');
%set(get(gca,'Children'),'FaceColor',[0.870 0.921 0.980]);
hold on;
y = pdf(pd{1,5},sort(vars(:,5)));
plot(sort(vars(:,5)),y);
hold off
leg1 = {'Experimental';'Normal kernel'};
legend(leg1{:},'Location','northwest');
grid on;
xlim([0 pi+0.4]),ylim([0 1]);
xlabel('Orientation angle [rad]');
ylabel('Normalized frequency');
h17a = tightfig(h17a);        

h17b = figure;
histogram(CP_Rec_All(:,7),hist_ang.BinEdges,'Normalization','pdf');
hold on;
y = pdf(pd{1,5},sort(vars(:,5)));
plot(sort(vars(:,5)),y);
hold off;
leg2 = {'Generated';'Normal kernel'};
legend(leg2{:},'Location','northwest');
grid on;
xlim([0 pi+0.4]),ylim([0 1]);
xlabel('Orientation angle [rad]');
ylabel('Normalized frequency');
h17b = tightfig(h17b);



%%}
