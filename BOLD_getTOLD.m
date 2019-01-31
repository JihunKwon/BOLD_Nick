function BOLD_getTOLD(base_name, animal_name, time_name, numofrois)

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
TEs = [2.5592 6.1152 9.6712 13.2272 16.7832 20.3392 23.8952 27.4512 31.0072 34.5633 38.1193 41.6753 45.2313 48.7873 52.3433]; %TR = 600

cd(base_name)
cd results_G05
if numofrois == 2
    load('reference_2ROIs.mat')
elseif numofrois == 3
    load('reference_3ROIs.mat')
end

%% Get dynamic TOLD
cd(base_name)
cd results_G05
load('t2map.mat')

%BOLD_get_refROI(animal_name,time_name,base_name)

%% calulate ROI values and plot
psudoT1 = kmap + S0map;
for i=1:size(psudoT1,4)
    figure;
    [values(:,:,i),b(:,:,:,i),p{i}]=roi_values_ref(psudoT1,psudoT1(:,:,1,i),numofrois,b(:,:,:,i),p{i});
    clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
    subplot(1,2,1);imagesc(psudoT1(:,:,1,i));colormap(jet);
    caxis([10000 30000]);
    img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois)
    subplot(1,2,2);plot(values(:,:,i),'-o','LineWidth',2);
    axis_setting1; title('TOLD');
    %ylim([10000 20000]);
    saveas(gcf,strcat(base_name,'\results_G05\psudoTOLD_s',num2str(i),'.tif'))
    xlswrite(strcat(base_name,'\results_G05\ROI_psudoTOLD_',num2str(numofrois),'roi_ref.xlsx'),values(:,:,i),i,'A1');
end
%Calc relative values (SI)
for tp = 1:size(values,1)
    for roi = 1:size(values,2)
        values_rel(tp,roi,:) = (values(tp,roi,:) - values(1,roi,:))...
            ./ values(1,roi,:)*100;
    end
end


%% Save parameters
cd(base_name)
save('TOLD.mat','values','values_rel');

%% Plot T2* and TOLD together
cd(base_name)
load('TOLD.mat')
load('dT2star.mat')
for i=1:size(values_rel,3) % number of slices
    figure;
    %Manually change the number of "plot..." sentences below. Has to be
    %equal or smaller than the number of ROIs.
    plot(values_rel_dT2(:,1,i),'-s','LineWidth',2); hold on; %Plot dT2*, 1st ROI
    plot(values_rel_dT2(:,2,i),'--s','LineWidth',2); hold on; %Plot dT2*, 2nd ROI
    
    if numofrois==3
        plot(values_rel_dT2(:,3,i),':s','LineWidth',2); hold on; %Plot dT2*, 3rd ROI
    end
    
    plot(values_rel(:,1,i),'-o','LineWidth',2); hold on; %Plot TOLD, 1st ROI
    plot(values_rel(:,2,i),'--o','LineWidth',2); hold on;
    
    if numofrois==3
        plot(values_rel(:,3,i),':o','LineWidth',2); hold on;
    end
    
    axis_setting1; title(strcat('\DeltaT2* vs TOLD, Z',num2str(i),', ',time_name));
    %ylim([-30 15]);
    yl = get(gca, 'YLim');
    line( [3.85 3.85], yl,'Color','black','LineStyle','--')
    xl = get(gca, 'XLim');
    line( xl, [0 0],'Color','black','LineStyle','-')
    xlabel('Time')
    ylabel('Relative Change (%)')
    legend({'ROI1, \DeltaT2*','ROI2, \DeltaT2*','ROI3, \DeltaT2*','ROI1, TOLD','ROI2, TOLD','ROI3, TOLD'},'FontSize',12,'Location','southwest');
    saveas(gcf,strcat(base_name,'\results_G05\BOLDvsTOLD_s',num2str(i),'.tif'))
end

end