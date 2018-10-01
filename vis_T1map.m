%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/01/2018 by Jihun Kwon
% For visualization
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear;
clc;
figure(1); clf('reset'); set(gca,'Position',[440   378   560   420]);
figure(2); clf('reset'); set(gca,'Position',[440   378   560   420]);
load('C:\Users\jihun\Documents\MATLAB\BioDistribution\JihunAnalysis\Input\T1wI\T1_est_timepoints.mat')
cb = [0 2000];
cb_rel = [0 30];
%% Whole Volume
margins = [.007 .007];
figure(1); hold on;
subplot_tight(1,5,1,margins), imshow(T1_est_pre(:,:,1)), title('Pre')
colorbar; colormap jet; set(gca,'clim',cb);
subplot_tight(1,5,2,margins), imshow(T1_est_15m(:,:,1)), title('15 min')
colorbar; colormap jet; set(gca,'clim',cb);
subplot_tight(1,5,3,margins), imshow(T1_est_1h(:,:,1)), title('1.5 hour')
colorbar; colormap jet; set(gca,'clim',cb);
subplot_tight(1,5,4,margins), imshow(T1_est_5h(:,:,1)), title('5 hour')
colorbar; colormap jet; set(gca,'clim',cb);
subplot_tight(1,5,5,margins), imshow(T1_est_24h(:,:,2)), title('24 hour')
colorbar; colormap jet; set(gca,'clim',cb);

saveas(gcf,strcat('T1wI_unfiltered_WholeVolume.pdf'));

%Flip color jet
figure(2); hold on;
subplot_tight(1,5,1,margins), imshow(T1_est_pre(:,:,1)), title('Pre')
colorbar; colormap(flipud(jet)); set(gca,'clim',cb);
subplot_tight(1,5,2,margins), imshow(T1_est_15m(:,:,1)), title('15 min')
colorbar; colormap(flipud(jet)); set(gca,'clim',cb);
subplot_tight(1,5,3,margins), imshow(T1_est_1h(:,:,1)), title('1.5 hour')
colorbar; colormap(flipud(jet)); set(gca,'clim',cb);
subplot_tight(1,5,4,margins), imshow(T1_est_5h(:,:,1)), title('5 hour')
colorbar; colormap(flipud(jet)); set(gca,'clim',cb);
subplot_tight(1,5,5,margins), imshow(T1_est_24h(:,:,2)), title('24 hour')
colorbar; colormap(flipud(jet)); set(gca,'clim',cb);
%% Relative change
%Initialize
%{
rel_pre = zeros(size(T1_est_pre,1),size(T1_est_pre,2));
rel_15m = zeros(size(T1_est_pre,1),size(T1_est_pre,2));
rel_1h = zeros(size(T1_est_pre,1),size(T1_est_pre,2));
rel_5h = zeros(size(T1_est_pre,1),size(T1_est_pre,2));
rel_24h = zeros(size(T1_est_pre,1),size(T1_est_pre,2));

rel_pre = (T1_est_pre(:,:,1)-T1_est_pre(:,:,1))./T1_est_pre(:,:,1)*100;
rel_15m = (T1_est_pre(:,:,1)-T1_est_15m(:,:,1))./T1_est_pre(:,:,1)*100;
rel_1h = (T1_est_pre(:,:,1)-T1_est_1h(:,:,1))./T1_est_pre(:,:,1)*100;
rel_5h = (T1_est_pre(:,:,1)-T1_est_5h(:,:,1))./T1_est_pre(:,:,1)*100;
rel_24h = (T1_est_pre(:,:,1)-T1_est_24h(:,:,2))./T1_est_pre(:,:,1)*100;

rel_pre(isnan(rel_pre))=0; rel_pre(~isfinite(rel_pre))=0;
rel_15m(isnan(rel_15m))=0; rel_15m(~isfinite(rel_15m))=0;
rel_1h(isnan(rel_1h))=0;   rel_1h(~isfinite(rel_1h))=0;
rel_5h(isnan(rel_5h))=0;   rel_5h(~isfinite(rel_5h))=0;
rel_24h(isnan(rel_24h))=0; rel_24h(~isfinite(rel_24h))=0;

figure(3); hold on;
subplot_tight(1,5,1,margins), imshow(rel_pre(:,:)), title('Rel Change, Pre(%)')
colorbar; colormap jet; set(gca,'clim',cb_rel);
subplot_tight(1,5,2,margins), imshow(rel_15m(:,:)), title('Rel Change, 15 min(%)')
colorbar; colormap jet; set(gca,'clim',cb_rel);
subplot_tight(1,5,3,margins), imshow(rel_1h(:,:)), title('Rel Change, 1.5 hour(%)')
colorbar; colormap jet; set(gca,'clim',cb_rel);
subplot_tight(1,5,4,margins), imshow(rel_5h(:,:)), title('Rel Change, 5 hour(%)')
colorbar; colormap jet; set(gca,'clim',cb_rel);
subplot_tight(1,5,5,margins), imshow(rel_24h(:,:)), title('Rel Change, 24 hour(%)')
colorbar; colormap jet; set(gca,'clim',cb_rel);
%}

%% Zoom in
%{
figure(2); hold on;
xrange = 180:330;
subplot_tight(1,5,1,margins), imshow(X0(xrange,:),map0), title('Pre')
colormap jet; set(gca,'clim',cb);
subplot_tight(1,5,2,margins), imshow(X15m(xrange,:),map15min), title('15 min')
colormap jet; set(gca,'clim',cb);
subplot_tight(1,5,3,margins), imshow(X1h(210:360,:),map1h), title('1.5 hour')
colormap jet; set(gca,'clim',cb);
subplot_tight(1,5,4,margins), imshow(X5h(190:340,:),map05h), title('5 hour')
colormap jet; set(gca,'clim',cb);
subplot_tight(1,5,5,margins), imshow(X24h(200:350,:),map24h), title('24 hour')
colormap jet; set(gca,'clim',cb);

%colormap jet;
%set(gca,'clim',[0 17000]);
%colorbar;
% Save T1map as pdf
saveas(gcf,strcat('T1wI_unfiltered_Zoomin.pdf'));
%}