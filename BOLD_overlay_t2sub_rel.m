function []=BOLD_overlay_t2sub_rel(t2map, base_name,animal_name,time_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.2
% modified on 1/04/2019 by Jihun Kwon
% This code calculates subtraction and relative change of T2*
% pixel-by-pixel and overlay with raw T2w image.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

crop_name = strcat(base_name,'_crop');

%Set these parameters manually
tp_pre = 3;
tp_post = 5;
te_max = 15;
cb_t2sub = [-15 15];
cb_t2rel = [-50 50];

%Set parameters depending on the data type
if strcmp(time_name,'PreRT') || strcmp(time_name,'PostRT')
    tp_total = 11;
elseif strcmp(time_name,'Post1w')
    tp_total = 6;
    num_air_preCB = 5;
    num_total_CB = 16; %air(3) -> oxy(3) -> air(5) -> CB(5)
elseif strcmp(time_name,'Post2w')
    tp_air = 2;
    tp_total = 5;
    tp_pre = 2;
    tp_post = 4;
elseif (strcmp(time_name,'Andrea_B') || strcmp(time_name,'Andrea_C') || strcmp(time_name,'Andrea_D') || ... 
        strcmp(time_name,'Andrea_E') || strcmp(time_name,'Andrea_F') ||strcmp(time_name,'Andrea_G'))
    tp_air = 3;
    tp_total = 25;
end

cd(base_name)
cd results
%load('t2map.mat')

T2_air_ave = zeros(size(t2map,1),size(t2map,2),1,size(t2map,4));
T2sub_air_ave = zeros(size(t2map));
T2rel_air_ave = zeros(size(t2map));

%Calculate average of air
for z = 1:size(t2map,4)
    for i = 1:tp_air
        T2_air_ave(:,:,1,z) = T2_air_ave(:,:,1,z) + t2map(:,:,i,z);
    end
end
T2_air_ave = T2_air_ave / tp_air;

%% Get subtraction and relative change(%)
%Calculate T2*map subtraction
for z = 1:size(t2map,4)
    figure(z);
    set(gcf,'Position',[100 100 1300 500], 'Color', 'w');
    z_s = num2str(z);
    
    for i = 1:size(t2map,3)
        T2sub_air_ave = t2map - T2_air_ave;
        
        if i<=6
            subaxis(1,6,i,'SpacingVert',0.01,'SpacingHoriz',0.005);
            imagesc(T2sub_air_ave(:,:,i,z)), 
            title(strcat(num2str(i),'-air, z',z_s)); 
            %colorbar;
            colormap(redblue); 
            set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); 
            axis off;
        end
    end
end


%Calculate T2*map relative change
for z = 1:size(t2map,4)
    figure(z+size(t2map,4));
    set(gcf,'Position',[100 100 1300 500], 'Color', 'w');
    z_s = num2str(z);
    
    for i = 1:size(t2map,3)
        T2rel_air_ave(:,:,i,z) = 100 * T2sub_air_ave(:,:,i,z) ./ T2_air_ave(:,:,1,z);
        
        if i<=6
            subaxis(1,6,i,'SpacingVert',0.01,'SpacingHoriz',0.005);
            imagesc(T2rel_air_ave(:,:,i,z)), 
            title(strcat('rel, ', num2str(i),', z',z_s)); 
            %colorbar;
            colormap(redblue); 
            set(gca,'clim',cb_t2rel,'dataAspectRatio',[1 1 1]); 
            axis off;
        end
    end
end


%% Mapping (Subtraction and Relative Increase)
T2wI_raw = zeros(size(t2map,1),size(t2map,2),tp_total,size(t2map,4));
subtract = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
rel_inc = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
subtr_thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
rel_inc_thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
thr_sub = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
thr_rel = zeros(size(t2map,1),size(t2map,2),size(t2map,4));

for z = 1:size(t2map,4) %Slice    
    %Get T2* value of each slice at two timepoints
    img_pre = t2map(:,:,tp_pre,z);
    img_post = t2map(:,:,tp_post,z);
    img_pre(isnan(img_pre))=0;
    img_post(isnan(img_post))=0;
    
    %Calculate subtraction
    subtract(:,:,z) = (img_post - img_pre);
    
    %Show Subtract map
    figure;
    b1 = imagesc(subtract(:,:,z));
    cmap = jet(round(max(max(subtract(:,:,z)))));
    pbaspect([1 1 1]);
    colormap(redblue)
    caxis(cb_t2sub);
    colorbar;
    set(gca,'xtick',[],'ytick',[]);
    title('Oxygen(5) - Air(3) (ms)');

    %Calculate Relative Increase(%).
    img_air = squeeze(T2_air_ave);
    img_air(isnan(img_air))=0;
    rel_inc(:,:,z) = (img_post - img_air(:,:,z))./img_air(:,:,z) * 100;
    
    %Show rel_inc map
    figure;
    b2 = imagesc(rel_inc(:,:,z));
    pbaspect([1 1 1]);
    colormap(redblue)
    caxis(cb_t2rel);
    colorbar;
    set(gca,'xtick',[],'ytick',[]);
    title('Relative Increase map (%)');
end


%Get every image with specific TE
cd(crop_name)
count = 0;
te_target = 11; %te_target decides which TE to use to calculate BOLD
for tp = 1:tp_total
    for z = 1:size(t2map,4)
        for te = 1:te_max
            count = count + 1;
            if te == te_target
                %raw image (used for overlay)
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(crop_name, sname);
                T2wI_raw(:,:,tp,z) = dicomread(fname);
            end
        end
    end
end


%% Overlay with map
cd(base_name)
cd results
%Manualy change these parameters
sub_min = 1; %minimum of color range in overlaying map
sub_max = 20; %max of color range in overlaying map
rel_min = 1;
rel_max = 50;
thr_min = -10;
thr_max = 10;
time = 6;
slice = 2;

% Overlay raw image with subtraction map
imB = T2wI_raw(:,:,time,slice); % Background image 
imF_sub = subtract(:,:,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF_sub,[sub_min,sub_max],[0 10000],'jet',0.7); 
colormap('jet'); % figure colormap still applies
colorbar;
title('Subtraction map (%)');
savename = strcat('Overlay_subtract_t',num2str(time),'_z',num2str(slice),'_',num2str(sub_min),'to',num2str(sub_max),'.tif');
saveas(gcf,savename);

% Overlay raw image with relative increase map
imF_rel = rel_inc(:,:,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF_rel,[rel_min,rel_max],[0 10000],'jet',0.7); 
colormap('jet'); % figure colormap still applies
colorbar;
title('Relative Increase map (%)');
savename = strcat('Overlay_relative_t',num2str(time),'_z',num2str(slice),'_',num2str(rel_min),'to',num2str(rel_max),'.tif');
saveas(gcf,savename);

%% Overlay with label map
%Thresholding relative change
thr_rel = (thr_min <= rel_inc & rel_inc <= thr_max);

% Overlay raw image with relative increase map
[hf,hb] = imoverlay(imB,thr_rel(:,:,slice),[1,2],[0 10000],'flag',0.7); 
colormap('flag'); % figure colormap still applies
title('Relative Increase map (%)');
savename = strcat('Overlay_relative_label_t',num2str(time),'_z',num2str(slice),'_',num2str(rel_min),'to',num2str(rel_max),'.tif');
saveas(gcf,savename);