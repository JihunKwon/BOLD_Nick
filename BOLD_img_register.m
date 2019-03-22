%function []=BOLD_img_register(dirname,time_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/19/2018 by Jihun Kwon
% this function registers images. Assuming we have multiple TE with multiple 
% timepoints, this function registers all dicom image to an image with first 
% timepoint, second TE. (because first TE image is not very clear) 
% Email: jkwon@bwh.harvard.edu 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
dirname_tr = strcat(dirname,'_tr');
te_target = 10; %Set until which TE you want to register. Longer TE should be difficult to register.
te_fix = 2; %In this case, we chose second TE as a reference.
te_max = 15;
z_max = 3;

[optimizer,metric] = imregconfig('multimodal');
optimizer.InitialRadius = optimizer.InitialRadius/3.5;
optimizer.MaximumIterations = 300;

% Move to the folder contains images you want to register
cd(dirname)

%% Get fixed images for each slice.
num_of_files = dir([dirname '/*.dcm']);
file_max = size(num_of_files,1);
tp_max = file_max / te_max / z_max;

for z = 1:3
    num = te_fix+(15*(z-1));
    sname_fix = sprintf('MRIc%04d.dcm',num);
    fname_fix = fullfile(dirname, sname_fix);
    [fixed] = dicomread(fname_fix);
    fixed_all(:,:,z) = fixed;
end

%% Get Transformation matrix for each slice
count = 1;
Rfixed = imref2d(size(fixed_all(:,:,1))); %always same
for tp = 1:tp_max
    for z = 1:z_max
        for te = 1:te_max
            if te==te_fix
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(dirname, sname);
                moving = dicomread(fname);
                %imshowpair(fixed_all(:,:,z), moving, 'Scaling', 'joint');
                tformSimilarity(tp,z) = imregtform(moving,fixed_all(:,:,z),'similarity',optimizer,metric);
            end
            count = count + 1;
        end
    end
end

save(strcat('tForm_para.mat'),'tformSimilarity');
%}
%% Move images
%Method1: move only te=7 and apply same transformation matrix to the rest
%of the TEs.
cd(dirname)
count = 1;
for tp = 1:tp_max
    for z = 1:z_max
        for te = 1:te_max
            %if tp>1
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(dirname, sname);
                moving = dicomread(fname);
                if te == 2
                    figure;
                    imshowpair(fixed_all(:,:,z), moving, 'Scaling', 'joint');
                end

                movingRegisteredRigid = imwarp(moving,tformSimilarity(tp,z),'OutputView',Rfixed);
                if te == 2
                    figure;
                    imshowpair(movingRegisteredRigid, fixed_all(:,:,z))
                end

                sname = sprintf('MRItr%04d.dcm',count);
                cd(dirname_tr);
                dicomwrite(movingRegisteredRigid, sname);
                cd(dirname);
            %end
            count = count + 1;
        end
    end
end

%% Registration test
%{
fixed_test = dicomread('MRIc0002.dcm');
moving_test = dicomread('MRIc0452.dcm');

figure;
imshowpair(moving_test,fixed_test);
title('Unregistered');

[optimizer,metric] = imregconfig('multimodal');

optimizer.InitialRadius = optimizer.InitialRadius/3.5;
optimizer.MaximumIterations = 300;

tformSimilarity = imregtform(moving_test,fixed_test,'similarity',optimizer,metric);
Rfixed = imref2d(size(fixed_test));

movingRegisteredRigid = imwarp(moving_test,tformSimilarity,'OutputView',Rfixed);
figure;
imshowpair(movingRegisteredRigid, fixed_test)
title('D: Registration Based on Similarity Transformation Model')
%}



