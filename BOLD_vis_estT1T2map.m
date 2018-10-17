function [] = BOLD_vis_estT1T2map(animal_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/04/2018 by Jihun Kwon
% Visualize "estimated" T1map and T2*map and subtract air and O2 breathing
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
margins = [.007 .007];
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\');
cb_t1map = [500 2800];
cb_t2map = [0 25];
cb_t1sub = [-200 200];
cb_t2sub = [-15 15];

%T1map, air
load('T1map_air_M3_para.mat');
T1_air_z1 = T1_est_air(:,:,1);
T1_air_z2 = T1_est_air(:,:,2);
T1_air_z3 = T1_est_air(:,:,3);

%T2*map, air
load('T2map_air_M3_para.mat');
T2_air_z1 = T2_est_air(:,:,1);
T2_air_z2 = T2_est_air(:,:,2);
T2_air_z3 = T2_est_air(:,:,3);

%T1map, O2
load('T1map_O2_M3_para.mat');
T1_O2_z1 = T1_est_O2(:,:,1);
T1_O2_z2 = T1_est_O2(:,:,2);
T1_O2_z3 = T1_est_O2(:,:,3);

%T2*map, O2
load('T2map_O2_M3_para.mat');
T2_O2_z1 = T2_est_O2(:,:,1);
T2_O2_z2 = T2_est_O2(:,:,2);
T2_O2_z3 = T2_est_O2(:,:,3);

%Subtract, T1map
T1sub_z1 = T1_air_z1 - T1_O2_z1;
T1sub_z2 = T1_air_z2 - T1_O2_z2;
T1sub_z3 = T1_air_z3 - T1_O2_z3;

%Subtract, T2*map
T2sub_z1 = T2_air_z1 - T2_O2_z1;
T2sub_z2 = T2_air_z2 - T2_O2_z2;
T2sub_z3 = T2_air_z3 - T2_O2_z3;

figure(1);
subplot_tight(1,3,1,margins), imshow(T1_air_z1), title('T1, air, z1'); colorbar; colormap jet; set(gca,'clim',cb_t1map);
subplot_tight(1,3,2,margins), imshow(T1_air_z2), title('T1, air, z2'); colorbar; colormap jet; set(gca,'clim',cb_t1map);
subplot_tight(1,3,3,margins), imshow(T1_air_z3), title('T1, air, z3'); colorbar; colormap jet; set(gca,'clim',cb_t1map);
saveas(gcf,strcat('BOLD_T1map_air_',animal_name,'_est.pdf'));

figure(2);
subplot_tight(1,3,1,margins), imshow(T2_air_z1), title('T2, air, z1'); colorbar; colormap jet; set(gca,'clim',cb_t2map);
subplot_tight(1,3,2,margins), imshow(T2_air_z2), title('T2, air, z2'); colorbar; colormap jet; set(gca,'clim',cb_t2map);
subplot_tight(1,3,3,margins), imshow(T2_air_z3), title('T2, air, z3'); colorbar; colormap jet; set(gca,'clim',cb_t2map);
saveas(gcf,strcat('BOLD_T2map_air_',animal_name,'_est.pdf'));

figure(3);
subplot_tight(1,3,1,margins), imshow(T1_O2_z1), title('T1, O2, z1'); colorbar; colormap jet; set(gca,'clim',cb_t1map);
subplot_tight(1,3,2,margins), imshow(T1_O2_z2), title('T1, O2, z2'); colorbar; colormap jet; set(gca,'clim',cb_t1map);
subplot_tight(1,3,3,margins), imshow(T1_O2_z3), title('T1, O2, z3'); colorbar; colormap jet; set(gca,'clim',cb_t1map);
saveas(gcf,strcat('BOLD_T1map_O2_',animal_name,'_est.pdf'));

figure(4);
subplot_tight(1,3,1,margins), imshow(T2_O2_z1), title('T2, O2, z1'); colorbar; colormap jet; set(gca,'clim',cb_t2map);
subplot_tight(1,3,2,margins), imshow(T2_O2_z2), title('T2, O2, z2'); colorbar; colormap jet; set(gca,'clim',cb_t2map);
subplot_tight(1,3,3,margins), imshow(T2_O2_z3), title('T2, O2, z3'); colorbar; colormap jet; set(gca,'clim',cb_t2map);
saveas(gcf,strcat('BOLD_T2map_O2_',animal_name,'_est.pdf'));

figure(5);
subplot_tight(1,3,1,margins), imshow(T1sub_z1), title('T1, BOLD, z1'); colorbar; colormap(redblue); set(gca,'clim',cb_t1sub);
subplot_tight(1,3,2,margins), imshow(T1sub_z2), title('T1, BOLD, z2'); colorbar; colormap(redblue); set(gca,'clim',cb_t1sub);
subplot_tight(1,3,3,margins), imshow(T1sub_z3), title('T1, BOLD, z3'); colorbar; colormap(redblue); set(gca,'clim',cb_t1sub);
saveas(gcf,strcat('BOLD_T1map_sub_',animal_name,'_est.pdf'));

figure(6);
subplot_tight(1,3,1,margins), imshow(T2sub_z1), title('T2, BOLD, z1'); colorbar; colormap(redblue); set(gca,'clim',cb_t2sub);
subplot_tight(1,3,2,margins), imshow(T2sub_z2), title('T2, BOLD, z2'); colorbar; colormap(redblue); set(gca,'clim',cb_t2sub);
subplot_tight(1,3,3,margins), imshow(T2sub_z3), title('T2, BOLD, z3'); colorbar; colormap(redblue); set(gca,'clim',cb_t2sub);
saveas(gcf,strcat('BOLD_T2map_sub_',animal_name,'_est.pdf'));

end

