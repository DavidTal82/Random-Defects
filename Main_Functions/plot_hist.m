function [ histo ] = plot_hist(input_data,plot_title)
%plot_hist plots a normalized histogram
%   The histogram is normalized to the pdf

histo = histogram(input_data);
set(get(gca,'Children'),'FaceColor',[0.870 0.921 0.980]);
histo.Normalization = 'pdf';    grid on;
xlabel(plot_title);
ylabel('Normalized frequency');


end

