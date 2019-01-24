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
x_init = 30;
y_init = 60;

for i=1:1875
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