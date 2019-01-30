%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.4
% modified on 1/17/2019 by Jihun Kwon
% Estimate T2*map, dynamic BOLD, TOLD T2*map
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;

animal_name = 'B'; %ex: A,B,C, ...
time_name = 'Control_1w'; %Either 'Chemo_2w', 'Control_1w' or 'Control_2w'
ani_time_name = strcat(animal_name,'_',time_name);

%Define file locations depending on the 'time_name'
if strcmp(animal_name,'B') && strcmp(time_name,'Chemo_2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018';
elseif strcmp(animal_name,'C') && strcmp(time_name,'Chemo_2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_C_2018';
elseif strcmp(animal_name,'D') && strcmp(time_name,'Chemo_2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_D_2018';
elseif strcmp(animal_name,'E') && strcmp(time_name,'Chemo_2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_E_2018';
elseif strcmp(animal_name,'F') && strcmp(time_name,'Chemo_2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_F_2018';
elseif strcmp(animal_name,'G') && strcmp(time_name,'Chemo_2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_G_2018';
%Here next set of experiments begins. Control 1 week
elseif strcmp(animal_name,'A') && strcmp(time_name,'Control_1w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20190125_Andrea\01-18-2019\BOLD_A_2019';
elseif strcmp(animal_name,'B') && strcmp(time_name,'Control_1w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20190125_Andrea\01-18-2019\BOLD_B_2019';
elseif strcmp(animal_name,'C') && strcmp(time_name,'Control_1w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20190125_Andrea\01-18-2019\BOLD_C_2019';
%Control 2 week
elseif strcmp(animal_name,'A') && strcmp(time_name,'Control_2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20190125_Andrea\01-25-2019\BOLD_A_2019_2';
elseif strcmp(animal_name,'B') && strcmp(time_name,'Control_2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20190125_Andrea\01-25-2019\BOLD_B_2019_2';
elseif strcmp(animal_name,'C') && strcmp(time_name,'Control_2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20190125_Andrea\01-25-2019\BOLD_C_2019_2';
else
    return;
end

cd(base_name)
[~,name] = fileparts(base_name); %Get name of current folder

%Not sure if we use all of these folders, but make them all at once just in case
base_name_new = strcat(name,'\T2_dynamic'); %store result here (standard)
crop_name = strcat(name,'_crop'); %store result for cropped image analysis
out_dir_05 = strcat(name,'_crop_G05'); %store result for cropped and Gaussian filtered image analysis

cd(base_name);
cd ..
mkdir(crop_name); cd(crop_name) 
crop_name_path = pwd;
cd ..
mkdir(out_dir_05); cd(out_dir_05);
out_dir_05_path = pwd;
cd(base_name)
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
BOLD_crop_Andr(base_name); %For mouse GBM
%BOLD_crop(base_name_new,time_name); %For subcutaneous

%**Smoothing images**
%Before estimating T2*, apply Gaussian filter. The last variable is the
%"sigma" in the Gaussian filter. Bigger is the stronger filtering.
%**************************************
BOLD_Gaussian(crop_name_path,out_dir_05_path,0.5);

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