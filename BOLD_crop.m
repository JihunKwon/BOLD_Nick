function []=BOLD_crop(dirname,time_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 10/10/2018 by Jihun Kwon
% this code crops initial figure to make it square
% Email: jkwon@bwh.harvard.edu 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dirname_crop = strcat(dirname,'_crop');

len = 60; %60 %Brain:130
if strcmp(time_name,'PreRT')
    x_init = 100;%70 for L
    y_init = 70;%55 for L
elseif strcmp(time_name,'PostRT')
    x_init = 100;
    y_init = 70;
elseif strcmp(time_name,'Post1w')
    x_init = 100;
    y_init = 70;
elseif strcmp(time_name,'Post2w')
    %Brain
%     x_init = 10;
%     y_init = 30;
    %Tumor
    x_init = 60;
    y_init = 60;
end

num_of_files = dir([dirname '/*.dcm']);
num_max = size(num_of_files,1);

for i=1:num_max
    sname = sprintf('MRIm%04d.dcm',i);
    fname = fullfile(dirname, sname);
    [X] = dicomread(fname);
    %info = dicominfo(fname);
    %imshow(X); %Check whether tumor is in the FOV.
    
    X_crop = X(x_init:x_init+len,y_init:y_init+len);
    %imshow(X_crop); %Check whether tumor is in the FOV.
    fname_new = sprintf('MRIc%04d.dcm',i);
    
    cd(dirname_crop);
    dicomwrite(X_crop, fname_new);
    if rem(i,50)==0
        str = num2str(i);
        disp(str);
    end
end