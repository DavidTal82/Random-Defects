clear all
close all


path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main');
path(path,'C:\Users\operator\Documents\MATLAB\Matlab_Research\Main\Main_Functions');

PathName = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Reconstructed\20150908_Paper\';
PathName1 = 'C:\Users\operator\Documents\MATLAB\MATLAB_Research\Main\Saved_Data\Existing_Data\';


load([PathName,'Volum_3D_M.mat'])
M_3D_Defects = volume_3D;
clear volume_3D

load([PathName,'Volum_3D_FL.mat'])
FL_3D_Defects = volume_3D;
clear volume_3D

load([PathName,'Volum_3D_FT.mat'])
FT_3D_Defects = volume_3D;
clear volume_3D

load([PathName1,'unit_cell_M.mat']);
load([PathName1,'unit_cell_FT.mat']);
load([PathName1,'unit_cell_FL.mat']);

unit_cell_M2 = logical(interp3(single(unit_cell_M),2));
unit_cell_FL2 = logical(interp3(single(unit_cell_FL),2));
unit_cell_FT2 = logical(interp3(single(unit_cell_FT),2));

unit_cell = uint8(zeros(size(unit_cell_M2)));
unit_cell(unit_cell_M2) = 0;
unit_cell(unit_cell_FL2) = 50;
unit_cell(unit_cell_FT2) = 100;
unit_cell(unit_cell_FL2 & unit_cell_FT2) = 255;

% unit_cell(M_3D_Defects) = 155;
% unit_cell(FL_3D_Defects) = 205;
% unit_cell(FT_3D_Defects) = 255;

unit_cell(1,:,1) = 0;
unit_cell(1,:,2) = 50;
unit_cell(1,:,3) = 100;
unit_cell(1,:,4) = 155;
unit_cell(1,:,5) = 205;
unit_cell(1,:,6) = 255;

%{
r = 10; c = 16;
unit_cell(300,:,1) = 0;
unit_cell(300,:,2) = 50;
unit_cell(300,:,3) = 100;
unit_cell(300,:,4) = 155;
unit_cell(300,:,5) = 205;
unit_cell(300,:,6) = 255;

figure,
hold on
for i = 1:160;
    j = i+180;
    subplot(r,c,i);imagesc(squeeze(unit_cell(300:500,j,:))');
end
hold off
%}


% figure,
% hold on
% for i = 1:100;
%     j = i;
%     subplot(10,10,i);imagesc(squeeze(unit_cell(j,1:500,:))');
% end
% hold off
% 
% figure,
% hold on
% for i = 1:100;
%     j = i;
%     subplot(10,10,i);imagesc(squeeze(unit_cell(1:500,j,:))');
% end
% hold off

slice = [85,255,423,591,759,927,1095,1263];


%{
figure;imagesc(squeeze(unit_cell(:,85,:))');title('FL1');
figure;imagesc(squeeze(unit_cell(:,255,:))');title('FL2');
figure;imagesc(squeeze(unit_cell(:,423,:))');title('FL3');
figure;imagesc(squeeze(unit_cell(:,591,:))');title('FL4');
figure;imagesc(squeeze(unit_cell(:,759,:))');title('FL5');
figure;imagesc(squeeze(unit_cell(:,927,:))');title('FL6');
figure;imagesc(squeeze(unit_cell(:,1095,:))');title('FL7');
figure;imagesc(squeeze(unit_cell(:,1263,:))');title('FL8');
%}
  
FL1 = squeeze(unit_cell_FL2(85,:,:))';
FL2 = squeeze(unit_cell_FL2(255,:,:))';
FL3 = squeeze(unit_cell_FL2(423,:,:))';
FL4 = squeeze(unit_cell_FL2(591,:,:))';
FL5 = squeeze(unit_cell_FL2(759,:,:))';
FL6 = squeeze(unit_cell_FL2(927,:,:))';
FL7 = squeeze(unit_cell_FL2(1095,:,:))';
FL8 = squeeze(unit_cell_FL2(1263,:,:))';

stats_FL1 = regionprops(FL1,'Centroid');
stats_FL2 = regionprops(FL2,'Centroid');
stats_FL3 = regionprops(FL3,'Centroid');
stats_FL4 = regionprops(FL4,'Centroid');
stats_FL5 = regionprops(FL5,'Centroid');
stats_FL6 = regionprops(FL6,'Centroid');
stats_FL7 = regionprops(FL7,'Centroid');
stats_FL8 = regionprops(FL8,'Centroid');

C = zeros(8,2,8);
C_avg = zeros(8,2);

for i = 1:8

C(1:8,:,i) = [stats_FL1(i).Centroid;stats_FL2(i).Centroid;...
      stats_FL3(i).Centroid;stats_FL4(i).Centroid;...
      stats_FL5(i).Centroid;stats_FL6(i).Centroid;...
      stats_FL7(i).Centroid;stats_FL8(i).Centroid];
  
  C_avg(i,:) = [mean(C(1:8,1,i)),mean(C(1:8,2,i))];
end




figure;imagesc(squeeze(unit_cell(:,85,:))');title('FL1');
figure;imagesc(squeeze(unit_cell(:,255,:))');title('FL2');
figure;imagesc(squeeze(unit_cell(:,423,:))');title('FL3');
figure;imagesc(squeeze(unit_cell(:,591,:))');title('FL4');
figure;imagesc(squeeze(unit_cell(:,759,:))');title('FL5');
figure;imagesc(squeeze(unit_cell(:,927,:))');title('FL6');
figure;imagesc(squeeze(unit_cell(:,1095,:))');title('FL7');
figure;imagesc(squeeze(unit_cell(:,1263,:))');title('FL8');



figure;imagesc(squeeze(unit_cell(85,:,:))');title('FT1');
figure;imagesc(squeeze(unit_cell(255,:,:))');title('FT2');
figure;imagesc(squeeze(unit_cell(423,:,:))');title('FT3');
figure;imagesc(squeeze(unit_cell(591,:,:))');title('FT4');
figure;imagesc(squeeze(unit_cell(759,:,:))');title('FT5');
figure;imagesc(squeeze(unit_cell(927,:,:))');title('FT6');
figure;imagesc(squeeze(unit_cell(1095,:,:))');title('FT7');
figure;imagesc(squeeze(unit_cell(1263,:,:))');title('FT8');