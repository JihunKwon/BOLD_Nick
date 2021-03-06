%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2.0
% modified on 03/02/2018 by Heling Zhou, Ph.D.
% this function generates T2star or T2 maps and save the results in the folder 'results' under the dicom data folder
% Email: helingzhou7@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load data and header information

dirname=uigetdir; % location of "uncropped" dicom files
% BOLD_crop_Andr(dirname) %Jihun edit: this function crops image
% cropname = strcat(dirname,'_crop');
tarname = strcat(dirname,'_crop_norm');
[new_T,~]=dicom_info_field({'EchoTime','SliceLocation'},dirname);
%te=unique(new_T.EchoTime,'stable');
%numofslice=length(unique(new_T.SliceLocation));
data=dicomread_dir(tarname);
% te=5:7:68; % make sure te is correct;
te = [7 11 15 19 23 27 31 35 39 43 47 51 55 59];
numofslice = 3;
data=reshape(data,size(data,1),size(data,2),length(te),[]);

%% generate t2 maps, this part will take a lot of time. Use parallel computing if possible
[t2map,S0map,kmap]=make_many_t2maps_Andr(data,te);
t2map=reshape(t2map,size(t2map,1),size(t2map,2),numofslice,[]);
t2map = permute(t2map,[1,2,4,3]);
S0map=reshape(S0map,size(S0map,1),size(S0map,2),numofslice,[]);
S0map = permute(S0map,[1,2,4,3]);
kmap=reshape(kmap,size(kmap,1),size(kmap,2),numofslice,[]);
kmap = permute(kmap,[1,2,4,3]);
mkdir(strcat(dirname,'\results'))
save(strcat(dirname,'\results\t2map_k_norm'),'t2map','S0map','kmap')
%% save visualization results
figure;
for i=1:size(t2map,3)
    for j=1:size(t2map,4)
        clf
        imagesc(t2map(:,:,i,j));img_setting1;colormap jet;set(gca,'clim',[0 30]);colorbar; %Pre:[0 50],Post:[0 30]
        saveas(gcf,strcat(dirname,'\results\map_s',num2str(j),'_tp',num2str(i),'_norm_noSmooth.tif'))
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
    subplot(1,2,1);imagesc(t2map(:,:,1,i));colormap(gray);caxis([0 30]);img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois)
    subplot(1,2,2);plot(values(:,:,i),'LineWidth',2);
    axis_setting1; title('Dynamic T2');ylim([0 70]); %2roi:ylim([0 50]); 5roi:ylim([0 70]);
    saveas(gcf,strcat(dirname,'\results\plot_s',num2str(i),'_3roi_norm_each.tif'))
    xlswrite(strcat(dirname,'\results\ROI_values_2roi_G1.xlsx'),values(:,:,i),i,'A1');
end






%% Apply reference ROIs
if strcmp(time_name,'PreRT')
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25'; %t1 map
elseif strcmp(time_name,'PostRT')
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26'; %t1 map
elseif strcmp(time_name,'1wPost')
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181206_111438_Berbeco_Bi_Gd_1_27'; %t1 map
end

cd(dir_t1map)
load('reference_2ROIs.mat')

cd T2_dynamic/results_G0.5/
load('t2map.mat')

for i=1:size(t2map,4) %number of slice
    %values_t1w will be (1*ROIs*Slices)
    [values_dT2(:,:,i),b(:,:,:,i),p{i}]=roi_values_ref(t2map,t2map(:,:,1,i),numofrois,b(:,:,:,i),p{i});
end

for tp = 1:size(values_dT2,1)
    for roi = 1:size(values_dT2,2)
        values_rel_dT2(tp,roi,:) = (values_dT2(tp,roi,:) - values_dT2(1,roi,:))./ values_dT2(1,roi,:)*100;
    end
end
%% Relative change of dT2*
for i=1:size(values_rel_dT2,3)
    figure;
    plot(values_rel_dT2(:,:,i),'-o','LineWidth',2);
    axis_setting1; title(strcat('dT2*, Z',num2str(i),', ',time_name));
    xlim([0 16]); %pre:ylim([0 16000]);,post:ylim([0 31500]);
    ylim([-20 20]); %pre:ylim([0 16000]);,post:ylim([0 31500]);
    yl = get(gca, 'YLim');
    line( [3.15 3.15], yl,'Color','black','LineStyle','--'); hold on;
%     line( [6.15 6.15], yl,'Color','black','LineStyle','--'); hold on;
%     line( [11.15 11.15], yl,'Color','black','LineStyle','--'); hold on;
    xl = get(gca, 'XLim');
    line( xl, [0 0],'Color','black','LineStyle','-')
    xlabel('Time')
    ylabel('\DeltaT2* (%)')
    legend('Left Tumor','Right Tumor','Muscle','Location','northeast');
    saveas(gcf,strcat(base_t2,'\results\BOLD_s',num2str(i),'.tif'))
end

%% Save parameters
cd(dir_t1map)
save('BOLD.mat','values_dT2','values_rel_dT2');
