function []=BOLD_Andr_SNR(t2map, base_name,animal_name,time_name,b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/12/2018 by Jihun Kwon
% this code calculates dynamic BOLD signal intensity.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

crop_name = strcat(base_name,'_crop');
te_max = 15;

%% Parameterstp_total = 25;
te_max = 15;
te_target = 11;
cd(crop_name)

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

cd(base_name)
cd results_G05\

%Initialize parameters
T2wI_raw = zeros(size(t2map,1),size(t2map,2),size(t2map,3),size(t2map,4));
SNR = zeros(size(t2map,1),size(t2map,2),size(t2map,3),size(t2map,4));
SNR_air = zeros(size(t2map,1),size(t2map,2),1,size(t2map,4));
thr = zeros(size(t2map,1),size(t2map,2),size(t2map,3),size(t2map,4));

%Get every image with TE=39. TEs(10)
count = 0;
te_target = 11; %te_target decides which TE to use to calculate BOLD
for tp = 1:tp_total
    for z = 1:size(t2map,4) %Slice    
        for te = 1:te_max
            count = count + 1;
            if te == te_target
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(crop_name, sname);
                T2wI_raw(:,:,tp,z) = dicomread(fname);
            end
        end
    end
end

%% SNR
%Calculate SNR pixel-by-pixel
for z = 1:size(t2map,4) %Slice    
    for tp = 1:tp_total
        bg = mean(mean(T2wI_raw(1:15,1:15,tp,z))); %Background
        SNR(:,:,tp,z) = T2wI_raw(:,:,tp,z)/bg;
    end
end

%Show SNR map
figure;
imagesc(SNR(:,:,8,1));
pbaspect([1 1 1]);
colormap(jet)
caxis([0 10]);
colorbar;
set(gca,'xtick',[],'ytick',[]);
title('SNR map');

%% dSNR (delta SNR)
%Calculate dSNR pixel-by-pixel
for z = 1:size(t2map,4) %Slice    
    %First three images are air-breathing
    SNR_air(:,:,1,z) = (SNR(:,:,1,z)+SNR(:,:,2,z)+SNR(:,:,3,z))/3;
    for tp = 1:tp_total
        SNR_rel(:,:,tp,z) = (SNR(:,:,tp,z) - SNR_air(:,:,1,z))./SNR_air(:,:,1,z)*100;
    end
end

%Show dSNR map
figure;
imagesc(SNR_rel(:,:,8,1));
pbaspect([1 1 1]);
colormap('jet')
caxis([-15 50]);
colorbar;
set(gca,'xtick',[],'ytick',[]);
title('dSNR(%) map');

%% Overlay with label map
%Thresholding
thr_min = -100;
thr_max = 0;
time = 6;
slice = 3;
thr = (SNR_rel >= thr_min & SNR_rel <= thr_max); 

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

    %% Overlay one image transparently onto another 
    %imB = T2wI_raw(:,:,time,slice); % Background image 
    imB = Turbo(:,:,1,1); % Background image 
    imF = thr(:,:,time,slice); % Foreground image 
    [hf,hb] = imoverlay(imB,imF,[1,2],[0 10000],'flag',0.7); 
    colormap('flag'); % figure colormap still applies
    title(strcat('SNR Map (%), z',num2str(slice)));
    savename = strcat('dSNR_overlay_t',num2str(time),'_z',num2str(slice),'_',num2str(thr_min),'to',num2str(thr_max),'.tif');
    saveas(gcf,savename);
    
    %% Apply contouring to label map and then overlay
    imF_c = thr(:,:,time,slice) .* b(:,:,1,slice); % Foreground image 
    [hf,hb] = imoverlay(imB,imF_c,[1,2],[0 10000],'flag',0.7); 
    colormap('flag'); % figure colormap still applies
    title(strcat('SNR Map (%), z',num2str(slice)));
    savename = strcat('dSNR_roi_overlay_t',num2str(time),'_z',num2str(slice),'_',num2str(thr_min),'to',num2str(thr_max),'.tif');
    saveas(gcf,savename);
    
end
end