%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/06/2018 by Jihun Kwon
% this function calculates dynamic BOLD signal intensity.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters
animal_name = 'M4';
time_name = 'Post1w'; %'PreRT'or 'PostRT' or 'Post1w'
ani_time_name = strcat(animal_name,'_',time_name);
numofrois = 2;
TEs = [3 7 11 15 19 23 27 31 35 39 43 47 51 55 59]; %TR = 600
T2wI = zeros(61,61,11,3);
count = 0;

if strcmp(time_name,'PreRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25';
    crop_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\T2_dynamic_crop_G05';
    tp_max = 11; z_max = 3; te_max = 15;
elseif strcmp(time_name,'PostRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26';
    crop_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\T2_dynamic_crop_G05';
    tp_max = 11; z_max = 3; te_max = 15;
elseif strcmp(time_name,'Post1w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181206_111438_Berbeco_Bi_Gd_1_27';
    crop_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181206_111438_Berbeco_Bi_Gd_1_27\T2_dynamic_crop_G05';
    tp_max = 16; z_max = 3; te_max = 15;
end

cd(base_name)
load('reference_2ROIs.mat') %load reference rois

cd(crop_name)

%15(TEs)*3(slice)*11(tp)
%Get every image with TE=39. TEs(10)
count = 10;
for tp = 1:tp_max
    for z = 1:z_max
        for te = 1:15
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
    subplot(1,2,1);imagesc(T2wI(:,:,1,i));colormap(gray);
    caxis([0 10000]);
    img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois)
    subplot(1,2,2);plot(values(:,:,i),'-o','LineWidth',2);
    axis_setting1; title('Dynamic T2');ylim([0 10000]); %pre:ylim([0 16000]);,post:ylim([0 31500]);
    saveas(gcf,strcat(base_name,'\results\BOLDsi_s',num2str(i),'.tif'))
    xlswrite(strcat(base_name,'\results\BOLDsi_3roi_ref.xlsx'),values(:,:,i),i,'A1');
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
    ylim([-30 15]);
    yl = get(gca, 'YLim');
    line( [3.15 3.15], yl,'Color','black','LineStyle','--'); hold on;
    line( [6.15 6.15], yl,'Color','black','LineStyle','--'); hold on;
    line( [11.15 11.15], yl,'Color','black','LineStyle','--'); hold on;
    xl = get(gca, 'XLim');
    line( xl, [0 0],'Color','black','LineStyle','-')
    xlabel('Time')
    ylabel('\DeltaSI (%)')
    legend('Left Tumor','Right Tumor','Location','southeast');
    saveas(gcf,strcat(base_name,'\results\BOLDsi_s',num2str(i),'.tif'))
end



%% Plot BOLD, dT2* and TOLD all together
cd(base_name)
load('TOLD.mat') %values_rel:   TOLD
load('BOLD.mat') %values_rel_b: dT2*.
for i=1:size(values_rel,3)
    figure;
    plot(values_rel_bold(:,1,i),'-ro','LineWidth',2); hold on;    
    plot(values_rel_bold(:,2,i),'--ro','LineWidth',2); hold on;  
    plot(values_rel_b(:,1,i),'-g^','LineWidth',2); hold on;
    plot(values_rel_b(:,2,i),'--g^','LineWidth',2); hold on;
    plot(values_rel(:,1,i),'-ks','LineWidth',2); hold on;
    plot(values_rel(:,2,i),'--ks','LineWidth',2); hold on;
    axis_setting1; title(strcat('BOLD vs \DeltaT2* vs TOLD, Z',num2str(i),', ',time_name));
    xlim([0 16]);
    ylim([-30 20]);
    yl = get(gca, 'YLim');
    line( [3.15 3.15], yl,'Color','black','LineStyle','--'); hold on;
    line( [6.15 6.15], yl,'Color','black','LineStyle','--'); hold on;
    line( [11.15 11.15], yl,'Color','black','LineStyle','--'); hold on;
    xl = get(gca, 'XLim');
    line( xl, [0 0],'Color','black','LineStyle','-')
    xlabel('Time')
    ylabel('Relative Change (%)')
    legend({'L, BOLD','R, BOLD','L, \DeltaT2*','R \DeltaT2*','L, TOLD','R, TOLD'},'FontSize',6,'Location','southwest');
    saveas(gcf,strcat(base_name,'\results\BOLDvsT2vsTOLD_s',num2str(i),'.tif'))
end