function [t2map] = BOLD_estT2map(base_name,i,time_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2.0
% modified on 03/02/2018 by Heling Zhou, Ph.D.
% this function generates T2star or T2 maps and save the results in the folder 'results' under the dicom data folder
% Email: helingzhou7@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2.2
% modified on 10/10/2018 by Jihun Kwon
% To make analysis faster, this code uses figures cropped at "crop_init_fig.m". 
% When running this code, current directory has to be the directory where
% the cropped figure are saved.
% (ex:\hoge\MyImagingLab_T2map_dicom-master\output\247)
% basename:path to target directory
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load data and header information
f_num = num2str(i);
%f_num_crop = strcat(f_num,'_crop');
f_num_crop = strcat('_crop');
base_new = strcat(base_name,f_num);
base_crop = strcat(base_name,f_num_crop);
base_crop = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018_crop';
cd(base_crop)

BOLD_crop_Andr(base_new,base_crop,time_name);

%% Smoothing by Gaussian Filter, if necessarily
gauss_sigma = 0.5; %Change this sigma accordingly
gauss_sigma_str = num2str(gauss_sigma);
f_num_gauss = strcat(f_num_crop,'_G',gauss_sigma_str);
base_gauss = strcat(base_name,f_num_gauss);
base_gauss = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018_crop_G05';
cd(base_gauss)
BOLD_Gaussian(base_crop,base_gauss,gauss_sigma);
base_crop = base_gauss;

%% Start Estimation
base_new = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018';
[new_T,~]=dicom_info_field({'EchoTime','SliceLocation'},base_new);
te=unique(new_T.EchoTime,'stable');
numofslice=length(unique(new_T.SliceLocation));
data=dicomread_dir(base_crop); %J edit

% te=5:7:68; % make sure te is correct;
data=reshape(data,size(data,1),size(data,2),length(te),[]);

%% generate t2 maps, this part will take a lot of time. Use parallel computing if possible
[t2map,S0map]=make_many_t2maps(data,te);
t2map=reshape(t2map,size(t2map,1),size(t2map,2),numofslice,[]);
t2map = permute(t2map,[1,2,4,3]);
S0map=reshape(S0map,size(S0map,1),size(S0map,2),numofslice,[]);
S0map = permute(S0map,[1,2,4,3]);
mkdir(strcat(base_crop,'\results'))
save(strcat(base_crop,'\results\t2map'),'t2map','S0map')

%{
%% save visualization results
figure;
for i=1:size(t2map,3)
    for j=1:size(t2map,4)
        clf
        imagesc(t2map(:,:,i,j));img_setting1;colormap jet;set(gca,'clim',[0 50]);colorbar;
        saveas(gcf,strcat(basecrop,'\results\map_s',num2str(j),'_tp',num2str(i),'.tif'))
    end
end

%% calulate ROI values and plot
t2map(t2map>100)=nan;
flag=1;
while flag
    try 
        numofrois=uint8(input('number of ROI: '));
        flag=0;
    catch em
    end
end

for i=1:size(t2map,4)
    [values(:,:,i),b(:,:,:,i),p{i}]=roi_values(t2map,t2map(:,:,1,i),numofrois);
    clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
    subplot(1,2,1);imagesc(t2map(:,:,1,1));colormap(gray);img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois)
    subplot(1,2,2);plot(values(:,:,i),'LineWidth',2);
    axis_setting1; title('Dynamic T2')
    saveas(gcf,strcat(basecrop,'\results\plot_s',num2str(i),'.tif'))
    
    %J: Original code
    %xlswrite(strcat(dirname_crop,'\results\ROI_values.xlsx'),values(:,:,i),i,'A1');
    
    %J: This works for cropped figures
    out(:,:,i) = (values(:,:,i));
    sheetname = strcat("Slice ",int2str(i));
    xlswrite(strcat('\results\ROI_values.xlsx'),out(:,:,i),sheetname);
end
%}
end

