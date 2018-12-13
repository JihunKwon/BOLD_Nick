%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/12/2018 by Jihun Kwon
% this code calculates dynamic BOLD signal intensity.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters
raw_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018_crop_G05';
tp_max = 25; 
z_max = 5; 
te_max = 15;
te_target = 11;
cd(raw_name)

%15(TEs)*5(slice)*25(tp)
T2wI = zeros(97,97,tp_max,z_max);
T2wI_air = zeros(97,97,1,z_max);
T2wI_rel = zeros(97,97,tp_max,z_max);

%Get every image with TE=39. TEs(10)
count = 0;
for tp = 1:tp_max
    for z = 1:z_max
        for te = 1:te_max
            count = count + 1;
            if te == te_target
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(raw_name, sname);
                T2wI(:,:,tp,z) = dicomread(fname);
                %info = dicominfo(fname); %Extract dicom_info
                %info.EchoTime
            end
        end
    end
end

%Calculate BOLD pixel-by-pixel
for z = 1:z_max
    T2wI_air(:,:,1,z) = (T2wI(:,:,1,z)+T2wI(:,:,2,z)+T2wI(:,:,3,z)+T2wI(:,:,4,z)+T2wI(:,:,5,z))/5;
    %if tp>6
    for tp = 1:tp_max
        T2wI_rel(:,:,tp,z) = (T2wI(:,:,tp,z) - T2wI_air(:,:,1,z))./T2wI_air(:,:,1,z)*100;
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
thr = (T2wI_rel >= -10 & T2wI_rel <= 10); 
T2wI_rel_thr = T2wI_rel .* thr;

for z=1:size(thr,4)
    figure;
    imshow(thr(:,:,8,z));
    title('BOLD map, thr');
end


%% Overlay
% Overlay one image transparently onto another 
imB = T2wI(:,:,1,1); % Background image 
imF = rgb2gray(imread('ngc6543a.jpg')); % Foreground image 
[hf,hb] = imoverlay(imB,imF,[40,180],[0,0.6],'jet',0.6); 
colormap('hot'); % figure colormap still applies 