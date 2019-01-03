%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/12/2018 by Jihun Kwon
% this code calculates dynamic BOLD signal intensity.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters
raw_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018_crop';
gauss_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018_crop_G05';
tp_max = 25; 
z_max = 5; 
te_max = 15;
te_target = 11;
cd(gauss_name)

%15(TEs)*5(slice)*25(tp)
T2wI_raw = zeros(97,97,tp_max,z_max);
T2wI_g = zeros(97,97,tp_max,z_max);
T2wI_air = zeros(97,97,1,z_max);
T2wI_rel = zeros(97,97,tp_max,z_max);

%Get every image with TE=39. TEs(10)
count = 0;
for tp = 1:tp_max
    for z = 1:z_max
        for te = 1:te_max
            count = count + 1;
            if te == te_target
                %raw image (used for overlay)
                cd(raw_name)
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(raw_name, sname);
                T2wI_raw(:,:,tp,z) = dicomread(fname);
                %info = dicominfo(fname); %Extract dicom_info
                %info.EchoTime
                
                %smoothed image
                cd(gauss_name)
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(gauss_name, sname);
                T2wI_g(:,:,tp,z) = dicomread(fname);
                %info = dicominfo(fname); %Extract dicom_info
                %info.EchoTime
            end
        end
    end
end

%Calculate BOLD pixel-by-pixel
for z = 1:z_max
    T2wI_air(:,:,1,z) = (T2wI_g(:,:,1,z)+T2wI_g(:,:,2,z)+T2wI_g(:,:,3,z)+T2wI_g(:,:,4,z)+T2wI_g(:,:,5,z))/5;
    %if tp>6
    for tp = 1:tp_max
        T2wI_rel(:,:,tp,z) = (T2wI_g(:,:,tp,z) - T2wI_air(:,:,1,z))./T2wI_air(:,:,1,z)*100;
    end
    %end
end

%Show BOLD map
figure;
b2 = imagesc(T2wI_rel(:,:,6,1));
pbaspect([1 1 1]);
colormap(jet)
caxis([-15 50]);
colorbar;
set(gca,'xtick',[],'ytick',[]);
title('BOLD map');


%Thresholding
low_lim = -10;
high_lim = 10;
thr = (T2wI_rel >= low_lim & T2wI_rel <= high_lim); 
T2wI_rel_thr = T2wI_rel .* thr;

% for z=1:size(thr,4)
%     figure;
%     imshow(thr(:,:,8,z));
%     title('BOLD map, thr');
% end


%% Overlay (Overlay one image transparently onto another)
%threshold image as a mask
time = 8;
slice = 2;
imB = T2wI_raw(:,:,time,slice); % Background image 
imF_thr = thr(:,:,time,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF_thr,[1,2],[0 10000],'flag',0.7); 
colormap('flag'); % figure colormap still applies
savename = strcat('dSI_overlay_t',num2str(time),'_z',num2str(slice),'_',num2str(low_lim),'to',num2str(high_lim),'.tif');
saveas(gcf,savename);

%relative change with color window
rel_min = 1;
rel_max = 50;
imF = T2wI_rel(:,:,time,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF,[rel_min,rel_max],[0 10000],'jet',0.7); 
colormap('jet'); % figure colormap still applies
colorbar;
savename = strcat('dSI_overlay_t',num2str(time),'_z',num2str(slice),'_',num2str(low_lim),'to',num2str(high_lim),'.tif');
saveas(gcf,savename);