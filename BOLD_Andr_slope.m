function []=BOLD_Andr_slope(t2map, base_name,animal_name,time_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 12/05/2018 by Jihun Kwon
% This code calculate the slope of dynamic T2* signal between two
% timepoints.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

crop_name = strcat(base_name,'_crop');

%set two timepoints
tp_pre = 3;
tp_post = 5;
te_max = 15;

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
    te_target = 11;
elseif (strcmp(time_name,'Andrea_B') || strcmp(time_name,'Andrea_C') || strcmp(time_name,'Andrea_D') || ... 
        strcmp(time_name,'Andrea_E') || strcmp(time_name,'Andrea_F') ||strcmp(time_name,'Andrea_G'))
    tp_air = 3;
    tp_total = 25;
end

T2wI_raw = zeros(size(t2map,1),size(t2map,2),size(t2map,3),size(t2map,4));
slope = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
rel_inc = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
slope_thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
rel_inc_thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));

cd(base_name)
cd results\

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


%% Overlay with map
cd(base_name)
cd results
%Manualy change these parameters
rel_min = 1;
rel_max = 50;
thr_min = -10;
thr_max = 10;
time = 6;
slice = 2;

% Overlay raw image with relative increase map
imB = T2wI_raw(:,:,time,slice); % Background image 
imF_rel = rel_inc(:,:,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF_rel,[rel_min,rel_max],[0 10000],'jet',0.7); 
colormap('jet'); % figure colormap still applies
colorbar;
title('Relative Increase map (%)');
savename = strcat('Overlay_relative_t',num2str(time),'_z',num2str(slice),'_',num2str(rel_min),'to',num2str(rel_max),'.tif');
saveas(gcf,savename);

%% Overlay with label map
%Thresholding
thr = (thr_min <= rel_inc & rel_inc <= thr_max);  
rel_inc_thr = rel_inc .* thr; %not use but keep just in case

% Overlay one image transparently onto another 
[hf,hb] = imoverlay(imB,thr(:,:,slice),[1,2],[0 10000],'flag',0.7); 
colormap('flag'); % figure colormap still applies
title('Relative Increase map (%)');
savename = strcat('Slope_overlay_t',num2str(time),'_z',num2str(slice),'_',num2str(thr_min),'to',num2str(thr_max),'.tif');
saveas(gcf,savename);

end