%function []=BOLD_norm_dcm(crop,time_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 10/10/2018 by Jihun Kwon
% This function normalized the dicom value by the highest pixel value of
% the second shortest TE image (TE=7ms)
% Email: jkwon@bwh.harvard.edu 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
crop = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\T2_dynamic_crop';
dirname_crop = strcat(crop,'_norm');

cd(dirname_crop);
count = 0;
for tp=1:11
    for z=1:3
        for te=1:15
            count = count + 1;
            if te>1
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(crop, sname);
                I = dicomread(fname);

                if te==2
                    Imax = max(max(I));
                end

                I_norm = double(I)/double(Imax);
                fname_new = sprintf('MRIn%04d.dcm',count);
                dicomwrite(I_norm, fname_new);
            end
        end
    end
end

%{


for i=1:495
    sname = sprintf('MRIc%04d.dcm',i);
    fname = fullfile(crop, sname);
    [I] = dicomread(fname);
    info = dicominfo(fname);
    imshow(I); %Check whether tumor is in the ROI.
    %set(gca,'dataAspectRatio',[1 1 1]); axis off;
    
%     x_new = size(X,1)/2; %192/2=96
    X_crop = I(x_init:x_init+len,y_init:y_init+len);
    imshow(X_crop); %Check whether tumor is in the ROI.
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
%}