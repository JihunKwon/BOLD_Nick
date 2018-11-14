function BOLD_Gaussian(in_dir,out_dir,sigma)
%base_new: original dir, in_dir: input dir (cropped dcm), out_dir: output
%dir. sigma: sigma value of gaussian filter.

for i=1:45
    cd(in_dir)
    fdcm_pre = sprintf('MRIc%02d.dcm', i);
    fname = fullfile(in_dir, fdcm_pre);
    [X] = dicomread(fname);
    info = dicominfo(fname);
    
    Y1 = imgaussfilt(X,sigma);
    fdcm_1 = sprintf('MRIc%02d.dcm', i);
    cd(out_dir)
    dicomwrite(Y1, fdcm_1, info);

end