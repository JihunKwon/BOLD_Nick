function [dSI_si,tot_dSI_si] = BOLD_dSI_si(animal_name,time_name,b_z1,b_z2,b_z3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/17/2018 by Jihun Kwon
% Calculate dSI pixel-by-pixel
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
margins = [.007 .007];
cb_dSI_si = [-5 15];
cb_dSI_si_0 = [0 20];
I_air = zeros(61,61,3);
I_O2 = zeros(61,61,3);

view = 50;
if strcmp(time_name,'PreRT')
    init_x = 45;
    init_y = 55;
else %'M3_PostRT'
    init_x = 38;
    init_y = 73;
end

%% Import images of TE=39ms (10.dcm, 25.dcm, 40.dcm)
if strcmp(time_name, 'PreRT')
    cd('C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_PreRT\2_crop_G1'); %Check There images!!
    [I_air_z1] = dicomread('MRIc03.dcm');
    [I_air_z2] = dicomread('MRIc18.dcm');
    [I_air_z3] = dicomread('MRIc33.dcm');
    
    cd('C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_PreRT\4_crop_G1');
    [I_O2_z1] = dicomread('MRIc03.dcm');
    [I_O2_z2] = dicomread('MRIc18.dcm');
    [I_O2_z3] = dicomread('MRIc33.dcm');
    
elseif strcmp(time_name, 'PostRT_10m')
    cd('C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_PostRT_10m\2_crop_G1');
    [I_air_z1] = dicomread('MRIc03.dcm');
    [I_air_z2] = dicomread('MRIc18.dcm');
    [I_air_z3] = dicomread('MRIc33.dcm');
    
    cd('C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_PostRT_10m\4_crop_G1');
    [I_O2_z1] = dicomread('MRIc03.dcm');
    [I_O2_z2] = dicomread('MRIc18.dcm');
    [I_O2_z3] = dicomread('MRIc33.dcm');
    
elseif strcmp(time_name, 'PostRT_30m')
    cd('C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_PostRT_10m\2_crop_G1'); %Use same image with 10min
    [I_air_z1] = dicomread('MRIc03.dcm');
    [I_air_z2] = dicomread('MRIc18.dcm');
    [I_air_z3] = dicomread('MRIc33.dcm');
    
    cd('C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_PostRT_30m\4_crop_G1');
    [I_O2_z1] = dicomread('MRIc03.dcm');
    [I_O2_z2] = dicomread('MRIc18.dcm');
    [I_O2_z3] = dicomread('MRIc33.dcm');
else
    disp('no such file!');
    return;
end

cd(strcat('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\',animal_name,'_',time_name));

%% Apply Tumor ROI to image
b_z1 = double(b_z1); b_z1(b_z1 == 0) = NaN;
b_z2 = double(b_z2); b_z2(b_z2 == 0) = NaN;
b_z3 = double(b_z3); b_z3(b_z3 == 0) = NaN;

I_air(:,:,1) = double(I_air_z1) .* b_z1;
I_air(:,:,2) = double(I_air_z2) .* b_z2;
I_air(:,:,3) = double(I_air_z3) .* b_z3;

I_O2(:,:,1) = double(I_O2_z1) .* b_z1;
I_O2(:,:,2) = double(I_O2_z2) .* b_z2;
I_O2(:,:,3) = double(I_O2_z3) .* b_z3;

vol_air = [0 0 0]; vol_O2 = [0 0 0];
sum_air = [0 0 0]; sum_O2 = [0 0 0];
ave_air = [0 0 0]; ave_O2 = [0 0 0];

[nr,nc] = size(b_z1(:,:));
% nr = view+1;
% nc = view+1;
dSI_si = NaN(size(I_air,1), size(I_air,2), size(I_air,3));

%% Calculate dSI from signal intensity of the raw images
for k=1:size(I_air,3)
    for j=1:size(I_air,2)
        for i=1:size(I_air,1)

            %Air
            if (~isnan(I_air(i,j,k)) && (I_air(i,j,k) ~= 0)) %neither Nan or zero
                vol_air(k) = vol_air(k) + 1;
                sum_air(k) = sum_air(k) + I_air(i,j,k);
            end

            %O2
            if (~isnan(I_O2(i,j,k)) && (I_O2(i,j,k) ~= 0)) %neither Nan or zero
                vol_O2(k) = vol_O2(k) + 1;
                sum_O2(k) = sum_O2(k) + I_O2(i,j,k);
            end

            %Calculate dSI
            %if (T2_air is neither nan or zero) and (T2_O2 is neither nan or zero)
            if ((~isnan(I_air(i,j,k)) && (I_air(i,j,k) ~= 0)) && (~isnan(I_O2(i,j,k)) && (I_O2(i,j,k) ~= 0)))
                dSI_si(i,j,k) = 100*(I_O2(i,j,k) - I_air(i,j,k)) / I_air(i,j,k);
            end
        end
    end
end

ave_air = sum_air./vol_air;
ave_O2 = sum_O2./vol_O2;

for l=1:size(I_air,3)
    tot_dSI_si(l) = 100*(ave_O2(l)-ave_air(l)) / ave_air(l);
end

%dSI_new_si = dSI_si(init_x:init_x+view,init_y:init_y+view,:);
dSI_new_si = dSI_si;

figure(1);
subplot_tight(1,3,1,margins); pcolor([flip2y(dSI_new_si(:,:,1)) nan(nr,1); nan(1,nc+1)]); pbaspect([1 1 1]);
shading flat; title('\DeltaSI,%), z1'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_si,'xtick',[],'ytick',[]);
subplot_tight(1,3,2,margins), pcolor([flip2y(dSI_new_si(:,:,2)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]); 
shading flat; title('\DeltaSI(%), z2'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_si,'xtick',[],'ytick',[]);
subplot_tight(1,3,3,margins), pcolor([flip2y(dSI_new_si(:,:,3)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]);
shading flat; title('\DeltaSI(%), z3'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_si,'xtick',[],'ytick',[]);
saveas(gcf,strcat('dSI_SI_',animal_name,time_name,'_noback.pdf'));
set(gcf, 'Color', 'w');
export_fig dSI_SImap_G1_TE11ms.tiff -q101

figure(2);
subplot_tight(1,3,1,margins); pcolor([flip2y(dSI_new_si(:,:,1)) nan(nr,1); nan(1,nc+1)]); pbaspect([1 1 1]);
shading flat; title('\DeltaSI(%), z1'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_si_0,'xtick',[],'ytick',[]);
subplot_tight(1,3,2,margins), pcolor([flip2y(dSI_new_si(:,:,2)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]); 
shading flat; title('\DeltaSI(%), z2'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_si_0,'xtick',[],'ytick',[]);
subplot_tight(1,3,3,margins), pcolor([flip2y(dSI_new_si(:,:,3)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]);
shading flat; title('\DeltaSI(%), z3'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_si_0,'xtick',[],'ytick',[]);
saveas(gcf,strcat('dSI_SI_',animal_name,time_name,'_noback_0.pdf'));

end