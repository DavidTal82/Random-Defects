function Show_Image_Plot(I,Defects,Segout,Defects_processed,geo)

%geo=[x,y,a,b,angle(rad),b/a,volume];

% figure;
% subplot(2,2,1),imshow(I),title('Original Image');
% subplot(2,2,2),imshow(Defects),title('Defects Mask');
% subplot(2,2,3),imshow(Segout),title('Outlined');
% subplot(2,2,4),imshow(Defects_processed),ellipse(geo(:,1),geo(:,2),geo(:,3)/2,geo(:,4)/2,angle(:),'r');

figure
imshow(Defects_processed),
ellipse(geo(:,1),geo(:,2),geo(:,3)/2,geo(:,4)/2,geo(:,5),'r');

end