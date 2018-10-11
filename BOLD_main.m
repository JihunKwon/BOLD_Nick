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
base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\';
base_name = strcat(base_name,animal_name,'\');
cd(base_name);
%Folder dir. 1:air T1wI, 2:air T2*wI, 3:O2 T1wI, 4:O2 T2*wI
for i=1:4 %i=1;
    %Mouse 3
    TR = [100 150 300 500 1000 2000 3000 5000 8000]; nSlices = 3; nTRs = 9;
    
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
 
% Save parameters
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map');
save(strcat('T1map_air_',animal_name,'_para.mat'),'T1_est_air');
save(strcat('T1map_O2_',animal_name,'_para.mat'),'T1_est_O2');

cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map');
save(strcat('T2map_air_',animal_name,'_para.mat'),'T2_est_air');
save(strcat('T2map_O2_',animal_name,'_para.mat'),'T2_est_O2');

%Visualize T1 and T2* maps
BOLD_vis_estT1T2map(animal_name);
toc;