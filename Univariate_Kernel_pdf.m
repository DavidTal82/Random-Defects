function [pd,histo] = Univariate_Kernel_pdf(vars)
%Uni-Variate Analysis
% This function takes an array with the geometric parameters of the defects
% returns pd and histo and plots them. 
% pd - kernel probability distribution
% histo - the parameters histogram.  

parameter={'X_c';'Y_c';'Major Axis';'Minor Axis';'Oriantation'};

hname = {'normal';'epanechnikov';'box';'triangle'};
colors = {'r';'b';'g';'m'};
lines = {'-';'-.';'--';':'};

pd = cell(length(hname),length(parameter));
histo = cell(1,length(parameter));

for p=1:length(parameter);
    
    % Generate kernel distribution objects and plot
    figure;
    histo{p} = histogram(vars(:,p),'Normalization','pdf');
    set(get(gca,'Children'),'FaceColor',[0.870 0.921 0.980]);
    
    hold on;
    for j=1:4
        pd{j,p} = fitdist(sort(vars(:,p)),'kernel','Kernel',hname{j});
        y = pdf(pd{j,p},sort(vars(:,p)));
        plot(sort(vars(:,p)),y,'Color',colors{j},'LineStyle',lines{j});
        clear y;
    end
    
    grid on;
    title(parameter{p});
    leg = ['hisogram';hname];
    legend(leg{:});
    hold off;
end
end




