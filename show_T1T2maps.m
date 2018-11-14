%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/03/2018 by Jihun Kwon
% Visualize T1map and T2*map and subtract air and O2 breathing
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
close all;

margins = [.007 .007];

%T1map, air
cd('C:\Users\jihun\Documents\MATLAB\BOLD\20181003_105730_Berbeco_Bi_Gd_1_21\7\pdata\2\dicom');
T1_air_z1 = dicomread('MRIm03.dcm');
T1_air_z2 = dicomread('MRIm08.dcm');
T1_air_z3 = dicomread('MRIm13.dcm');

%T2*map, air
cd('C:\Users\jihun\Documents\MATLAB\BOLD\20181003_105730_Berbeco_Bi_Gd_1_21\8\pdata\2\dicom');
T2_air_z1 = dicomread('MRIm03.dcm');
T2_air_z2 = dicomread('MRIm08.dcm');
T2_air_z3 = dicomread('MRIm13.dcm');

%T1map, O2
cd('C:\Users\jihun\Documents\MATLAB\BOLD\20181003_105730_Berbeco_Bi_Gd_1_21\9\pdata\2\dicom');
T1_O2_z1 = dicomread('MRIm03.dcm');
T1_O2_z2 = dicomread('MRIm08.dcm');
T1_O2_z3 = dicomread('MRIm13.dcm');

%T2*map, O2
cd('C:\Users\jihun\Documents\MATLAB\BOLD\20181003_105730_Berbeco_Bi_Gd_1_21\10\pdata\2\dicom');
T2_O2_z1 = dicomread('MRIm03.dcm');
T2_O2_z2 = dicomread('MRIm08.dcm');
T2_O2_z3 = dicomread('MRIm13.dcm');

%Subtract, T1map
T1sub_z1 = T1_air_z1 - T1_O2_z1;
T1sub_z2 = T1_air_z2 - T1_O2_z2;
T1sub_z3 = T1_air_z3 - T1_O2_z3;

%Subtract, T2*map
T2sub_z1 = T2_air_z1 - T2_O2_z1;
T2sub_z2 = T2_air_z2 - T2_O2_z2;
T2sub_z3 = T2_air_z3 - T2_O2_z3;

cd('C:\Users\jihun\Documents\MATLAB\BOLD')

figure(1);
subplot_tight(1,3,1,margins), imshow(T1_air_z1), title('T1, air, z1'); colorbar; colormap jet; set(gca,'clim',[0 10000]);
subplot_tight(1,3,2,margins), imshow(T1_air_z2), title('T1, air, z2'); colorbar; colormap jet; set(gca,'clim',[0 10000]);
subplot_tight(1,3,3,margins), imshow(T1_air_z3), title('T1, air, z3'); colorbar; colormap jet; set(gca,'clim',[0 10000]);
saveas(gcf,strcat('BOLD_T1map_air_M3.pdf'));

figure(2);
subplot_tight(1,3,1,margins), imshow(T2_air_z1), title('T2, air, z1'); colorbar; colormap jet; set(gca,'clim',[0 3500]);
subplot_tight(1,3,2,margins), imshow(T2_air_z2), title('T2, air, z2'); colorbar; colormap jet; set(gca,'clim',[0 3500]);
subplot_tight(1,3,3,margins), imshow(T2_air_z3), title('T2, air, z3'); colorbar; colormap jet; set(gca,'clim',[0 3500]);
saveas(gcf,strcat('BOLD_T2map_air_M3.pdf'));

figure(3);
subplot_tight(1,3,1,margins), imshow(T1_O2_z1), title('T1, O2, z1'); colorbar; colormap jet; set(gca,'clim',[0 10000]);
subplot_tight(1,3,2,margins), imshow(T1_O2_z2), title('T1, O2, z2'); colorbar; colormap jet; set(gca,'clim',[0 10000]);
subplot_tight(1,3,3,margins), imshow(T1_O2_z3), title('T1, O2, z3'); colorbar; colormap jet; set(gca,'clim',[0 10000]);
saveas(gcf,strcat('BOLD_T1map_O2_M3.pdf'));

figure(4);
subplot_tight(1,3,1,margins), imshow(T2_O2_z1), title('T2, O2, z1'); colorbar; colormap jet; set(gca,'clim',[0 3500]);
subplot_tight(1,3,2,margins), imshow(T2_O2_z2), title('T2, O2, z2'); colorbar; colormap jet; set(gca,'clim',[0 3500]);
subplot_tight(1,3,3,margins), imshow(T2_O2_z3), title('T2, O2, z3'); colorbar; colormap jet; set(gca,'clim',[0 3500]);
saveas(gcf,strcat('BOLD_T2map_O2_M3.pdf'));

figure(5);
subplot_tight(1,3,1,margins), imshow(T1sub_z1), title('T1, BOLD, z1'); colorbar; colormap(redblue); set(gca,'clim',[-3000 3000]);
subplot_tight(1,3,2,margins), imshow(T1sub_z2), title('T1, BOLD, z2'); colorbar; colormap(redblue); set(gca,'clim',[-3000 3000]);
subplot_tight(1,3,3,margins), imshow(T1sub_z3), title('T1, BOLD, z3'); colorbar; colormap(redblue); set(gca,'clim',[-3000 3000]);
saveas(gcf,strcat('BOLD_T1map_sub_M3.pdf'));

figure(6);
subplot_tight(1,3,1,margins), imshow(T2sub_z1), title('T2, BOLD, z1'); colorbar; colormap(redblue); set(gca,'clim',[-800 800]);
subplot_tight(1,3,2,margins), imshow(T2sub_z2), title('T2, BOLD, z2'); colorbar; colormap(redblue); set(gca,'clim',[-800 800]);
subplot_tight(1,3,3,margins), imshow(T2sub_z3), title('T2, BOLD, z3'); colorbar; colormap(redblue); set(gca,'clim',[-800 800]);
saveas(gcf,strcat('BOLD_T2map_sub_M3.pdf'));
