function Show_Defects_Plot(I,Cracks,Pores,Voids,Delamination)

%geo=[x,y,a,b,angle(rad),b/a,volume];

% figure;
% subplot(2,2,1),imshow(I),title('Original Image');
% subplot(2,2,2),imshow(Defects),title('Defects Mask');
% subplot(2,2,3),imshow(Segout),title('Outlined');
% subplot(2,2,4),imshow(Defects_processed),ellipse(geo(:,1),geo(:,2),geo(:,3)/2,geo(:,4)/2,angle(:),'r');

figure
imshow(I),
ellipse(Cracks(:,1),Cracks(:,2),Cracks(:,3)/2,Cracks(:,4)/2,Cracks(:,5),'r');
ellipse(Pores(:,1),Pores(:,2),Pores(:,3)/2,Pores(:,4)/2,Pores(:,5),'b');
ellipse(Voids(:,1),Voids(:,2),Voids(:,3)/2,Voids(:,4)/2,Voids(:,5),'g');
ellipse(Delamination(:,1),Delamination(:,2),Delamination(:,3)/2,Delamination(:,4)/2,Delamination(:,5),'y');

end