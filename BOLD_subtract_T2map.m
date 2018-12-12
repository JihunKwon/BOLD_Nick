%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/09/2018 by Jihun Kwon
% Subtract T2* map of O2 from air (T2*air - T2*oxy).
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

animal_name = 'M4';
time_name = 'PreRT'; %'PreRT'or 'PostRT' or 'Post1w'
ani_time_name = strcat(animal_name,'_',time_name);
margins = [.007 .007];
cb_t2sub = [-35 35];

if strcmp(time_name,'PreRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\';
elseif strcmp(time_name,'PostRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\';
elseif strcmp(time_name,'Post1w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181206_111438_Berbeco_Bi_Gd_1_27\';
end


cd(base_name)
cd T2_dynamic\results_G0.5
load('t2map.mat')

T2sub = zeros(size(t2map));
T2sub_air_ave = zeros(size(t2map));

for z = 1:3
    for i = 2:11
        T2sub(:,:,i,z) = t2map(:,:,i,z) - t2map(:,:,1,z);
    end
end

for z = 1:3
    for i = 4:11
        T2sub_air_ave(:,:,i,z) = t2map(:,:,i,z) - (t2map(:,:,1,z)+t2map(:,:,2,z)+t2map(:,:,3,z))/3;
    end
end
% 
% figure
% imagesc(t2map(:,:,1,1));
% colormap gray; 

%% air1 - other
figure(1); %subtraction, z1
set(gcf,'Position',[100 100 1300 500], 'Color', 'w')
for i=2:11
    subplot_tight(2,5,i-1,margins), imagesc(T2sub(:,:,i,1)), title(strcat(num2str(i),'-1, z1')); 
    colorbar; colormap(redblue); set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); axis off;
end
saveas(gcf,'BOLD_T2sub_pre_z1_cbL.tif');
export_fig BOLD_T2sub_pre_z1_cbL.tif -q101


figure(2); %subtraction, z2
set(gcf,'Position',[100 100 1300 500], 'Color', 'w')
for i=2:11
    subplot_tight(2,5,i-1,margins), imagesc(T2sub(:,:,i,2)), title(strcat(num2str(i),'-1, z2')); 
    colorbar; colormap(redblue); set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); axis off;
end
saveas(gcf,'BOLD_T2sub_pre_z2_cbL.tif');
export_fig BOLD_T2sub_pre_z2_cbL.tif -q101


figure(3); %subtraction, z3
set(gcf,'Position',[100 100 1300 500], 'Color', 'w')
for i=2:11
    subplot_tight(2,5,i-1,margins), imagesc(T2sub(:,:,i,3)), title(strcat(num2str(i),'-1, z3')); 
    colorbar; colormap(redblue); set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); axis off;
end
saveas(gcf,'BOLD_T2sub_pre_z3_cbL.tif');
export_fig BOLD_T2sub_pre_z3_cbL.tif -q101


%% air(average) - other
%{
figure(4); %subtraction, z1
set(gcf,'Position',[100 100 960 500], 'Color', 'w')
for i=4:11
    subplot_tight(2,4,i-3,margins), imagesc(T2sub_air_ave(:,:,i,1)), title(strcat(num2str(i),', z1')); 
    colorbar; colormap(redblue); set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); axis off;
end
saveas(gcf,'BOLD_T2sub_airave_z1.tif');
export_fig BOLD_T2sub_airave_z1.tif -q101


figure(5); %subtraction, z2
set(gcf,'Position',[100 100 960 500], 'Color', 'w')
for i=4:11
    subplot_tight(2,4,i-3,margins), imagesc(T2sub_air_ave(:,:,i,2)), title(strcat(num2str(i),', z2')); 
    colorbar; colormap(redblue); set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); axis off;
end
saveas(gcf,'BOLD_T2sub_airave_z2.tif');
export_fig BOLD_T2sub_airave_z2.tif -q101


figure(6); %subtraction, z3
set(gcf,'Position',[100 100 960 500], 'Color', 'w')
for i=4:11
    subplot_tight(2,4,i-3,margins), imagesc(T2sub_air_ave(:,:,i,3)), title(strcat(num2str(i),', z3')); 
    colorbar; colormap(redblue); set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); axis off;
end
saveas(gcf,'BOLD_T2sub_airave_z3.tif');
export_fig BOLD_T2sub_airave_z3.tif -q101
%}

%% Compare Bolus and Right tumor

len = 8;
for z = 1:3
    for i = 2:11
        T2sub_Rtumor(i,z) = sum(sum(T2sub(22:40,27:45,i,z))); 
        T2sub_bolus(i,z) = sum(sum(T2sub(end-(len-1):end,1:len,i,z))); %Square  
    end
end
%Z1
figure;
plot(2:11,T2sub_Rtumor(2:11,1)); hold on;
plot(2:11,T2sub_bolus(2:11,1)); hold on;
legend('Right tumor','bolus');
xlabel('Time');
ylabel('Subracted T2* (ms)');
title('Right tumor vs Bolus, z1');
%Z2
figure;
plot(2:11,T2sub_Rtumor(2:11,2)); hold on;
plot(2:11,T2sub_bolus(2:11,2)); hold on;
legend('Right tumor','bolus');
xlabel('Time');
ylabel('Subracted T2* (ms)');
title('Right tumor vs Bolus, z2');
%Z3
figure;
plot(2:11,T2sub_Rtumor(2:11,3)); hold on;
plot(2:11,T2sub_bolus(2:11,3)); hold on;
legend('Right tumor','bolus');
xlabel('Time');
ylabel('Subracted T2* (ms)');
title('Right tumor vs Bolus, z3');

%% Apply reference ROIs
cd(base_name)
load('reference_2ROIs.mat')
numofrois = 2;

for i=1:size(t2map,4) %number of slice
    %values_t1w will be (1*ROIs*Slices)
    [values_dT2(:,:,i),b(:,:,:,i),p{i}]=roi_values_ref(t2map,t2map(:,:,1,i),numofrois,b(:,:,:,i),p{i});
end

T2_Rtumor = squeeze(values_dT2(:,:,1));
len = 10;
for i = 2:11
    T2_bolus(i,1) = sum(sum(t2map(end-(len-1):end,1:len,i,1))); %Square
end

figure;
plot(2:11,T2_Rtumor(2:11,2)); hold on;
plot(2:11,T2_bolus(2:11,1)); hold on;
legend('Right tumor','bolus');