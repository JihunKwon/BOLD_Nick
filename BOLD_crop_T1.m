function []=BOLD_crop_T1(dirname,time_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 10/10/2018 by Jihun Kwon
% this code crops initial figure to make it square
% Email: jkwon@bwh.harvard.edu 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dirname_crop = strcat(dirname,'_crop');

len = 150; %60
if strcmp(time_name,'PreRT')
    x_init = 120;%100
    y_init = 40;
else
    x_init = 165;
    y_init = 67;
end

num_of_files = dir([dirname '/*.dcm']);
num_max = size(num_of_files,1);

for i=1:num_max
    sname = sprintf('MRIm%02d.dcm',i);
    fname = fullfile(dirname, sname);
    [X] = dicomread(fname);
    info = dicominfo(fname);
    %imshow(X); %Check whether tumor is in the ROI.
    caxis([0 3000]);
    %set(gca,'dataAspectRatio',[1 1 1]); axis off;
    
%     x_new = size(X,1)/2; %192/2=96
    X_crop = X(x_init:x_init+len,y_init:y_init+len);
    %imshow(X_crop); %Check whether tumor is in the ROI.
    caxis([0 3000]);
    fname_new = sprintf('MRIc%02d.dcm',i);
    
    %No need for this because header info is overlayed eventually anyway.
    %info_new = dicominfo(fname_new);
    cd(dirname_crop);
    dicomwrite(X_crop, fname_new, info);
    if rem(i,50)==0
        str = num2str(i);
        disp(str);
    end
    
end
end