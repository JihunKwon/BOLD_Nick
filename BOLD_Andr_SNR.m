function []=BOLD_Andr_SNR(t2map, base_name,animal_name,time_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/12/2018 by Jihun Kwon
% this code calculates dynamic BOLD signal intensity.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

crop_name = strcat(base_name,'_crop');

%set two timepoints
tp_pre = 3;
tp_post = 5;
te_max = 15;

%% Parameterstp_total = 25;
te_max = 15;
te_target = 11;
cd(crop_name)

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

cd(base_name)
cd results\

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
thr_min = -10;
thr_max = 10;
time = 8;
slice = 2;
thr = (SNR_rel >= thr_min & SNR_rel <= thr_max); 

% Overlay one image transparently onto another 
imB = T2wI_raw(:,:,time,slice); % Background image 
imF = thr(:,:,time,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF,[1,2],[0 10000],'flag',0.7); 
colormap('flag'); % figure colormap still applies
savename = strcat('dSNR_overlay_t',num2str(time),'_z',num2str(slice),'_',num2str(thr_min),'to',num2str(thr_max),'.tif');
saveas(gcf,savename);

end