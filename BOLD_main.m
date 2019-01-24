%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.4
% modified on 1/17/2019 by Jihun Kwon
% Estimate T2*map, dynamic BOLD, TOLD T2*map
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;

animal_name = 'M4'; %Different with other past animals, M4 is our first animal which we did 'dynamic' imaging.
time_name = 'Andrea_B'; %'PreRT'or 'PostRT' or 'Post1w' or 'Andrea_B' or 'Andrea_C', ...
ani_time_name = strcat(animal_name,'_',time_name);

%Define file locations depending on the 'time_name'
if (strcmp(time_name,'PreRT'))
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\';
    out_dir_1 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\T2_dynamic_crop_G1_L';
    out_dir_t1_05 = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\T2_dynamic_crop_T1large';
elseif (strcmp(time_name,'PostRT'))
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26';
elseif (strcmp(time_name,'Post1w'))
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181206_111438_Berbeco_Bi_Gd_1_27';
elseif strcmp(time_name,'Andrea_B')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018';
elseif strcmp(time_name,'Andrea_C')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_C_2018';
elseif strcmp(time_name,'Andrea_D')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_D_2018';
elseif strcmp(time_name,'Andrea_E')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_E_2018';
elseif strcmp(time_name,'Andrea_F')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_F_2018';
elseif strcmp(time_name,'Andrea_G')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_G_2018';
else
    return;
end

base_name_new = strcat(base_name,'\T2_dynamic'); %store result here (standard)
crop_name = strcat(base_name,'\T2_dynamic_crop'); %store result for cropped image analysis
out_dir_05 = strcat(base_name,'\T2_dynamic_crop_G05'); %store result for cropped and Gaussian filtered image analysis

%% This part is just preparation before estimating T2* values. 
%If you've already done the pre-processing, just go to the "Estimate T2* map" part.

%**Integrate files**
%For some reasosns, our MRI data from SAIL is separated to different folders.
%This function bellow integrates them to one folder and rename them in order.
%Run this function only when you analyze the image for the first time.
%**************************************
%integrate_files(base_name,animal_name,time_name)
%cd(base_name_new)

%**Crop files**
%If we estimate T2* values of entire image, it will take a few weeks on my
%desktop. This function bellow crops images to tumor region to speed up (still 
%takes about a half day).
%**************************************
BOLD_crop(base_name_new,time_name); %For mouse GBM
%BOLD_crop(base_name_new,time_name); %For subcutaneous

%**Smoothing images**
%Before estimating T2*, apply Gaussian filter. The last variable is the
%"sigma" in the Gaussian filter. Bigger is the stronger filtering.
%**************************************
BOLD_Gaussian(crop_name,out_dir_05,0.5);

%% Estimate T2* map
%This function is the core of our analysis. This estimates T2* value and 
%save to 't2map.mat'. Also let us contour the image.
%T2* values will be saved to "dT2star.mat".
%**************************************
T2map_analysis_dicom_my;

%% Post Processing 
%**T2* relative change map**
%make sure you have correct 't2map' variable. If not, do "load('t2map.mat')"
%under the appropriate folder.
%**************************************
BOLD_overlay_t2sub_rel(t2map, base_name, animal_name, time_name);

%**Dynamic TOLD**
%TOLD signal will be saved to "TOLD.mat" 
%**************************************
BOLD_getTOLD(animal_name, time_name, numofrois);

%**Dynamic BOLD**
%This function shows dynamic curve of T2*, TOLD and BOLD all together. BOLD
%signal will be saved to "BOLD.mat". The last "si" in the name of this
%function emphasize that the BOLD signal is signal intensity of raw image.
%**************************************
BOLD_getBOLDsi(animal_name, time_name, numofrois);

%% Overlay thresholded image with raw images
BOLD_Andr_slope(t2map, base_name, animal_name, time_name); %Threshold slope map and overlay with raw image
BOLD_Andr_SNR(t2map, base_name, animal_name, time_name); %Threshold SNR map and overlay with raw image
BOLD_Andr_getBOLDsi(t2map, base_name, animal_name, time_name); %Threshold BOLD map and overlay with raw image