%function []=BOLD_crop(dirname,time_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 10/10/2018 by Jihun Kwon
% this code crops initial figure to make it square
% Email: jkwon@bwh.harvard.edu 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dirname_crop = strcat(dirname,'_crop_G1_L');

len = 60; %120
if strcmp(time_name,'PreRT')
    x_init = 100;%70 for L
    y_init = 70;%55 for L
elseif strcmp(time_name,'PostRT')
    x_init = 100;
    y_init = 70;
elseif strcmp(time_name,'Post1w')
    x_init = 100;
    y_init = 70;
end

num_of_files = dir([dirname '/*.dcm']);
num_max = size(num_of_files,1);

for i=1:num_max
    sname = sprintf('MRIm%04d.dcm',i);
    fname = fullfile(dirname, sname);
    [X] = dicomread(fname);
    %info = dicominfo(fname);
    %imshow(X); %Check whether tumor is in the ROI.
    %set(gca,'dataAspectRatio',[1 1 1]); axis off;
    
%     x_new = size(X,1)/2; %192/2=96
    X_crop = X(x_init:x_init+len,y_init:y_init+len);
    %imshow(X_crop); %Check whether tumor is in the ROI.
    fname_new = sprintf('MRIc%04d.dcm',i);
    
    %No need for this because header info is overlayed eventually anyway.
    %info_new = dicominfo(fname_new);
    cd(dirname_crop);
%    dicomwrite(X_crop, fname_new, info);
    dicomwrite(X_crop, fname_new);
    if rem(i,50)==0
        str = num2str(i);
        disp(str);
    end
    
end