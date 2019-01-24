%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2.1
% modified on 03/02/2018 by Heling Zhou, Ph.D.
% modified on 01/17/2018 by Jihun Kwon
% this function generates T2star or T2 maps, and save the results in the folder 'results' under the dicom data folder
% Also saves BOLD.mat, which will be used later
% Email: helingzhou7@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
%% load data and header information
dirname=uigetdir; % location of "uncropped" dicom files
tarname = strcat(dirname,'_crop'); %name of target files. In our case, this is usually cropped files.
[new_T,~]=dicom_info_field({'EchoTime','SliceLocation'},dirname);
te=unique(new_T.EchoTime,'stable');
numofslice=length(unique(new_T.SliceLocation));
data=dicomread_dir(tarname);
data=reshape(data,size(data,1),size(data,2),length(te),[]);

%% generate t2 maps, this part will take a lot of time. Use parallel computing if possible
[t2map,S0map,kmap]=make_many_t2maps_Andr(data,te);
t2map=reshape(t2map,size(t2map,1),size(t2map,2),numofslice,[]);
t2map = permute(t2map,[1,2,4,3]);
S0map=reshape(S0map,size(S0map,1),size(S0map,2),numofslice,[]);
S0map = permute(S0map,[1,2,4,3]);
kmap=reshape(kmap,size(kmap,1),size(kmap,2),numofslice,[]);
kmap = permute(kmap,[1,2,4,3]);
mkdir(strcat(dirname,'\results_G05'))

%Heling saved "t2map" and "S0map", but if you want to get "psudo-TOLD" signal, also save "kmap".
save(strcat(dirname,'\results_G05\t2map'),'t2map','S0map','kmap')
%save(strcat(dirname,'\results_G05\t2map'),'t2map','S0map')

%% save visualization results
figure;
for i=1:size(t2map,3)
    for j=1:size(t2map,4)
        clf
        imagesc(t2map(:,:,i,j));img_setting1;colormap jet;set(gca,'clim',[0 30]);colorbar; %Pre:[0 50],Post:[0 30]
        saveas(gcf,strcat(dirname,'\results_G05\map_s',num2str(j),'_tp',num2str(i),'.tif'))
    end
end

%% Set number of ROIs
t2map(t2map>100)=nan;
flag=1;
while flag
    try 
        numofrois=uint8(input('number of ROI: '));
        flag=0;
    catch em
    end
end

%% Contour ROIs
background_str = 'Raw'; %Chose 'T2map' or 'Raw', for background image of contouring.
for i=1:size(t2map,4)
    %When contour on "T2* map"
    if strcmp(background_str, 'T2map') 
        tp_target = 5; %which timepoint to use for T2*map contouring
        [values(:,:,i),b(:,:,:,i),p{i}]=roi_values(t2map,t2map(:,:,tp_target,i),numofrois,background_str);
        clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
        subplot(1,2,1);
        imagesc(t2map(:,:,5,i)); caxis([0 50]); %To visualize T2* map
        
    %When contour on "raw dicom" image
    elseif strcmp(background_str, 'Raw') 
        tp_target = 8; %which timepoint to use for T2*map contouring
        file_target = 5; %which TE to use for raw image contouring
        file_target = 15*5*tp_target + file_target;
        sname = sprintf('MRIc%04d.dcm',file_target);
        fname = fullfile(tarname, sname);
        T2wI(:,:,1,i) = dicomread(fname);
        [values(:,:,i),b(:,:,:,i),p{i}]=roi_values(t2map,T2wI(:,:,1,i),numofrois,background_str);
        file_target = file_target+size(te,1); %go to next slice, same te file
        clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
        subplot(1,2,1);
        imagesc(T2wI(:,:,1,i)); caxis([0 18000]); %To visualize dicom file B:14000, C:18000
    else
        return
    end
    colormap(gray);
    img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois)
    subplot(1,2,2);plot(values(:,:,i),'LineWidth',2);
    axis_setting1; title('Dynamic T2');ylim([0 40]); %2roi:ylim([0 50]); 5roi:ylim([0 70]);
    saveas(gcf,strcat(dirname,'\results\plot_',background_str,'_s',num2str(i),'_',num2str(numofrois),'roi.tif'))
    xlswrite(strcat(dirname,'\results\ROI_values_',background_str,'_',num2str(numofrois),'roi.xlsx'),values(:,:,i),i,'A1');
end

%Saving variables 'values','b','p' is important when you want to reproduce
%the same contouring.
save(strcat(dirname,'\results\reference_',num2str(numofrois),'ROIs'),'values','b','p')

%% Apply reference ROIs
%When you want to apply same ROIs to different timepoint images and
%compare, use "reference ROIs".
%{
cd(dirname)
load('reference_2ROIs.mat')
%load('reference_3ROIs.mat')

cd T2_dynamic/results_G0.5/
load('t2map.mat')
%}

%% Relative change of dT2*
%Calculate 
for i=1:size(t2map,4) %number of slice
    %values_t1w will be (1*ROIs*Slices)
    [values_dT2(:,:,i),b(:,:,:,i),p{i}]=roi_values_ref(t2map,t2map(:,:,1,i),numofrois,b(:,:,:,i),p{i});
end

for tp = 1:size(values_dT2,1)
    for roi = 1:size(values_dT2,2)
        values_rel_dT2(tp,roi,:) = (values_dT2(tp,roi,:) - values_dT2(1,roi,:))./ values_dT2(1,roi,:)*100;
    end
end
for i=1:size(values_rel_dT2,3)
    figure;
    plot(values_rel_dT2(:,:,i),'-o','LineWidth',2);
    axis_setting1; title(strcat('dT2*, Z',num2str(i),', ',time_name));
    %xlim([0 25]); %pre:ylim([0 16000]);,post:ylim([0 31500]);
    %ylim([-20 20]); %pre:ylim([0 16000]);,post:ylim([0 31500]);
    yl = get(gca, 'YLim');
    line( [3.15 3.15], yl,'Color','black','LineStyle','--'); hold on;
    xl = get(gca, 'XLim');
    line( xl, [0 0],'Color','black','LineStyle','-')
    xlabel('Time')
    ylabel('\DeltaT2* (%)')
    legend('ROI1','ROI2','ROI3','Location','northeast');
    saveas(gcf,strcat(dirname,'\results\BOLD_s',num2str(i),'.tif'))
end

%% Save parameters
cd(base_name)
save('dT2star.mat','values_dT2','values_rel_dT2');
