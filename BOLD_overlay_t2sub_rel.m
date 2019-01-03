%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 12/05/2018 by Jihun Kwon
% This code calculates subtraction and relative change of T2*
% pixel-by-pixel and overlay with raw T2w image.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

animal_name = 'M4';
time_name = 'PreRT'; %'PreRT'or 'PostRT' or 'Post1w' or 'Post2w'
ani_time_name = strcat(animal_name,'_',time_name);
cb_t2sub = [-15 15];
cb_t2rel = [-50 50];
tp_air = 3;
tp_pre = 3;
tp_post = 5;
te_max = 15;
z_max = 3;

if strcmp(time_name,'PreRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\';
    tp_total = 11;
elseif strcmp(time_name,'PostRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\';
    tp_total = 11;
elseif strcmp(time_name,'Post1w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181206_111438_Berbeco_Bi_Gd_1_27\';
    tp_total = 6;
    num_air_preCB = 5;
    num_total_CB = 16; %air(3)->oxy(3)->air(5)->CB(5)
elseif strcmp(time_name,'Post2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181217_124457_Berbeco_Bi_Gd_1_28\';
    tp_air = 2;
    tp_total = 5;
    tp_pre = 2;
    tp_post = 4;
end
tp_oxy = tp_total - tp_air;
crop_name = strcat(base_name,'\T2_dynamic_crop');

cd(base_name)
%cd T2_dynamic\results_G0.5
%cd T2_dynamic_tumor\results_G05
%cd T2_dynamic_brain\results_G1_Andr
cd T2_dynamic\results_tr_G05
load('t2map.mat')

T2_air_ave = zeros(size(t2map,1),size(t2map,2),1,size(t2map,4));
T2sub_air_ave = zeros(size(t2map));
T2rel_air_ave = zeros(size(t2map));

%Calculate average of air
for z = 1:3
    for i = 1:tp_air
        T2_air_ave(:,:,1,z) = T2_air_ave(:,:,1,z) + t2map(:,:,i,z);
    end
end
T2_air_ave = T2_air_ave / tp_air;

%% Get subtraction and relative change(%)
%Calculate T2*map subtraction
for z = 1:3
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
for z = 1:3
    figure(z+3);
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


%% Overlay
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


%Get every image with TE=39. TEs(10)
count = 0;
te_target = 8;
for tp = 1:tp_total
    for z = 1:z_max
        for te = 1:te_max
            count = count + 1;
            if te == te_target
                %raw image (used for overlay)
                cd(crop_name)
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(crop_name, sname);
                T2wI_raw(:,:,tp,z) = dicomread(fname);
            end
        end
    end
end

% %Thresholding subtraction
% thr_sub = (subtract >= sub_min & subtract <= sub_max); 
% subtr_thr = subtract .* thr_sub;
% 
% %Thresholding relative change
% thr_rel = (rel_inc >= rel_min & rel_inc <= rel_max); 
% rel_inc_thr = rel_inc .* thr_rel;

%% Overlay
sub_min = 1;
sub_max = 20;
rel_min = 1;
rel_max = 50;
% Overlay raw image with subtraction
cd(base_name)
time = 8;
slice = 2;
imB = T2wI_raw(:,:,time,slice); % Background image 
imF_sub = subtract(:,:,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF_sub,[sub_min,sub_max],[0 10000],'jet',0.7); 
colormap('jet'); % figure colormap still applies
colorbar;
savename = strcat('Overlay_subtract_t',num2str(time),'_z',num2str(slice),'_',num2str(sub_min),'to',num2str(sub_max),'.tif');
saveas(gcf,savename);

% Overlay raw image with relative increase
imF_rel = rel_inc(:,:,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF_rel,[rel_min,rel_max],[0 10000],'jet',0.7); 
colormap('jet'); % figure colormap still applies
colorbar;
savename = strcat('Overlay_relative_t',num2str(time),'_z',num2str(slice),'_',num2str(rel_min),'to',num2str(rel_max),'.tif');
saveas(gcf,savename);
