
clear;
clc;
close all;

time_name = 'Andrea'; %'PreRT'or 'PostRT' or 'Post1w' or 'Andrea'


%% C
dirname = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_C_2018';
%dirname=uigetdir; % location of "uncropped" dicom files
tarname = strcat(dirname,'_crop'); %name of target files. In our case, this is usually cropped files.
[new_T,~]=dicom_info_field({'EchoTime','SliceLocation'},dirname);
te=unique(new_T.EchoTime,'stable');
numofslice=length(unique(new_T.SliceLocation));
data=dicomread_dir(tarname);
data=reshape(data,size(data,1),size(data,2),length(te),[]);

[t2map,S0map,kmap]=make_many_t2maps_Andr(data,te);
t2map=reshape(t2map,size(t2map,1),size(t2map,2),numofslice,[]);
t2map = permute(t2map,[1,2,4,3]);
S0map=reshape(S0map,size(S0map,1),size(S0map,2),numofslice,[]);
S0map = permute(S0map,[1,2,4,3]);
kmap=reshape(kmap,size(kmap,1),size(kmap,2),numofslice,[]);
kmap = permute(kmap,[1,2,4,3]);
mkdir(strcat(dirname,'\results'))
save(strcat(dirname,'\results\t2map_k'),'t2map','S0map','kmap')

disp('C done')
clear

%% D
dirname = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_D_2018';
%dirname=uigetdir; % location of "uncropped" dicom files
tarname = strcat(dirname,'_crop'); %name of target files. In our case, this is usually cropped files.
[new_T,~]=dicom_info_field({'EchoTime','SliceLocation'},dirname);
te=unique(new_T.EchoTime,'stable');
numofslice=length(unique(new_T.SliceLocation));
data=dicomread_dir(tarname);
data=reshape(data,size(data,1),size(data,2),length(te),[]);

[t2map,S0map,kmap]=make_many_t2maps_Andr(data,te);
t2map=reshape(t2map,size(t2map,1),size(t2map,2),numofslice,[]);
t2map = permute(t2map,[1,2,4,3]);
S0map=reshape(S0map,size(S0map,1),size(S0map,2),numofslice,[]);
S0map = permute(S0map,[1,2,4,3]);
kmap=reshape(kmap,size(kmap,1),size(kmap,2),numofslice,[]);
kmap = permute(kmap,[1,2,4,3]);
mkdir(strcat(dirname,'\results'))
save(strcat(dirname,'\results\t2map_k'),'t2map','S0map','kmap')

disp('D done')
clear

%% E
dirname = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_E_2018';
%dirname=uigetdir; % location of "uncropped" dicom files
tarname = strcat(dirname,'_crop'); %name of target files. In our case, this is usually cropped files.
[new_T,~]=dicom_info_field({'EchoTime','SliceLocation'},dirname);
te=unique(new_T.EchoTime,'stable');
numofslice=length(unique(new_T.SliceLocation));
data=dicomread_dir(tarname);
data=reshape(data,size(data,1),size(data,2),length(te),[]);

[t2map,S0map,kmap]=make_many_t2maps_Andr(data,te);
t2map=reshape(t2map,size(t2map,1),size(t2map,2),numofslice,[]);
t2map = permute(t2map,[1,2,4,3]);
S0map=reshape(S0map,size(S0map,1),size(S0map,2),numofslice,[]);
S0map = permute(S0map,[1,2,4,3]);
kmap=reshape(kmap,size(kmap,1),size(kmap,2),numofslice,[]);
kmap = permute(kmap,[1,2,4,3]);
mkdir(strcat(dirname,'\results'))
save(strcat(dirname,'\results\t2map_k'),'t2map','S0map','kmap')

disp('E done')
clear


%% F
dirname = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_F_2018';
%dirname=uigetdir; % location of "uncropped" dicom files
tarname = strcat(dirname,'_crop'); %name of target files. In our case, this is usually cropped files.
[new_T,~]=dicom_info_field({'EchoTime','SliceLocation'},dirname);
te=unique(new_T.EchoTime,'stable');
numofslice=length(unique(new_T.SliceLocation));
data=dicomread_dir(tarname);
data=reshape(data,size(data,1),size(data,2),length(te),[]);

[t2map,S0map,kmap]=make_many_t2maps_Andr(data,te);
t2map=reshape(t2map,size(t2map,1),size(t2map,2),numofslice,[]);
t2map = permute(t2map,[1,2,4,3]);
S0map=reshape(S0map,size(S0map,1),size(S0map,2),numofslice,[]);
S0map = permute(S0map,[1,2,4,3]);
kmap=reshape(kmap,size(kmap,1),size(kmap,2),numofslice,[]);
kmap = permute(kmap,[1,2,4,3]);
mkdir(strcat(dirname,'\results'))
save(strcat(dirname,'\results\t2map_k'),'t2map','S0map','kmap')

disp('F done')
clear


%% G
dirname = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_G_2018';
%dirname=uigetdir; % location of "uncropped" dicom files
tarname = strcat(dirname,'_crop'); %name of target files. In our case, this is usually cropped files.
[new_T,~]=dicom_info_field({'EchoTime','SliceLocation'},dirname);
te=unique(new_T.EchoTime,'stable');
numofslice=length(unique(new_T.SliceLocation));
data=dicomread_dir(tarname);
data=reshape(data,size(data,1),size(data,2),length(te),[]);

[t2map,S0map,kmap]=make_many_t2maps_Andr(data,te);
t2map=reshape(t2map,size(t2map,1),size(t2map,2),numofslice,[]);
t2map = permute(t2map,[1,2,4,3]);
S0map=reshape(S0map,size(S0map,1),size(S0map,2),numofslice,[]);
S0map = permute(S0map,[1,2,4,3]);
kmap=reshape(kmap,size(kmap,1),size(kmap,2),numofslice,[]);
kmap = permute(kmap,[1,2,4,3]);
mkdir(strcat(dirname,'\results'))
save(strcat(dirname,'\results\t2map_k'),'t2map','S0map','kmap')

disp('G done')
clear
clc