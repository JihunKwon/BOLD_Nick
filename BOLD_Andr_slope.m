function []=BOLD_Andr_slope(t2map, base_name,animal_name,time_name,b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 12/05/2018 by Jihun Kwon
% This code calculate the slope of dynamic T2* signal between two
% timepoints.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

crop_name = strcat(base_name,'_crop');

%Set parameters depending on the data type
if (strcmp(time_name,'Chemo_2w'))
    tp_air = 3;
    tp_total = 25;
elseif (strcmp(time_name,'Control_1w') || strcmp(time_name,'Control_2w') || strcmp(time_name,'Control_3w') || strcmp(time_name,'NP_RT_21d'))
    tp_air = 10;
    tp_total = 20;
end

%set two timepoints which are used for calculating the slope.
tp_pre = tp_air-1;
tp_post = tp_air+1;
te_max = 15;

T2wI_raw = zeros(size(t2map,1),size(t2map,2),size(t2map,3),size(t2map,4));
slope = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
rel_inc = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
slope_thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
rel_inc_thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));

cd(base_name)
cd results_G05\

for z = 1:size(t2map,4) %Slice    
    %Get T2* value of each slice at two timepoints
    img_pre = t2map(:,:,tp_pre,z);
    img_post = t2map(:,:,tp_post,z);
    img_pre(isnan(img_pre))=0;
    img_post(isnan(img_post))=0;
    
    %Calculate Slope
    slope(:,:,z) = (img_post - img_pre)/(tp_post - tp_pre);
    
    %Show Slope map
    %slope = int(slope);
    figure;
    %slope(slope<0) = NaN;
    b1 = imagesc(slope(:,:,z));
    %set(b1,'AlphaData',~isnan(slope))
    cmap = jet(round(max(max(slope(:,:,z)))));
    pbaspect([1 1 1]);
    %colormap(flipud(parula))
    colormap(jet)
    caxis([-2 2]);
    colorbar;
    set(gca,'xtick',[],'ytick',[]);
    title('Slope map');

    %Calculate Relative Increase(%). In this case, baseline has to be the
    %average of timepoint 1 to 3.
    img_base = (t2map(:,:,1,z)+t2map(:,:,2,z)+t2map(:,:,3,z))/3;
    img_base(isnan(img_base))=0;
    rel_inc(:,:,z) = (img_post - img_base)./img_base * 100;
    
    %Show Slope map
    %slope = int(slope);
    figure;
    b2 = imagesc(rel_inc(:,:,z));
    pbaspect([1 1 1]);
    colormap(jet)
    caxis([-15 15]);
    colorbar;
    set(gca,'xtick',[],'ytick',[]);
    title('Relative Increase map');
end

%% Use raw T2*w image for background
%{
%Get every image with TE=39. TEs(10)
count = 0;
te_target = 11; %te_target decides which TE to use to calculate BOLD
for tp = 1:tp_total
    for z = 1:size(t2map,4) %Slice
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
%}

%% Overlay with map
cd(base_name)
cd results_G05\
%Manualy change these parameters
rel_min = 0.1;
rel_max = 50;
thr_min = -100;
thr_max = 0;
time = 6;
%slice = 2;


%% Use Turbo for background
for slice = 1:size(t2map,4) %Slice 
    Turboname = strcat(base_name,'_Turbo_crop'); %When we contour on turbo image, we use this variable later.

    if (strcmp(time_name,'Control_1w') || strcmp(time_name,'Control_2w') || strcmp(time_name,'Control_3w'))
        %Slice 1,2,3,4,5 in T2*wI corresponds to file 10,11,12,13,14 in Turbo.
        file_target = 10 + (slice-1);%which TE to use for raw image contouring.
    elseif strcmp(time_name,'NP_RT_21d')
        %Slice 1,2,3,4,5 in T2*wI corresponds to file 7,8,9,10,11 in Turbo.
        file_target = 7 + (slice-1);%which TE to use for raw image contouring.
    end

    sname = sprintf('MRIc%02d.dcm',file_target);
    fname = fullfile(Turboname, sname);
    Turbo(:,:,1,1) = dicomread(fname);

    %% Overlay raw image with relative increase map
    %imB = T2wI_raw(:,:,time,slice); % Background image 
    imB = Turbo(:,:,1,1); % Background image 
    imF_rel = rel_inc(:,:,slice); % Foreground image 
    [hf,hb] = imoverlay(imB,imF_rel,[rel_min,rel_max],[0 10000],'jet',0.7); 
    colormap('jet'); % figure colormap still applies
    colorbar;
    title(strcat('Relative Increase Map (%), z',num2str(slice)));
    savename = strcat('Overlay_relative_t',num2str(time),'_z',num2str(slice),'_',num2str(rel_min),'to',num2str(rel_max),'.tif');
    saveas(gcf,savename);

    %% Overlay with label map
    %Thresholding
    thr = (thr_min <= rel_inc & rel_inc <= thr_max);  
    rel_inc_thr = rel_inc .* thr; %not use but keep just in case

    % Overlay one image transparently onto another 
    [hf,hb] = imoverlay(imB,thr(:,:,slice),[1,2],[0 10000],'flag',0.7); 
    colormap('flag'); % figure colormap still applies
    title(strcat('Relative Increase Map (%), z',num2str(slice)));
    savename = strcat('Overlay_label_t',num2str(time),'_z',num2str(slice),'_',num2str(thr_min),'to',num2str(thr_max),'.tif');
    saveas(gcf,savename);

    %% Apply Contouring to Relative increase map and then overlay
    imB = Turbo(:,:,1,1); % Background image 
    imF_rel_c = rel_inc(:,:,slice) .* b(:,:,1,slice); % Assuming that the tumor is the first ROI among 2or3 ROIs
    [hf,hb] = imoverlay(imB,imF_rel_c,[rel_min,rel_max],[0 10000],'jet',0.7); 
    colormap('jet'); % figure colormap still applies
    colorbar;
    title(strcat('Relative Increase Map (%), z',num2str(slice)));
    savename = strcat('Overlay_roi_relative_t',num2str(time),'_z',num2str(slice),'_',num2str(rel_min),'to',num2str(rel_max),'.tif');
    saveas(gcf,savename);

    %% Apply Contouring to label map and then overlay
    thr_c = thr .* b(:,:,1,slice); %not use but keep just in case

    % Overlay one image transparently onto another 
    [hf,hb] = imoverlay(imB,thr_c(:,:,slice),[1,2],[0 10000],'flag',0.7); 
    colormap('flag'); % figure colormap still applies
    title(strcat('Relative Increase Map (%), z',num2str(slice)));
    savename = strcat('Overlay_label_roi_overlay_t',num2str(time),'_z',num2str(slice),'_',num2str(thr_min),'to',num2str(thr_max),'.tif');
    saveas(gcf,savename);
end
end