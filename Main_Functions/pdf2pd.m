function [ pd ] = pdf2pd(xq,pdf)
%pdf2pd does Inverse transform samplinge
% http://en.wikipedia.org/wiki/Inverse_transform_sampling
% http://matlabtricks.com/post-44/generate-random-numbers-with-a-given-distribution

% the integral of PDF is the cumulative distribution function
cdf = cumsum(pdf);

% these two variables holds and describes the CDF
% xq;         % x
% cdf;        % P(x)

% remove non-unique elements
% [cdf, mask] = unique(cdf);
% xq = xq(mask);

% create an array of 2500 random numbers
randomValues = rand(2500,1);

% inverse interpolation to achieve P(x) -> x projection of the random values
projection = interp1(cdf, xq, randomValues);
projection(~any(~isnan(projection), 2),:)=[];
projection(~any(~isinf(projection), 2),:)=[];

pd = fitdist(projection,'Kernel','Kernel','normal');

end

