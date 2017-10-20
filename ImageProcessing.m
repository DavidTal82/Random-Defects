function [D_mask,M_mask,F_mask,TT,LT,D_processed,Images] = ...
    ImageProcessing( PathName , FilesNames )
%ImageProcessing Summary of this function goes here
%   Detailed explanation goes here


%Thresholding (Manually)
Thresh.Defect.max = 65;
Thresh.Defect.min = 1;
Thresh.Matrix.max = 200;
Thresh.Matrix.min = 66;
Thresh.Fiber.max = 255;
Thresh.Fiber.min = 220;

if ischar(FilesNames)
    num_images = 1;
    firs_file_name = FilesNames;
else
    num_images = length(FilesNames);
    firs_file_name = FilesNames{1};
end

firstImg = rgb2gray(imread([PathName,firs_file_name]));

Images = zeros([size(firstImg),num_images],'uint8');
All_masks = zeros([size(firstImg),num_images],'uint8');
segout = zeros([size(firstImg),num_images],'uint8');

D_mask = false([size(firstImg),num_images]);
M_mask = false([size(firstImg),num_images]);
F_mask = false([size(firstImg),num_images]);

Matrix = false([size(firstImg),num_images]);
LT = false([size(firstImg),num_images]);
TT = false([size(firstImg),num_images]);

D_processed = false(size(D_mask));

for im = 1:num_images
      
    FileName = fullfile(PathName,FilesNames{im});
        
    [I1,I2,I3,I4] = mask_separation(FileName,Thresh);
    
    Images(:,:,im) = I1;
    D_mask(:,:,im) = logical(I2);
    M_mask(:,:,im) = logical(I3);
    F_mask(:,:,im) = logical(I4);
    
    [TT(:,:,im),LT(:,:,im)] = ...
        tow2TransLong(logical(I4));
    
    Matrix(:,:,im) = (~(TT(:,:,im)|LT(:,:,im)));
    
    I5 = zeros(size(I1),'uint8');
    I5(~(~I2)) = 100;I5(~(~I3)) = 30;I5(~(~I4)) = 50;
    All_masks(:,:,im) = I5;
    
    [I2,I6] = image_processing(I1,I2); %I6 = Segout   
   
    D_processed(:,:,im) = I2;
    segout(:,:,im) = I6;
    

    %{
    h0=figure;
    imshow(I1);
    h1=figure;
    imagesc(I5);
    colorbar('Ticks',[30,50,100],'TickLabels',{'Matrix','Fibers','Defects'});
    
    
    h2=figure;
    subplot(2,2,1),imshow(I1),title('Original Image');
    subplot(2,2,2),imshow(I2),title('Defects Mask');
    subplot(2,2,3),imshow(I3),title('Matrix Mask');
    subplot(2,2,4),imshow(I4),title('Fiber Mask');
    tightfig;
    %}
end

end

