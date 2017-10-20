function [pd,histo] = Univariate_Kernel_pdf(vars)
%Univariate Analysis
% This function takes an array with the geometric parameters of the defects
% returns pd and histo and plots them. 
% pd - kernel probability distribution
% histo - the parameters histogram.  

parameter={'X_c';'Y_c';'Major Axis';'Minor Axis';'Oriantation'};

hname = {'Normal';'Epanechnikov';'Box';'Triangle'};
lines = {'-';'-.';'--';':'};

pd = cell(length(hname),length(parameter));
histo = cell(1,length(parameter));

for p=1:length(parameter)
    
    
    % Generate kernel distribution objects and plot
    figure;
    histo{p} = histogram(vars(:,p),'Normalization','pdf');
    set(get(gca,'Children'),'FaceColor',[0.870 0.921 0.980]);
    
    hold on;
    for j=1:4
        if strcmp(parameter{p},'Oriantation')
            pd{j,p} = fitdist(sort(vars(:,p)),'kernel','Kernel',hname{j},'width',0.3);
        else
            pd{j,p} = fitdist(sort(vars(:,p)),'kernel','Kernel',hname{j});
        end
        y = pdf(pd{j,p},sort(vars(:,p)));
        plot(sort(vars(:,p)),y,'LineStyle',lines{j});
        clear y;
    end
    
    grid on;
    title(parameter{p});
    leg = ['Hisogram';hname];
    legend(leg{:});
    hold off;
end
end