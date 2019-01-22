function BOLD_getTOLD(animal_name, time_name, numofrois)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.1
% modified on 01/17/2019 by Jihun Kwon
% this function calculates dynamic TOLD signal.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

%% Parameters
% animal_name = 'M4';
% time_name = 'Andrea'; %'PreRT'or 'PostRT' or'Post1w or Andrea
ani_time_name = strcat(animal_name,'_',time_name);
%numofrois = 2;

%SAIL
TEs = [3 7 11 15 19 23 27 31 35 39 43 47 51 55 59]; %TR = 600


if strcmp(time_name,'PreRT')
    base_name_air1 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\15\pdata\1\dicom';
    base_name_air2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\16\pdata\1\dicom';
    base_name_oxy1 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\32\pdata\1\dicom';
    base_name_oxy2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\33\pdata\1\dicom';
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25'; %t1 map
    base_t2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\T2_dynamic'; %for dynamic TOLD
elseif strcmp(time_name,'PostRT')
    base_name_air1 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\6\pdata\1\dicom';
    base_name_air2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\7\pdata\1\dicom';
    base_name_oxy1 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\21\pdata\1\dicom';
    base_name_oxy2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\22\pdata\1\dicom';
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26'; %t1 map
    base_t2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\T2_dynamic'; %for dynamic TOLD
elseif strcmp(time_name,'Andrea_B')
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018'; %t1 map
    base_t2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018'; %for dynamic TOLD
    TEs = [2.5592 6.1152 9.6712 13.2272 16.7832 20.3392 23.8952 27.4512 31.0072 34.5633 38.1193 41.6753 45.2313 48.7873 52.3433]; %TR = 600
elseif strcmp(time_name,'Andrea_C')
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_C_2018'; %t1 map
    base_t2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_C_2018'; %for dynamic TOLD
    TEs = [2.5592 6.1152 9.6712 13.2272 16.7832 20.3392 23.8952 27.4512 31.0072 34.5633 38.1193 41.6753 45.2313 48.7873 52.3433]; %TR = 600
elseif strcmp(time_name,'Andrea_D')
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_D_2018'; %t1 map
    base_t2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_D_2018'; %for dynamic TOLD
    TEs = [2.5592 6.1152 9.6712 13.2272 16.7832 20.3392 23.8952 27.4512 31.0072 34.5633 38.1193 41.6753 45.2313 48.7873 52.3433]; %TR = 600
elseif strcmp(time_name,'Andrea_E')
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_E_2018'; %t1 map
    base_t2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_E_2018'; %for dynamic TOLD
    TEs = [2.5592 6.1152 9.6712 13.2272 16.7832 20.3392 23.8952 27.4512 31.0072 34.5633 38.1193 41.6753 45.2313 48.7873 52.3433]; %TR = 600
elseif strcmp(time_name,'Andrea_F')
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_F_2018'; %t1 map
    base_t2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_F_2018'; %for dynamic TOLD
    TEs = [2.5592 6.1152 9.6712 13.2272 16.7832 20.3392 23.8952 27.4512 31.0072 34.5633 38.1193 41.6753 45.2313 48.7873 52.3433]; %TR = 600
elseif strcmp(time_name,'Andrea_G')
    dir_t1map = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_G_2018'; %t1 map
    base_t2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_G_2018'; %for dynamic TOLD
    TEs = [2.5592 6.1152 9.6712 13.2272 16.7832 20.3392 23.8952 27.4512 31.0072 34.5633 38.1193 41.6753 45.2313 48.7873 52.3433]; %TR = 600
end

cd(dir_t1map)
cd results
load('reference_3ROIs.mat')

%% Get dynamic TOLD
cd(base_t2)
cd results
load('t2map_k.mat')

%BOLD_get_refROI(animal_name,time_name,base_name)

%% calulate ROI values and plot
psudoT1 = kmap + S0map;
for i=1:size(psudoT1,4)
    figure;
    [values(:,:,i),b(:,:,:,i),p{i}]=roi_values_ref(psudoT1,psudoT1(:,:,1,i),numofrois,b(:,:,:,i),p{i});
    clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
    subplot(1,2,1);imagesc(psudoT1(:,:,1,i));colormap(jet);
    %caxis([10000 20000]);
    img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois)
    subplot(1,2,2);plot(values(:,:,i),'-o','LineWidth',2);
    axis_setting1; title('TOLD');
    %ylim([10000 20000]);
    saveas(gcf,strcat(base_t2,'\results\psudoTOLD_s',num2str(i),'.tif'))
    xlswrite(strcat(base_t2,'\results\ROI_psudoTOLD_',num2str(numofrois),'roi_ref.xlsx'),values(:,:,i),i,'A1');
end
%Calc relative values (SI)
for tp = 1:size(values,1)
    for roi = 1:size(values,2)
        values_rel(tp,roi,:) = (values(tp,roi,:) - values(1,roi,:))...
            ./ values(1,roi,:)*100;
    end
end


%% Save parameters
cd(dir_t1map)
save('TOLD.mat','values','values_rel');

%% Plot BOLD and TOLD together
cd(dir_t1map)
load('TOLD.mat')
load('dT2star.mat')
for i=1:size(values_rel,3)
    figure;
    plot(values_rel_dT2(:,1,i),'-s','LineWidth',2); hold on;
    plot(values_rel_dT2(:,2,i),'-o','LineWidth',2); hold on;
    plot(values_rel(:,1,i),'--s','LineWidth',2); hold on;
    plot(values_rel(:,2,i),'--o','LineWidth',2); hold on;
    axis_setting1; title(strcat('\DeltaT2* vs TOLD, Z',num2str(i),', ',time_name));
    %ylim([-30 15]);
    yl = get(gca, 'YLim');
    line( [3.85 3.85], yl,'Color','black','LineStyle','--')
    xl = get(gca, 'XLim');
    line( xl, [0 0],'Color','black','LineStyle','-')
    xlabel('Time')
    ylabel('Relative Change (%)')
    legend({'L, \DeltaT2*','R \DeltaT2*','L, TOLD','R, TOLD'},'FontSize',12,'Location','southwest');
    saveas(gcf,strcat(base_t2,'\results\BOLDvsTOLD_s',num2str(i),'.tif'))
end

end