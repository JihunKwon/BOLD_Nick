%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 12/07/2018 by Jihun Kwon
% Check fitting quality of T2* analysis.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

animal_name = 'M4';
time_name = 'PreRT'; %'PreRT'or 'PostRT' or 'Post1w'
ani_time_name = strcat(animal_name,'_',time_name);
TEs = [3 7 11 15 19 23 27 31 35 39 43 47 51 55 59]; %TR = 600

if strcmp(time_name,'PreRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\';
    base_crop = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\T2_dynamic_crop_G05';
    target_dir = [17 18 19 20 21 23 26 28 29 30 31];
    tp_max = 11; z_max = 3; te_max = 15;
elseif strcmp(time_name,'PostRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\';
    target_dir = [8 9 11 12 13 14 15 16 17 18 20];
    tp_max = 11; z_max = 3; te_max = 15;
elseif strcmp(time_name,'Post1w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181206_111438_Berbeco_Bi_Gd_1_27\';
    target_dir = [6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21];
    tp_max = 16; z_max = 3; te_max = 15;
end

cd(base_name)
cd T2_dynamic\results
load('t2map_k.mat')

cd(base_crop)

%Chose pixel you want to check.
SI_L = zeros(1,size(target_dir,2));
SI_R = zeros(1,size(target_dir,2));
Sfit_L = zeros(1,size(target_dir,2));
Sfit_R = zeros(1,size(target_dir,2));
%Left tumor
X_L = 20-3;
Y_L = 29+30;
%Right tumor
X_R = 37-3;
Y_R = 30+30;

pix_L = [Y_L, X_L];
pix_R = [Y_R, X_R];

tp = 1;
z = 1;
for te = 1:te_max
    f_num = (tp-1)*(te_max*z_max)+(z-1)*te_max+te;
    sname = sprintf('MRIc%04d.dcm',f_num);
    fname = fullfile(base_crop, sname);
    [I] = dicomread(fname);
    %imagesc(I); colormap gray; set(gca,'dataAspectRatio',[1 1 1]); axis off;
    SI_L(te) = I(Y_L, X_L);
    SI_R(te) = I(Y_R, X_R);
end

x = 1:0.1:60;
Sfit_L = S0map(Y_L,X_L,tp,z)*exp(-x/t2map(Y_L,X_L,tp,z))+kmap(Y_L,X_L,tp,z);
Sfit_R = S0map(Y_R,X_R,tp,z)*exp(-x/t2map(Y_R,X_R,tp,z))+kmap(Y_R,X_R,tp,z);

figure;
plot(x,Sfit_L); hold on;
plot(TEs, SI_L(:), 'o');
title('Left Tumor'); xlabel('TE (ms)'); ylabel('Signal Intensity');
saveas(gcf,strcat('BOLD_fit_Left.tif'))

figure;
plot(x,Sfit_R); hold on;
plot(TEs, SI_R(:), 'o');
title('Right Tumor'); xlabel('TE (ms)'); ylabel('Signal Intensity');
saveas(gcf,strcat('BOLD_fit_Right.tif'))