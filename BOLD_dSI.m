function [dSI, tot_dSI] = BOLD_dSI(animal_name,time_name,b_z1,b_z2,b_z3,T2_air,T2_O2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/17/2018 by Jihun Kwon
% Calculate dSI pixel-by-pixel
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
margins = [.007 .007];
cb_dSI = [0 40];
cb_t2map = [0 25];
[nr,nc] = size(T2_air(:,:,1));

view = 50;
if strcmp(time_name,'PreRT')
    init_x = 45;
    init_y = 55;
else %'M3_PostRT'
    init_x = 38;
    init_y = 73;
end

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

% figure;
% imshow(T2_air_roi(:,:,1));
vol_air = [0 0 0]; vol_O2 = [0 0 0];
sum_air = [0 0 0]; sum_O2 = [0 0 0];
ave_air = [0 0 0]; ave_O2 = [0 0 0];
tot_dSI = [0 0 0];
dSI = NaN(size(T2_air,1), size(T2_air,2), size(T2_air,3));
for k=1:size(T2_air,3)
    for j=1:size(T2_air,2)
        for i=1:size(T2_air,1)
            
            %Air
            if (~isnan(T2_air_roi(i,j,k)) && (T2_air_roi(i,j,k) ~= 0)) %neither Nan or zero
                vol_air(k) = vol_air(k) + 1;
                sum_air(k) = sum_air(k) + T2_air_roi(i,j,k);
            end
            
            %O2
            if (~isnan(T2_O2_roi(i,j,k)) && (T2_O2_roi(i,j,k) ~= 0)) %neither Nan or zero
                vol_O2(k) = vol_O2(k) + 1;
                sum_O2(k) = sum_O2(k) + T2_O2_roi(i,j,k);
            end
            
            %Calc dSI
            if (~isnan(T2_air_roi(i,j,k)) && (T2_air_roi(i,j,k) ~= 0) || ~isnan(T2_O2_roi(i,j,k)) || (T2_O2_roi(i,j,k) ~= 0))
                dSI(i,j,k) = 100*(T2_air_roi(i,j,k) - T2_O2_roi(i,j,k)) / T2_air_roi(i,j,k);
            end
            
        end
    end
end

ave_air = sum_air./vol_air;
ave_O2 = sum_O2./vol_O2;

for l=1:size(T2_air,3)
    tot_dSI(l) = 100*(ave_air(l) - ave_O2(l)) / ave_air(l);
end

dSI_new = dSI(init_x:init_x+view,init_y:init_y+view,:);

figure(1);
subplot_tight(1,3,1,margins), imshow(T2_air(:,:,1)), title('T2*map, air, z1'); colorbar; colormap(jet); set(gca,'clim',cb_t2map);
subplot_tight(1,3,2,margins), imshow(T2_air(:,:,2)), title('T2*map, air, z2'); colorbar; colormap(jet); set(gca,'clim',cb_t2map);
subplot_tight(1,3,3,margins), imshow(T2_air(:,:,3)), title('T2*map, air, z3'); colorbar; colormap(jet); set(gca,'clim',cb_t2map);
saveas(gcf,strcat('dSI_',animal_name,time_name,'.pdf'));

figure(2);
subplot_tight(1,3,1,margins), imshow(dSI_new(:,:,1)), title('dSI, z1'); colorbar; colormap(jet); set(gca,'clim',cb_dSI);
subplot_tight(1,3,2,margins), imshow(dSI_new(:,:,2)), title('dSI, z2'); colorbar; colormap(jet); set(gca,'clim',cb_dSI);
subplot_tight(1,3,3,margins), imshow(dSI_new(:,:,3)), title('dSI, z3'); colorbar; colormap(jet); set(gca,'clim',cb_dSI);
saveas(gcf,strcat('dSI_',animal_name,time_name,'.pdf'));

% figure(3);
% subplot_tight(1,3,1,margins), pcolor([flip2y(dSI_new(:,:,1)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]);
% shading flat; title('dSI(%), z1'); colorbar; colormap(jet); set(gca,'clim',cb_dSI,'xtick',[],'ytick',[]);
% subplot_tight(1,3,2,margins), pcolor([flip2y(dSI_new(:,:,2)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]); 
% shading flat; title('dSI(%), z2'); colorbar; colormap(jet); set(gca,'clim',cb_dSI,'xtick',[],'ytick',[]);
% subplot_tight(1,3,3,margins), pcolor([flip2y(dSI_new(:,:,3)) nan(nr,1); nan(1,nc+1)]), pbaspect([1 1 1]);
% shading flat; title('dSI(%), z3'); colorbar; colormap(jet); set(gca,'clim',cb_dSI,'xtick',[],'ytick',[]);
% saveas(gcf,strcat('dSI_',animal_name,time_name,'_noback.pdf'));

disp('end of code');
end