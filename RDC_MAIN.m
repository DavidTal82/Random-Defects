%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Random Defects Characterization in Woven Composite Materials
% ------------------------------------------------------------
%
% This is the the main script which includes the folloeing steps:
% 1. Image processing
% 2. Image statistical analysis
% 3.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%{
clear; close all; %clc;
path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main');
path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Main_Functions');
%%}


%% Image Processing
%%{
ImProcessing = 0;
choice_image_processing = ...
    questdlg('Start Image Processing?','Image Processing');
switch choice_image_processing
    case 'Cancel'
    case 'No'
    case 'Yes'
        ImProcessing = 1;
end
%%}

if ImProcessing
    % FilterSpec = {'*.jpg';'*.tif';'*.png';'*.gif';'*.DCM'};
    % [FilesNames,PathName] = uigetfile(FilterSpec,'Select File(s)','MultiSelect','on');
    
    FilesNames = {'im_001.jpg','im_002.jpg','im_003.jpg','im_004.jpg','im_005.jpg','im_006.jpg'};
    %FilesNames = {'im_001.jpg'};
    PathName = 'C:\Users\operator\Documents\Research\CT_Samples\';
    
    % [Defect_mask,Matrix_mask,Fiber_mask,Fiber_T,Fiber_L,Defect_processed] = ...
    %     ImageProcessing( PathName , FilesNames);
    
    [Defect_mask,Matrix_mask,Fiber_mask,Fiber_T,Fiber_L,Defect_processed,Images] = ...
        ImageProcessing( PathName , FilesNames);
end
%%Image Processing


%% Geometic Characterization
%%{
GeoCharacter = 0;
choice_geometic_characterization = ...
    questdlg('Start Geometic Characterization?','Geometic Characterization');
switch choice_geometic_characterization
    case 'Cancel'
    case 'No'
    case 'Yes'
        GeoCharacter = 1;
end
%%}

if GeoCharacter
    % [Defects_Geometry,Delamination,Cracks,Pores,Voids,...
    %     Cracks_FT,Pores_FT,Cracks_FL,Pores_FL] = ...
    %     GeometricCharacterization(Defect_processed,Fiber_T,Fiber_L)
    
    [Defects_Geometry,Cracks,Pores,Voids,Delamination] = ...
        GeometricCharacterization(Defect_processed,Fiber_T,Fiber_L);
    

end

%%Geometic Characterization
%%}


%% Statistical Analysis

%%{
StatAnalysis = 0;
choice_statistical_analysis = ...
    questdlg('Start Statistical Analysis?','Statistical Analysis');
switch choice_statistical_analysis
    case 'Cancel'
    case 'No'
    case 'Yes'
        StatAnalysis = 1;
end
%%}

% Path_data = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Existing_Data\20150924';
% load([Path_data,'\Pores_M.mat']);
% load([Path_data,'\Pores_FT.mat']);
% load([Path_data,'\Pores_FL.mat']);
% load([Path_data,'\Cracks_M.mat']);
% load([Path_data,'\Cracks_FT.mat']);
% load([Path_data,'\Cracks_FL.mat']);
% [pd_FL,histo_FL,RV_FL,F_FL,Mu_FL,Sigma_FL,depen_FL] = ...
%     StatisticalAnalysis([Cracks_FL;Pores_FL]) ;
% [pd_FT,histo_FT,RV_FT,F_FT,Mu_FT,Sigma_FT,depen_FT] = ...
%     StatisticalAnalysis([Cracks_FT;Pores_FT]) ;
% [pd_M,histo_M,RV_M,F_M,Mu_M,Sigma_M,depen_M] = ...
%     StatisticalAnalysis([Cracks_M;Pores_M]) ;
% Cracks_All = [Cracks_FL;Cracks_FT;Cracks_M];
% Pores_All = [Pores_FL;Pores_FT;Pores_M];
% [pd_All,histo_All,RV_ALL,F_All,Mu_All,Sigma_All,depen_All] = ...
%     StatisticalAnalysis([Cracks_All;Pores_All]) ;

if StatAnalysis
    [pd_FL,histo_FL,RV_FL,F_FL,Mu_FL,Sigma_FL,depen_FL] = ...
        StatisticalAnalysis([Cracks.FL;Pores.FL]) ;
    
    [pd_FT,histo_FT,RV_FT,F_FT,Mu_FT,Sigma_FT,depen_FT] = ...
        StatisticalAnalysis([Cracks.FT;Pores.FT]) ;
    
    [pd_M,histo_M,RV_M,F_M,Mu_M,Sigma_M,depen_M] = ...
        StatisticalAnalysis([Cracks.M;Pores.M]) ;
    
    [pd_All,histo_All,RV_ALL,F_All,Mu_All,Sigma_All,depen_All] = ...
        StatisticalAnalysis([Cracks.All;Pores.All]) ;
end

%%Statistical Analysis


%%
choice_model_reconstruction = ...
    questdlg('Start Model Reconstruction?','Model Reconstruction');
switch choice_model_reconstruction
    case 'Cancel'
    case 'No'
    case 'Yes'
        Model_dim = inputdlg({'X dimension',...
            'Y dimension',...
            'Z dimension (2D model -> Z=0)'},...
            'Model Size');
end
%%Model Reconstruction


%% Action Menu
choice = menu('What Would You Like to Do?',...
    'Load Images',...
    'Image Processing',...
    'Load *.mat File with Binary Slices');


%% loading image/images - call function that will load images
[FilesNames,PathName] = uigetfile('All Files','Select the File(s) to Open','MultiSelect', 'on');

All_Images = cell(size(FilesNames));
%All_Images = zeros(image_size,size(FileName));


%% Image Processing - call the image processing module





