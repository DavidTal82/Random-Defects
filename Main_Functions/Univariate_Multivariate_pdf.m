clear all
close all
clc


%% Loading Data
load ('C:\Users\operator\Documents\MATLAB\Matlab_Research\Saved_Variables\Defects_cracks_0.5R_18032015.mat');
load ('C:\Users\operator\Documents\MATLAB\Matlab_Research\Saved_Variables\Defects_pores_0.5R_18032015.mat');
load ('C:\Users\operator\Documents\MATLAB\Matlab_Research\Saved_Variables\Defects_voids_18032015.mat');

% PathName = 'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Saved_Data\Stats_data\20150722';
% load([PathName,'\Cracks.mat']);
% load([PathName,'\Pores.mat']);
% load([PathName,'\Voids.mat']);

vars_cracks = Cracks(:,1:5);
group_cracks = ones(length(Cracks),1);

vars_pores  = Pores(:,1:5);
group_pores = 2.*ones(length(Pores),1);

vars_voids  = Voids(:,1:5);
group_voids = 3.*ones(length(Voids),1);

vars_all = [vars_cracks;vars_pores;vars_voids];
group_all = [group_cracks;group_pores;group_voids];

varNames = {'X_c'; 'Y_c'; 'Major Axis'; 'Minor Axis'; 'Orientation'};

%% Histograms Plots
%%{
h1 = figure;
[~,ax1,bigax1] = gplotmatrix(vars_all,[],[],[],[],[],[],'hist',varNames);
title('All Defects');
L=length(ax1(:));
for l=1:L;ax1(l).LabelFontSizeMultiplier = 0.8;end


h2 = figure;
[~,ax2,bigax2] = gplotmatrix(vars_all,[],group_all,['r' 'b' 'g'],[],[],false,'stairs',varNames);
title('All Defects - Grouped');
L=length(ax2(:));
for l=1:L;ax2(l).LabelFontSizeMultiplier = 0.8;end


h3 = figure;
[~,ax3,bigax3] = gplotmatrix(vars_cracks,[],group_cracks,'r',[],[],false,'hist',varNames);
title('Cracks');
L=length(ax3(:));
for l=1:L;ax1(3).LabelFontSizeMultiplier = 0.8;end

h4 = figure;
[~,ax4,bigax4] = gplotmatrix(vars_pores,[],group_pores,'b',[],[],false,'hist',varNames);
title('Pores');
L=length(ax4(:));
for l=1:L;ax4(l).LabelFontSizeMultiplier = 0.8;end

h5 = figure;
[~,ax5,bigax5] = gplotmatrix(vars_voids,[],group_voids,'g',[],[],false,'hist',varNames);
title('Voids');
L=length(ax5(:));
for l=1:L;ax5(l).LabelFontSizeMultiplier = 0.8;end
%%}

%% Uni-Variate Analysis
parameter={'X_c';'Y_c';'Major Axis';'Minor Axis';'Oriantation'};

hname = {'normal';'epanechnikov';'box';'triangle'};
colors = {'r';'b';'g';'m'};
lines = {'-';'-.';'--';':'};

pd = cell(length(hname),length(parameter));

for p=1:length(parameter);
    
    % Generate kernel distribution objects and plot
    figure;
    h = histogram(vars_cracks(:,p),'Normalization','pdf');
    set(get(gca,'Children'),'FaceColor',[0.870 0.921 0.980]);
    
       
    hold on;
    for j=1:4
        
        pd{j,p} = fitdist(sort(vars_cracks(:,p)),'kernel','Kernel',hname{j});
        y = pdf(pd{j,p},sort(vars_cracks(:,p)));        
        plot(sort(vars_cracks(:,p)),y,'Color',colors{j},'LineStyle',lines{j});
        clear y;
    end
    
    grid on;
    title(parameter{p});
    leg = ['hisogram';hname];
    legend(leg{:});
    hold off;
    
end

%% Multi-Variate Analysis
% geo:
% x,y,a,b,angle,b/a,volume

%Correlation matrix
Cor_all = corrcoef(vars_all);
Cor_cracks = corrcoef(vars_cracks);
Cor_pores = corrcoef(vars_pores);
Cor_voids = corrcoef(vars_voids);
cor_cracks_pores = corrcoef([vars_cracks;vars_pores]);

%Covariance matrix
Cov_all = cov(vars_all);
Cov_cracks = cov(vars_cracks);
Cov_pores = cov(vars_pores);
Cov_voids = cov(vars_voids);
cov_cracks_pores = cov([vars_cracks;vars_pores]);

%Mean Values
mu_all = mean(vars_all);
mu_cracks = mean(vars_cracks);
mu_pores = mean(vars_pores);
mu_voids = mean(vars_voids);
mu_cracks_pores = mean([vars_cracks;vars_pores]);

[a2,b2] = meshgrid(sort(a1),sort(b1));
F = mvnpdf([a2(:) b2(:)],mu,Sigma);
F = reshape(F,length(a2),length(b2));
figure;
surf(b2,a2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
axis([0 6 0 20 0 0.2])
xlabel('Minor axis (b)'); ylabel('Major axis (a)'); zlabel('Probability Density');

figure;
mesh(b2,a2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
axis([0 6 0 20 0 0.2])
xlabel('Minor axis (b)'); ylabel('Major axis (a)'); zlabel('Probability Density');

figure;
contour3(b2,a2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
%axis([0 6 0 20 0 0.2])
xlabel('Minor axis (b)'); ylabel('Major axis (a)'); zlabel('Probability Density');

figure;

hist3([b1,a1]);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
xlabel('Minor axis (b)'); ylabel('Major axis (a)'); zlabel('Probability Density');


figure;
hist3_normelized([b1,a1],[15,15],'Normalization',max(max(F)));
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
xlabel('Minor axis (b)'); ylabel('Major axis (a)'); zlabel('Probability Density');
grid on
hold on
contour3(b2,a2,F);
ax = gca;
hold off



