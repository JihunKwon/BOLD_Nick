function BOLD_getBOLDsi(base_name, animal_name, time_name, numofrois)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/06/2018 by Jihun Kwon
% this function calculates dynamic BOLD signal intensity.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

%% Parameters
% animal_name = 'M4';
% time_name = 'Andrea'; %'PreRT'or 'PostRT' or 'Post1w' or 'Andrea'
ani_time_name = strcat(animal_name,'_',time_name);
%numofrois = 2;
TEs = [2.5592 6.1152 9.6712 13.2272 16.7832 20.3392 23.8952 27.4512 31.0072 34.5633 38.1193 41.6753 45.2313 48.7873 52.3433];
count = 0;
z_max = 5; 
te_max = 15;

if (strcmp(time_name,'Chemo_2w'))
    tp_air = 3;
    tp_total = 25;
elseif (strcmp(time_name,'Control_1w') || strcmp(time_name,'Control_2w'))
    tp_air = 10;
    tp_total = 20;
end

crop_name = strcat(base_name,'_crop');
cd(base_name)
cd results_G05

if numofrois == 2
    load('reference_2ROIs.mat') %load reference rois
elseif numofrois == 3
    load('reference_3ROIs.mat') %load reference rois
end

cd(crop_name)

%15(TEs)*5(slice)*25(tp)
%Get every image with TE=39. TEs(10)
count = 10;
for tp = 1:tp_total
    for z = 1:z_max
        for te = 1:size(TEs,2)
            if te == te_max
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(crop_name, sname);
                T2wI(:,:,tp,z) = dicomread(fname);
                info = dicominfo(fname); %Extract dicom_info
                %info.EchoTime
                count = count+15;
            end
        end
    end
end

%Apply reference ROI to I
for i=1:size(T2wI,4)
    figure;
    [values(:,:,i),b(:,:,:,i),p{i}]=roi_values_ref(T2wI,T2wI(:,:,1,i),numofrois,b(:,:,:,i),p{i});
    clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
    subplot(1,2,1);imagesc(T2wI(:,:,1,i));colormap(jet);
    caxis([0 10000]);
    img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois)
    subplot(1,2,2);plot(values(:,:,i),'-o','LineWidth',2);
    axis_setting1; title('BOLD');ylim([0 10000]); %pre:ylim([0 16000]);,post:ylim([0 31500]);
    saveas(gcf,strcat(base_name,'\results_G05\BOLDsi_s',num2str(i),'.tif'))
    xlswrite(strcat(base_name,'\results_G05\BOLDsi_2roi_ref.xlsx'),values(:,:,i),i,'A1');
end

%Calc relative values (SI)
for tp = 1:size(values,1)
    for roi = 1:size(values,2)
        values_rel_bold(tp,roi,:) = (values(tp,roi,:) - values(1,roi,:))...
            ./ values(1,roi,:)*100;
    end
end

%Visualize scaled values
for i=1:size(values_rel_bold,3)
    figure;
    plot(values_rel_bold(:,:,i),'-o','LineWidth',2);
    axis_setting1; title(strcat('BOLD, Z',num2str(i),', ',time_name));
    ylim([-50 50]);
    yl = get(gca, 'YLim');
    line( [3.15 3.15], yl,'Color','black','LineStyle','--'); hold on;
%     line( [6.15 6.15], yl,'Color','black','LineStyle','--'); hold on;
%     line( [11.15 11.15], yl,'Color','black','LineStyle','--'); hold on;
    xl = get(gca, 'XLim');
    line( xl, [0 0],'Color','black','LineStyle','-')
    xlabel('Time')
    ylabel('\DeltaSI (%)')
    legend('ROI 1','ROI 2','ROI 3','Location','southeast');
    saveas(gcf,strcat(base_name,'\results_G05\BOLDsi_s',num2str(i),'.tif'))
end

%Calc relative T2* change
for tp = 1:size(values,1)
    for roi = 1:size(values,2)
        values_rel_bold(tp,roi,:) = (values(tp,roi,:) - values(1,roi,:)) ./ values(1,roi,:)*100;
    end
end


%% Plot BOLD, dT2* and TOLD all together
cd(base_name)
load('TOLD.mat') %values_rel:   TOLD
load('dT2star.mat') %values_rel_b: dT2*.
for i=1:size(values_rel,3)
    figure;
    plot(values_rel_bold(:,1,i),'-ro','MarkerSize',8,'MarkerFaceColor','red','LineWidth',2); hold on;    
    plot(values_rel_bold(:,2,i),'--ro','MarkerSize',8,'LineWidth',2); hold on;
    
    if numofrois==3
        plot(values_rel_bold(:,3,i),':ro','MarkerSize',8,'LineWidth',2); hold on; %3rd ROI
    end
    
    plot(values_rel_dT2(:,1,i),'-^','MarkerSize',8,'MarkerFaceColor',[.3 .77 .09],'LineWidth',2,'color',[.3 .77 .09]); hold on;
    plot(values_rel_dT2(:,2,i),'--^','MarkerSize',8,'LineWidth',2,'color',[.3 .77 .09]); hold on;
    
    if numofrois==3
        plot(values_rel_dT2(:,3,i),':^','MarkerSize',8,'LineWidth',2,'color',[.3 .77 .09]); hold on; %3rd ROI
    end
    
    plot(values_rel(:,1,i),'-ks','MarkerSize',8,'MarkerFaceColor','black','LineWidth',2); hold on;
    plot(values_rel(:,2,i),'--ks','MarkerSize',8,'LineWidth',2); hold on;
    
    if numofrois==3
        plot(values_rel(:,3,i),':ks','MarkerSize',8,'LineWidth',2); hold on; %3rd ROI
    end
    
    %axis_setting1; title(strcat('BOLD vs \DeltaT2* vs TOLD, Z',num2str(i),', ',time_name));
    axis_setting1; title(strcat('BOLD vs \DeltaT2* vs TOLD, Z',num2str(i)));
    %xlim([0 16]);
    %ylim([-50 50]);
    yl = get(gca, 'YLim');
    line( [tp_air+0.5 tp_air+0.5], yl,'Color','black','LineStyle','--'); hold on;
    xl = get(gca, 'XLim');
    line( xl, [0 0],'Color','black','LineStyle','-')
    xlabel('Time')
    ylabel('Relative Change (%)')
    
    if numofrois==2
        legend({'Tumor, BOLD','Tissue, BOLD','Tumor, \DeltaT2*','Tissue, \DeltaT2*',...
            'Tumor, TOLD','Tissue, TOLD'},'FontSize',11,'Location','northwest');
    elseif numofrois==3
        legend({'ROI1, BOLD','ROI2, BOLD','ROI3, BOLD','ROI1, \DeltaT2*','ROI2, \DeltaT2*',...
            'ROI3, \DeltaT2*','ROI1, TOLD','ROI2, TOLD','ROI3, TOLD'},'FontSize',8,'Location','northwest');
    end
    saveas(gcf,strcat(base_name,'\results_G05\BOLDvsT2vsTOLD_s',num2str(i),'.tif'))
end