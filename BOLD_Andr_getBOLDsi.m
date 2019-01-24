function []=BOLD_Andr_getBOLDsi(t2map, base_name,animal_name,time_name)
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
T2wI_raw = zeros(97,97,tp_total,size(t2map,4)); %Slice)
T2wI_air = zeros(97,97,1,size(t2map,4)); %Slice)
T2wI_rel = zeros(97,97,tp_total,size(t2map,4)); %Slice)

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

%% BOLD signal intensity
%Calculate BOLD pixel-by-pixel
for z = 1:size(t2map,4) %Slice
    T2wI_air(:,:,1,z) = (T2wI_raw(:,:,1,z)+T2wI_raw(:,:,2,z)+T2wI_raw(:,:,3,z))/3;
    for tp = 1:tp_total
        T2wI_rel(:,:,tp,z) = (T2wI_raw(:,:,tp,z) - T2wI_air(:,:,1,z))./T2wI_air(:,:,1,z)*100;
    end
end

%Show BOLD map
figure;
b2 = imagesc(T2wI_rel(:,:,8,1));
pbaspect([1 1 1]);
colormap(jet)
caxis([-15 50]);
colorbar;
set(gca,'xtick',[],'ytick',[]);
title('BOLD(%) map');

%% Overlay with label map
%Thresholding
thr_min = -10;
thr_max = 10;
time = 8;
slice = 2;
thr = (T2wI_rel >= thr_min & T2wI_rel <= thr_max); 
T2wI_rel_thr = T2wI_rel .* thr;


%% Overlay (Overlay one image transparently onto another)
%threshold image as a mask
time = 8;
slice = 2;
imB = T2wI_raw(:,:,time,slice); % Background image 
imF_thr = thr(:,:,time,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF_thr,[1,2],[0 10000],'flag',0.7); 
colormap('flag'); % figure colormap still applies
savename = strcat('dSI_overlay_t',num2str(time),'_z',num2str(slice),'_',num2str(thr_min),'to',num2str(thr_max),'.tif');
saveas(gcf,savename);

%relative change with color window
rel_min = 1;
rel_max = 50;
imF = T2wI_rel(:,:,time,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF,[rel_min,rel_max],[0 10000],'jet',0.7); 
colormap('jet'); % figure colormap still applies
colorbar;
savename = strcat('dSI_overlay_t',num2str(time),'_z',num2str(slice),'_',num2str(thr_min),'to',num2str(thr_max),'.tif');
saveas(gcf,savename);

end