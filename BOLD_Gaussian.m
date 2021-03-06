function BOLD_Gaussian(in_dir,out_dir,sigma)
%base_new: original dir, in_dir: input dir (cropped dcm), out_dir: output
%dir. sigma: sigma value of gaussian filter.

num_of_files = dir([in_dir '/*.dcm']);
num_max = size(num_of_files,1);
for i=1:num_max
    cd(in_dir)
    fdcm_pre = sprintf('MRIc%04d.dcm', i);
    %fdcm_pre = sprintf('MRItr%04d.dcm', i);
    fname = fullfile(in_dir, fdcm_pre);
    [X] = dicomread(fname);
    info = dicominfo(fname);
    
    Y1 = imgaussfilt(X,sigma);
    fdcm_1 = sprintf('MRIc%04d.dcm', i);
    %fdcm_1 = sprintf('MRItrG%04d.dcm', i);
    cd(out_dir)
    dicomwrite(Y1, fdcm_1, info);

end