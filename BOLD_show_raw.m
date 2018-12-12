%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/10/2018 by Jihun Kwon
% Compare raw dicom image with different timepoints
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

animal_name = 'M4';
time_name = 'PreRT'; %'PreRT'or 'PostRT' or 'Post1w'
ani_time_name = strcat(animal_name,'_',time_name);
margins = [.007 .007];
cb_gray = [0 30000];

if strcmp(time_name,'PreRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\T2_dynamic_crop';
elseif strcmp(time_name,'PostRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\T2_dynamic_crop';
elseif strcmp(time_name,'Post1w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181206_111438_Berbeco_Bi_Gd_1_27\T2_dynamic_crop';
end

count = 1;
cd(base_name)
x_l = 20;
y_l = 30;
x_r = 38;
y_r = 28;
len = 5;
for tp = 1:11
    for z = 1:3
        for te = 1:15
            if (rem(z,3) == 1 && rem(te,15) == 2) %if te == 1
                fname_temp = sprintf('MRIc%04d.dcm',count);
                dcm(:,:,tp) = dicomread(fname_temp);
                dcm_pic_L(tp) = dcm(y_l-len,x_l+len,tp);
                dcm_pic_R(tp) = dcm(y_r-len,x_r+len,tp);
            end
            count = count + 1;
        end
    end
end


figure(1);
set(gcf,'Position',[100 100 1100 900], 'Color', 'w')
for tp=1:11
    subplot_tight(3,4,tp,margins), imagesc(dcm(:,:,tp)), title(strcat(num2str(tp),', z1')); 
    %colorbar; 
    colormap(gray); set(gca,'clim',cb_gray,'dataAspectRatio',[1 1 1]); axis off;
end
saveas(gcf,'dicom_tps_raw.tif');
export_fig dicom_tps_raw.tif -q101

figure(2);
set(gcf,'Color', 'w')
plot(1:11,dcm_pic_L(1:11),'-o'), title('Left Tumor, z1');

figure(3);
set(gcf,'Color', 'w')
plot(1:11,dcm_pic_R(1:11),'-o'), title('Right Tumor, z1');