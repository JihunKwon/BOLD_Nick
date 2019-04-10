function []=BOLD_crop_Andr(dirname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 11/12/2018 by Jihun Kwon
% this code crops initial figure to make calculation efficient.
% Email: jihun.k@frontier.hokudai.ac.jp
% Note: running directory has to be the output folder of new (cropped) dicom file. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load data and header information

%dirname=uigetdir; % location of dicom files
dirname_crop = strcat(dirname,'_crop');
% For Andrea's data
len = 96;
% x_init = 30;
% y_init = 60;

x_init = 30;
<<<<<<< HEAD
y_init = 60;
=======
y_init = 50;
>>>>>>> e4b6b6fb7462d07e7a4291cede3b5eeaef9c2236

num_of_files = dir([dirname '/*.dcm']);
num_max = size(num_of_files,1);

%% Raw images cropping
for i=1:num_max %1875 or 1500
    sname = sprintf('MRIm%04d.dcm',i);
    fname = fullfile(dirname, sname);
    [X] = dicomread(fname);
    info = dicominfo(fname); %Extract dicom_info
    %imshow(X); %Check whether tumor is in the ROI.
    
    X_crop = X(x_init:x_init+len,y_init:y_init+len);
    %imshow(X_crop); %Check whether tumor is in the ROI.
    fname_new = sprintf('MRIc%04d.dcm',i);
    
    %No need for this because header info is overlayed eventually anyway.
    %info_new = dicominfo(fname_new);
    cd(dirname_crop);
    dicomwrite(X_crop, fname_new, info);
    if rem(i,50)==0
        str = num2str(i);
        disp(str);
    end
end


%% Turbo images cropping. If you contour on Turbo.
dirname_turbo = strcat(dirname,'_Turbo');
dirname_turbo_crop = strcat(dirname,'_Turbo_crop');
for i=1:29
    sname = sprintf('MRIm%02d.dcm',i);
    fname = fullfile(dirname_turbo, sname);
    [X] = dicomread(fname);
    info = dicominfo(fname); %Extract dicom_info
    %imshow(X); %Check whether tumor is in the ROI.
    
    X_crop = X(x_init:x_init+len,y_init:y_init+len);
    %imshow(X_crop); %Check whether tumor is in the ROI.
    fname_new = sprintf('MRIc%02d.dcm',i);
    
    %No need for this because header info is overlayed eventually anyway.
    %info_new = dicominfo(fname_new);
    cd(dirname_turbo_crop);
    dicomwrite(X_crop, fname_new, info);
end
