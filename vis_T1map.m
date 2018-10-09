%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/01/2018 by Jihun Kwon
% For visualization. 
% Use "T1map_F()_para.mat" estimated by "ReadInDicoms_FitT1Data_ForBiodist.m"
% Finally store parameters to "T1_dynamic_M().mat". 
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear;
clc;
%figure(1); clf('reset'); set(gca,'Position',[440   378   560   420]);
figure(2); clf('reset'); set(gca,'Position',[440   378   560   420]);
%figure(3); clf('reset'); set(gca,'Position',[440   378   560   420]);
%figure(4); clf('reset'); set(gca,'Position',[440   378   560   420]);

load('C:\Users\jihun\Documents\MATLAB\BioDistribution\JihunAnalysis\Input\T1wI\M3\T1map_F12_para.mat')
T1_est_pre = T1_est;
% load('C:\Users\jihun\Documents\MATLAB\BioDistribution\JihunAnalysis\Input\T1wI\T1map_F2b_para.mat')
% T1_est_preb = T1_est;
load('C:\Users\jihun\Documents\MATLAB\BioDistribution\JihunAnalysis\Input\T1wI\M3\T1map_F13_para.mat')
T1_est_15m = T1_est;
load('C:\Users\jihun\Documents\MATLAB\BioDistribution\JihunAnalysis\Input\T1wI\M3\T1map_F14_para.mat')
T1_est_1h = T1_est;
load('C:\Users\jihun\Documents\MATLAB\BioDistribution\JihunAnalysis\Input\T1wI\M3\T1map_F15_para.mat')
T1_est_5h = T1_est;
load('C:\Users\jihun\Documents\MATLAB\BioDistribution\JihunAnalysis\Input\T1wI\M3\T1map_F16_para.mat')
T1_est_24h = T1_est;

margins = [.007 .007];
cb_range = [0 2000];
cb_inv_range = [1400 2600]; %tumor window:[1400 2600];
cb_rel = [0 50];
flip_cb = flipud(jet);
flip_cb(1,:)=0;

%Change target slice accordingly.
z_pre = 3;
z_15m = 2;
z_1h  = 2;
z_5h  = 3;
z_24h = 2;

%% Whole Volume
%{
figure(1); hold on;
subplot_tight(1,5,1,margins), imshow(T1_est_pre(:,:,z_pre)), title('Pre')
colorbar; colormap jet; set(gca,'clim',cb_range);
subplot_tight(1,5,2,margins), imshow(T1_est_15m(:,:,z_15m)), title('15 min')
colorbar; colormap jet; set(gca,'clim',cb_range);
subplot_tight(1,5,3,margins), imshow(T1_est_1h(:,:,z_1h)), title('1.5 hour')
colorbar; colormap jet; set(gca,'clim',cb_range);
subplot_tight(1,5,4,margins), imshow(T1_est_5h(:,:,z_5h)), title('5 hour')
colorbar; colormap jet; set(gca,'clim',cb_range);
subplot_tight(1,5,5,margins), imshow(T1_est_24h(:,:,z_24h)), title('24 hour')
colorbar; colormap jet; set(gca,'clim',cb_range);

saveas(gcf,strcat('T1wI_M3_WholeVolume_jet.pdf'));
%}
%Flip color jet
figure(2); hold on;
subplot_tight(1,5,1,margins), imshow(T1_est_pre(:,:,z_pre)), title('Pre')
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(1,5,2,margins), imshow(T1_est_15m(:,:,z_15m)), title('15 min')
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(1,5,3,margins), imshow(T1_est_1h(:,:,z_1h)), title('1.5 hour')
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(1,5,4,margins), imshow(T1_est_5h(:,:,z_5h)), title('5 hour')
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(1,5,5,margins), imshow(T1_est_24h(:,:,z_24h)), title('24 hour')
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);

saveas(gcf,strcat('T1wI_M3_WholeVolume_flipjet.pdf'));
%{
%Show all slices
figure(3); axis off; hold on;
subplot_tight(3,5,1), imshow(T1_est_pre(:,:,1)); title('Z1 Pre');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,2), imshow(T1_est_15m(:,:,1)); title('Z1 15min');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,3), imshow(T1_est_1h(:,:,1)); title('Z1 1.5hour');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,4), imshow(T1_est_5h(:,:,1)); title('Z1 5hour');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,5), imshow(T1_est_24h(:,:,1)); title('Z1 24hour');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,6), imshow(T1_est_pre(:,:,2)); title('Z2 Pre');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,7), imshow(T1_est_15m(:,:,2)); title('Z2 15min');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,8), imshow(T1_est_1h(:,:,2)); title('Z2 1.5hour');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,9), imshow(T1_est_5h(:,:,2)); title('Z2 5hour');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,10), imshow(T1_est_24h(:,:,2)); title('Z2 24hour');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,11), imshow(T1_est_pre(:,:,3)); title('Z3 Pre');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,12), imshow(T1_est_15m(:,:,3)); title('Z3 15min');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,13), imshow(T1_est_1h(:,:,3)); title('Z3 1.5hour');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,14), imshow(T1_est_5h(:,:,3)); title('Z3 5hour');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
subplot_tight(3,5,15), imshow(T1_est_24h(:,:,3)); title('Z3 24hour');
colorbar; colormap(flip_cb); set(gca,'clim',cb_inv_range);
saveas(gcf,strcat('T1wI_M3_WholeVolume_flipjet_allfig.pdf'));

%% Relative change
%Initialize
rel_pre = zeros(size(T1_est_pre,1),size(T1_est_pre,2));
rel_15m = zeros(size(T1_est_pre,1),size(T1_est_pre,2));
rel_1h = zeros(size(T1_est_pre,1),size(T1_est_pre,2));
rel_5h = zeros(size(T1_est_pre,1),size(T1_est_pre,2));
rel_24h = zeros(size(T1_est_pre,1),size(T1_est_pre,2));

rel_pre = (T1_est_pre(:,:,1)-T1_est_pre(:,:,z_pre))./T1_est_pre(:,:,1)*100;
rel_15m = (T1_est_pre(:,:,1)-T1_est_15m(:,:,z_15m))./T1_est_pre(:,:,1)*100;
rel_1h = (T1_est_pre(:,:,1)-T1_est_1h(:,:,z_1h))./T1_est_pre(:,:,1)*100;
rel_5h = (T1_est_pre(:,:,1)-T1_est_5h(:,:,z_5h))./T1_est_pre(:,:,1)*100;
rel_24h = (T1_est_pre(:,:,1)-T1_est_24h(:,:,z_24h))./T1_est_pre(:,:,1)*100;

rel_pre(isnan(rel_pre))=0; rel_pre(~isfinite(rel_pre))=0;
rel_15m(isnan(rel_15m))=0; rel_15m(~isfinite(rel_15m))=0;
rel_1h(isnan(rel_1h))=0;   rel_1h(~isfinite(rel_1h))=0;
rel_5h(isnan(rel_5h))=0;   rel_5h(~isfinite(rel_5h))=0;
rel_24h(isnan(rel_24h))=0; rel_24h(~isfinite(rel_24h))=0;

figure(4); hold on;
subplot_tight(1,5,1,margins), imshow(rel_pre(:,:)), title('Pre(%)')
colorbar; colormap jet; set(gca,'clim',cb_rel);
subplot_tight(1,5,2,margins), imshow(rel_15m(:,:)), title('15 min(%)')
colorbar; colormap jet; set(gca,'clim',cb_rel);
subplot_tight(1,5,3,margins), imshow(rel_1h(:,:)), title('1.5 hour(%)')
colorbar; colormap jet; set(gca,'clim',cb_rel);
subplot_tight(1,5,4,margins), imshow(rel_5h(:,:)), title('5 hour(%)')
colorbar; colormap jet; set(gca,'clim',cb_rel);
subplot_tight(1,5,5,margins), imshow(rel_24h(:,:)), title('24 hour(%)')
colorbar; colormap jet; set(gca,'clim',cb_rel);
saveas(gcf,strcat('T1wI_M3_WholeVolume_rel_jet.pdf'));
%}
%% Write Parameters
%{
T1_dynamic = zeros(size(T1_est_pre,1),size(T1_est_pre,2),5);
T1_pre = T1_est_pre(:,:,z_pre);
T1_15m = T1_est_15m(:,:,z_15m);
T1_1h = T1_est_1h(:,:,z_1h);
T1_5h = T1_est_5h(:,:,z_5h);
T1_24h = T1_est_24h(:,:,z_24h);

save('T1_dynamic_M3.mat','T1_pre','T1_15m','T1_1h','T1_5h','T1_24h');
%}
%% Zoom in
%{
figure(2); hold on;
xrange = 180:330;
subplot_tight(1,5,1,margins), imshow(X0(xrange,:),map0), title('Pre')
colormap jet; set(gca,'clim',cb_range);
subplot_tight(1,5,2,margins), imshow(X15m(xrange,:),map15min), title('15 min')
colormap jet; set(gca,'clim',cb_range);
subplot_tight(1,5,3,margins), imshow(X1h(210:360,:),map1h), title('1.5 hour')
colormap jet; set(gca,'clim',cb_range);
subplot_tight(1,5,4,margins), imshow(X5h(190:340,:),map05h), title('5 hour')
colormap jet; set(gca,'clim',cb_range);
subplot_tight(1,5,5,margins), imshow(X24h(200:350,:),map24h), title('24 hour')
colormap jet; set(gca,'clim',cb_range);

%colormap jet;
%set(gca,'clim',[0 17000]);
%colorbar;
% Save T1map as pdf
saveas(gcf,strcat('T1wI_unfiltered_Zoomin.pdf'));
%}