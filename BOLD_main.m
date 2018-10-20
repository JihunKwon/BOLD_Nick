%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/10/2018 by Jihun Kwon
% Import T1wI and estimate T1map and T2*map
% Contour on T1map and calculate average of ROI.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;
tic;
animal_name = 'M3';
time_name = 'PostRT_30m'; %'PreRT'or 'PostRT_10m' or 'PostRT_30m'
ani_time_name = strcat(animal_name,'_',time_name);
base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\';
base_name = strcat(base_name,ani_time_name,'\');
cd(base_name);
%Folder dir. 1:air T1wI, 2:air T2*wI, 3:O2 T1wI, 4:O2 T2*wI
%{
%i=4;
for i=1:2 %i=1;
    %Mouse 3
    TR = [100 150 300 500 1000 2000 3000 5000 8000]; nSlices = 3; nTRs = size(TR,2);
    
    if (rem(i,2)==1) %if i is T1wI, estimate T1map
        cd(base_name);
        % Import DICOM
        f_num = num2str(i);
        cd(f_num);
        F = dir('MR*');
        
        %% Estimate T1map from T1wI
        T1_est = BOLD_estT1map(F,TR,nTRs,nSlices);
        
        % Write Parameters
        if i==1
            T1_est_air = T1_est;
        else %if i==3
            T1_est_O2 = T1_est;
        end
        
    else %if i is T2*wI, estimate T2*map
        cd(base_name);
        % Import DICOM
        f_num = num2str(i);
        cd(f_num);
        F = dir('MR*');
        T2_est = BOLD_estT2map(base_name,i);
        
        % Write Parameters
        if i==2
            T2_est_air = T2_est;
            T2_est_air = squeeze(T2_est_air);
        else %if i==4
            T2_est_O2 = T2_est;
            T2_est_O2 = squeeze(T2_est_O2);
        end
    end
end %end of for loop
%}

        
% load('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PreRT\T1map_air_M3_para.mat')
% load('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PreRT\T1map_O2_M3_para.mat')
% load('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PreRT\T2map_air_M3_para.mat')
% load('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PreRT\T2map_O2_M3_para.mat')

% Save parameters
cd(strcat('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\',ani_time_name)); 
save(strcat('T1map_air_',animal_name,'_para.mat'),'T1_est_air');
save(strcat('T1map_O2_',animal_name,'_para.mat'),'T1_est_O2');

save(strcat('T2map_air_',animal_name,'_para.mat'),'T2_est_air');
save(strcat('T2map_O2_',animal_name,'_para.mat'),'T2_est_O2');


%Get T1map and T2*map
% load('T1map_air_M3_para.mat');
% load('T2map_air_M3_para.mat');
% load('T1map_O2_M3_para.mat');
% load('T2map_O2_M3_para.mat');

T2sub = T2_est_air - T2_est_O2; %Subtract, T2*map

% Apply Gaussian Filter only to subtracted image
G_sigma = 0.5;
T2sub_G = imgaussfilt(T2sub,G_sigma);

T2dSI = (T2sub*100)./T2_est_air;

%Visualize T1 and T2* maps
BOLD_vis_estT1T2map(animal_name,ani_time_name,T1_est_air,T1_est_O2,T2_est_air,T2_est_O2);
%toc; 

%% calulate ROI values and plot
cd(strcat('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\',ani_time_name)); 
%{
if (strcmp(time_name,'PreRT'))
    [dist_T2_z1_pre,mean_T2_z1_pre,p_z1_pre] = BOLD_contour(animal_name,time_name,T2sub_G(:,:,1),T2_est_air(:,:,1),'T2_z1');
    [dist_T2_z2_pre,mean_T2_z2_pre,p_z2_pre] = BOLD_contour(animal_name,time_name,T2sub_G(:,:,2),T2_est_air(:,:,2),'T2_z2');
    [dist_T2_z3_pre,mean_T2_z3_pre,p_z3_pre] = BOLD_contour(animal_name,time_name,T2sub_G(:,:,3),T2_est_air(:,:,3),'T2_z3');
elseif (strcmp(time_name,'PostRT_10m'))
    [dist_T2_z1_post_10,mean_T2_z1_post_10,p_z1_post_10] = BOLD_contour(animal_name,time_name,T2sub_G(:,:,1),T2_est_air(:,:,1),'T2_z1');
    [dist_T2_z2_post_10,mean_T2_z2_post_10,p_z2_post_10] = BOLD_contour(animal_name,time_name,T2sub_G(:,:,2),T2_est_air(:,:,2),'T2_z2');
    [dist_T2_z3_post_10,mean_T2_z3_post_10,p_z3_post_10] = BOLD_contour(animal_name,time_name,T2sub_G(:,:,3),T2_est_air(:,:,3),'T2_z3');
elseif (strcmp(time_name,'PostRT_30m'))
    [dist_T2_z1_post_30,mean_T2_z1_post_30,p_z1_post_30] = BOLD_contour(animal_name,time_name,T2sub_G(:,:,1),T2_est_air(:,:,1),'T2_z1');
    [dist_T2_z2_post_30,mean_T2_z2_post_30,p_z2_post_30] = BOLD_contour(animal_name,time_name,T2sub_G(:,:,2),T2_est_air(:,:,2),'T2_z2');
    [dist_T2_z3_post_30,mean_T2_z3_post_30,p_z3_post_30] = BOLD_contour(animal_name,time_name,T2sub_G(:,:,3),T2_est_air(:,:,3),'T2_z3');
else
    return;
end

save(strcat('Dist_T2sub_',animal_name,'_',time_name,'.mat'));
%}

if (strcmp(time_name,'PreRT'))
    [p_z1,b_z1] = BOLD_contour2(T2dSI(:,:,1),T2_est_air(:,:,1),'T2_z1');
    [p_z2,b_z2] = BOLD_contour2(T2dSI(:,:,2),T2_est_air(:,:,2),'T2_z2');
    [p_z3,b_z3] = BOLD_contour2(T2dSI(:,:,3),T2_est_air(:,:,3),'T2_z3');
elseif (strcmp(time_name,'PostRT_10m'))
    [p_z1,b_z1] = BOLD_contour2(T2dSI(:,:,1),T2_est_air(:,:,1),'T2_z1');
    [p_z2,b_z2] = BOLD_contour2(T2dSI(:,:,2),T2_est_air(:,:,2),'T2_z2');
    [p_z3,b_z3] = BOLD_contour2(T2dSI(:,:,3),T2_est_air(:,:,3),'T2_z3');
elseif (strcmp(time_name,'PostRT_30m'))
    cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT_10m');
    load('Position_M3_PostRT_10m.mat');
else
    return;
end

save(strcat('Position_',ani_time_name,'.mat'),'p_z1','p_z2','p_z3','b_z1','b_z2','b_z3');

%% Draw histogram
BOLD_draw_hist;


%% Calculate dSI
cd(strcat('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\',ani_time_name)); 
load(strcat('Position_M3_',time_name,'.mat'));
load('T2map_air_M3_para.mat');
load('T2map_O2_M3_para.mat');
[dSI,tot_dSI] = BOLD_dSI(animal_name,time_name,b_z1,b_z2,b_z3,T2_est_air,T2_est_O2);
save(strcat('dSI_',ani_time_name,'.mat'),'dSI','tot_dSI');

%% Draw dSI
BOLD_draw_dSI