function [pd,histo,RV,F,Mu,Sigma,depen] = ...
    StatisticalAnalysis( Defects_parameters , min_Cor )
%StatisticalAnalysis preformes statistical analysis of the geometric
%parmeters of the random defects

if nargin == 1
    min_Cor = 0.4;
end

vars = Defects_parameters(:,1:5);

% Univariate analysis
[pd,histo] = Univariate_Kernel_pdf(vars);

% Multivariate analysis
[RV,F,Mu,Sigma,depen] = Multivariate_pdf(vars,min_Cor);
%%Statistical Analysis
end

