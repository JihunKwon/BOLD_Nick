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
SNR_air = zeros(97,97,1,z_max);
SNR = zeros(97,97,tp_max,z_max);
SNR_rel = zeros(97,97,tp_max,z_max);

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

%% SNR
%Calculate SNR pixel-by-pixel
for z = 1:z_max
    for tp = 1:tp_max
        bg = mean(mean(T2wI(1:15,1:15,tp,z)));
        SNR(:,:,tp,z) = T2wI(:,:,tp,z)/bg;
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

%% dSNR
%Calculate dSNR pixel-by-pixel
for z = 1:z_max
    SNR_air(:,:,1,z) = (SNR(:,:,1,z)+SNR(:,:,2,z)+SNR(:,:,3,z)+SNR(:,:,4,z)+SNR(:,:,5,z))/5;
    for tp = 1:tp_max
        SNR_rel(:,:,tp,z) = (SNR(:,:,tp,z) - SNR_air(:,:,1,z))./SNR_air(:,:,1,z)*100;
    end
end

%Show dSNR map
figure;
imagesc(SNR_rel(:,:,8,1));
pbaspect([1 1 1]);
colormap(jet)
caxis([-15 50]);
colorbar;
set(gca,'xtick',[],'ytick',[]);
title('dSNR(%) map');


%Thresholding
thr = (SNR_rel >= -10 & SNR_rel <= 10); 
SNR_rel_thr = SNR_rel .* thr;

for z=1:size(thr,4)
    figure;
    imshow(thr(:,:,8,z));
    title('dSNR(%) map, thr');
end
