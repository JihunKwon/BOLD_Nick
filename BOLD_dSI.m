function [dT2,dR2,tot_dT2,tot_dR2] = BOLD_dSI(animal_name,time_name,b_z1,b_z2,b_z3,T2_air,T2_O2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/17/2018 by Jihun Kwon
% Calculate dSI pixel-by-pixel
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
margins = [.007 .007];
cb_dSI_0 = [0 40];
cb_dSI = [-40 40];
cb_t2map = [-25 25];
cb_t2map_0 = [0 25];

view = 50;
if strcmp(time_name,'PreRT')
    init_x = 45;
    init_y = 55;
else %'M3_PostRT'
    init_x = 38;
    init_y = 73;
end

[nr,nc] = size(T2_air(:,:,1));
% nr = view+1;
% nc = view+1;

%Convert zero (outside of ROI) to NaN
b_z1 = double(b_z1); b_z1(b_z1 == 0) = NaN;
b_z2 = double(b_z2); b_z2(b_z2 == 0) = NaN;
b_z3 = double(b_z3); b_z3(b_z3 == 0) = NaN;

T2_air_roi(:,:,1) = T2_air(:,:,1) .* b_z1;
T2_air_roi(:,:,2) = T2_air(:,:,2) .* b_z2;
T2_air_roi(:,:,3) = T2_air(:,:,3) .* b_z3;

T2_O2_roi(:,:,1) = T2_O2(:,:,1) .* b_z1;
T2_O2_roi(:,:,2) = T2_O2(:,:,2) .* b_z2;
T2_O2_roi(:,:,3) = T2_O2(:,:,3) .* b_z3;

R2_air_roi(:,:,1) = 1./T2_air_roi(:,:,1);
R2_air_roi(:,:,2) = 1./T2_air_roi(:,:,2);
R2_air_roi(:,:,3) = 1./T2_air_roi(:,:,3);
R2_O2_roi(:,:,1) = 1./T2_O2_roi(:,:,1);
R2_O2_roi(:,:,2) = 1./T2_O2_roi(:,:,2);
R2_O2_roi(:,:,3) = 1./T2_O2_roi(:,:,3);

% figure;
% imshow(T2_air_roi(:,:,1));
vol_air = [0 0 0]; vol_O2 = [0 0 0];
sum_air_t2 = [0 0 0]; sum_O2_t2 = [0 0 0];
ave_air_t2 = [0 0 0]; ave_O2_t2 = [0 0 0];
sum_air_r2 = [0 0 0]; sum_O2_r2 = [0 0 0];
ave_air_r2 = [0 0 0]; ave_O2_r2 = [0 0 0];
tot_dT2 = [0 0 0];
tot_dR2 = [0 0 0];
dT2 = NaN(size(T2_air,1), size(T2_air,2), size(T2_air,3));
dR2 = NaN(size(T2_air,1), size(T2_air,2), size(T2_air,3));
count=0;

for k=1:size(T2_air,3)
    for j=1:size(T2_air,2)
        for i=1:size(T2_air,1)
            
            %Air
            if (~isnan(T2_air_roi(i,j,k)) && (T2_air_roi(i,j,k) ~= 0)) %neither Nan or zero
                vol_air(k) = vol_air(k) + 1;
                sum_air_t2(k) = sum_air_t2(k) + T2_air_roi(i,j,k);
                sum_air_r2(k) = sum_air_r2(k) + R2_air_roi(i,j,k);
                count = count+1;
            end
            
            %O2
            if (~isnan(T2_O2_roi(i,j,k)) && (T2_O2_roi(i,j,k) ~= 0)) %neither Nan or zero
                vol_O2(k) = vol_O2(k) + 1;
                sum_O2_t2(k) = sum_O2_t2(k) + T2_O2_roi(i,j,k);
                sum_O2_r2(k) = sum_O2_r2(k) + R2_O2_roi(i,j,k);
            end
            
            %Calc relative change
            %if (T2_air is neither nan or zero) and (T2_O2 is neither nan or zero)
            if ((~isnan(T2_air_roi(i,j,k)) && (T2_air_roi(i,j,k) ~= 0)) && (~isnan(T2_O2_roi(i,j,k)) && (T2_O2_roi(i,j,k) ~= 0)))
                dT2(i,j,k) = 100*(T2_O2_roi(i,j,k) - T2_air_roi(i,j,k)) / T2_air_roi(i,j,k);
                dR2(i,j,k) = 100*(R2_O2_roi(i,j,k) - R2_air_roi(i,j,k)) / (R2_air_roi(i,j,k));
            end
            
        end
    end
end

ave_air_t2 = sum_air_t2./vol_air;
ave_O2_t2 = sum_O2_t2./vol_O2;
ave_air_r2 = sum_air_r2./vol_air;
ave_O2_r2 = sum_O2_r2./vol_O2;

for l=1:size(T2_air,3)
    tot_dT2(l) = 100*(ave_O2_t2(l)-ave_air_t2(l)) / ave_air_t2(l);
    tot_dR2(l) = 100*(ave_O2_r2(l)-ave_air_r2(l)) / ave_air_r2(l);
end

% dT2_new = dT2(init_x:init_x+view,init_y:init_y+view,:);
% dR2_new = dR2(init_x:init_x+view,init_y:init_y+view,:);
dT2_new = dT2;
dR2_new = dR2;

%T2* plots
figure(1);
subplot_tight(1,3,1,margins); pcolor([flip2y(dT2_new(:,:,1)) nan(nr,1); nan(1,nc+1)]); pbaspect([1 1 1]);
shading flat; title('\DeltaT2*(%), z1'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_0,'xtick',[],'ytick',[]);
subplot_tight(1,3,2,margins), pcolor([flip2y(dT2_new(:,:,2)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]); 
shading flat; title('\DeltaT2*(%), z2'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_0,'xtick',[],'ytick',[]);
subplot_tight(1,3,3,margins), pcolor([flip2y(dT2_new(:,:,3)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]);
shading flat; title('\DeltaT2*(%), z3'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_0,'xtick',[],'ytick',[]);
saveas(gcf,strcat('dSI_T2_',animal_name,time_name,'_noback_0.pdf'));

figure(2);
subplot_tight(1,3,1,margins); pcolor([flip2y(dT2_new(:,:,1)) nan(nr,1); nan(1,nc+1)]); pbaspect([1 1 1]);
shading flat; title('\DeltaT2*(%), z1'); colorbar; colormap(jet); set(gca,'clim',cb_dSI,'xtick',[],'ytick',[]);
subplot_tight(1,3,2,margins), pcolor([flip2y(dT2_new(:,:,2)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]); 
shading flat; title('\DeltaT2*(%), z2'); colorbar; colormap(jet); set(gca,'clim',cb_dSI,'xtick',[],'ytick',[]);
subplot_tight(1,3,3,margins), pcolor([flip2y(dT2_new(:,:,3)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]);
shading flat; title('\DeltaT2*(%), z3'); colorbar; colormap(jet); set(gca,'clim',cb_dSI,'xtick',[],'ytick',[]);
saveas(gcf,strcat('dSI_T2_',animal_name,time_name,'_noback.pdf'));

%R2* plots
figure(3);
subplot_tight(1,3,1,margins); pcolor([flip2y(dR2_new(:,:,1)) nan(nr,1); nan(1,nc+1)]); pbaspect([1 1 1]);
shading flat; title('\DeltaR2*(%), z1'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_0,'xtick',[],'ytick',[]);
subplot_tight(1,3,2,margins), pcolor([flip2y(dR2_new(:,:,2)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]); 
shading flat; title('\DeltaR2*(%), z2'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_0,'xtick',[],'ytick',[]);
subplot_tight(1,3,3,margins), pcolor([flip2y(dR2_new(:,:,3)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]);
shading flat; title('\DeltaR2*(%), z3'); colorbar; colormap(jet); set(gca,'clim',cb_dSI_0,'xtick',[],'ytick',[]);
fig_name = strcat('dSI_R2_',animal_name,time_name,'_noback_0.pdf');
saveas(gcf,fig_name);

figure(4);
subplot_tight(1,3,1,margins); pcolor([flip2y(dR2_new(:,:,1)) nan(nr,1); nan(1,nc+1)]); pbaspect([1 1 1]);
shading flat; title('\DeltaR2*(%), z1'); colorbar; colormap(jet); set(gca,'clim',cb_dSI,'xtick',[],'ytick',[]);
subplot_tight(1,3,2,margins), pcolor([flip2y(dR2_new(:,:,2)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]); 
shading flat; title('\DeltaR2*(%), z2'); colorbar; colormap(jet); set(gca,'clim',cb_dSI,'xtick',[],'ytick',[]);
subplot_tight(1,3,3,margins), pcolor([flip2y(dR2_new(:,:,3)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]);
shading flat; title('\DeltaR2*(%), z3'); colorbar; colormap(jet); set(gca,'clim',cb_dSI,'xtick',[],'ytick',[]);
saveas(gcf,strcat('dSI_R2_',animal_name,time_name,'_noback.pdf'));
set(gcf, 'Color', 'w');
export_fig dSI_R2map_30_G1.pdf -q101
end