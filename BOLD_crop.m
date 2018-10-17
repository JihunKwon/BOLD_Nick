function []=BOLD_crop(dirname,dirname_crop)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 10/10/2018 by Jihun Kwon
% this code crops initial figure to make it square
% Email: jkwon@bwh.harvard.edu 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For Nick's data
len = 191; %192/2=96
x_init = 65;
y_init = 1;
for i=1:45
    sname = sprintf('MRIm%02d.dcm',i);
    fname = fullfile(dirname, sname);
    [X, map] = dicomread(fname);
    %imshow(X); %Check whether tumor is in the ROI.
    %set(gca,'dataAspectRatio',[1 1 1]); axis off;
    
%     x_new = size(X,1)/2; %192/2=96
    X_crop = X(x_init:x_init+len,y_init:y_init+len);
    imshow(X_crop); %Check whether tumor is in the ROI.
    fname_new = sprintf('MRIc%02d.dcm',i);
    
    %No need for this because header info is overlayed eventually anyway.
    %info_new = dicominfo(fname_new);
    cd(dirname_crop);
    dicomwrite(X_crop, fname_new);
end