    function [RandVar,F,Mu,Sigma,out_vars] = Multivariate_pdf(vars,Min_Cor)

% y = mvnpdf(X,MU,SIGMA) returns the density of the multivariate
% normal distribution with mean MU and covariance SIGMA,
% evaluated at each row of X. SIGMA is a d-by-d matrix,
% or a d-by-d-by-n array, in which case the density is evaluated
% for each row of X with the corresponding page of SIGMA,
% i.e., mvnpdf computes y(i) using X(i,:) and SIGMA(:,:,i).
% If the covariance matrix is diagonal, containing variances
% along the diagonal and zero covariances off the diagonal,
% SIGMA may also be specified as a 1-by-d vector or a 1-by-d-by-n array,
% containing just the diagonal.
% Specify [] for MU to use its default value when you want to specify only SIGMA.
%
% If X is a 1-by-d vector, mvnpdf replicates it to match the leading
% dimension of mu or the trailing dimension of SIGMA.

if nargin < 2
    Min_Cor = 0.3;
end


% vars:
% x,y,a,b,angle

num_points = 1000;

varNames = {'X_c'; 'Y_c'; 'Major Axis'; 'Minor Axis'; 'Orientation'};

%Correlation matrix
Cor = corrcoef(vars);

%Covariance matrix
Cov = cov(vars);

%Determining which are the Dependent Variable
Cor_temp = triu(Cor,1); %upper tiangulare matrix
Cor_temp(abs(Cor_temp) <= Min_Cor) = 0; %clear correlation under Min_Cor
[Row,Col] = find(Cor_temp);

clear Cor_temp

%Extracting the dependent variable
dependent_vars = sort(unique([Row;Col]));
out_vars = varNames(dependent_vars);
num_RV = length(dependent_vars);

%Mean Values
Mu = mean(vars(:,dependent_vars));
%Covariance matrix - only dependent variables
Sigma = cov(vars(:,dependent_vars));

%Finding the support of the data 
support = zeros(2,num_RV);
RandVar = zeros(num_points,num_RV);

support(1,:) = min(vars(:,dependent_vars(:))); % lower bound
support(2,:) = max(vars(:,dependent_vars(:))); % upper bound

for i = 1:num_RV
    RandVar(:,i) = linspace(support(1,i),support(2,1),num_points)';
end

switch num_RV
    case 2
                
        [RV1,RV2] = meshgrid(RandVar(:,1),RandVar(:,2));
        F = mvnpdf([RV1(:) RV2(:)],Mu,Sigma);
        F = reshape(F,length(RV1),length(RV2));
        
        figure;
        mesh(RV1,RV2,F);
        xlabel(varNames{dependent_vars(1)});
        ylabel(varNames{dependent_vars(2)});
        zlabel('Probability Density');
        
        figure;
        contour3(RV1,RV2,F);
        xlabel(varNames{dependent_vars(1)});
        ylabel(varNames{dependent_vars(2)});
        zlabel('Probability Density');
        
        figure;
        hist3([vars(:,dependent_vars(1)),vars(:,dependent_vars(2))]);
        xlabel(varNames{dependent_vars(1)});
        ylabel(varNames{dependent_vars(2)});
        zlabel('Probability Density');
        
        figure;
        hist3_normelized([vars(:,dependent_vars(1)),vars(:,dependent_vars(2))],...
            [15,15],'Normalization',max(max(F)));
        set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
        hold on
        contour3(RV1,RV2,F);
        %ax = gca;
        grid on
        hold off
        xlabel(varNames{dependent_vars(1)});
        ylabel(varNames{dependent_vars(2)});
        zlabel('Probability Density');
        
    case 3
        [RV1,RV2,RV3] = meshgrid(RandVar(:,1),RandVar(:,2),RandVar(:,3));
        F = mvnpdf([RV1(:) RV2(:) RV3(:)],Mu,Sigma);
end
end