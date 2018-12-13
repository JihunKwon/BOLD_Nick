%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/09/2018 by Jihun Kwon
% Subtract T2* map of O2 from air (T2*air - T2*oxy).
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
margins = [.007 .007];
cb_t2sub = [-15 15];
cd('C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea')
load('B_crop_param.mat')

T2sub = zeros(size(t2map));

for z = 1:size(t2map,4)
    for i = 2:size(t2map,3)
        T2sub(:,:,i,z) = t2map(:,:,i,z) - t2map(:,:,1,z);
    end
end


%% air1 - other
figure(1); %subtraction, z1
set(gcf,'Position',[100 100 1300 500], 'Color', 'w')
count = 0;
for i=2:size(t2map,3)
    if rem(i,3)==0
        count = count + 1;
        subaxis(2,4,count,'SpacingVert',0.03,'SpacingHoriz',0.005); %Post 1wd
        imagesc(T2sub(:,:,i,1)), title(strcat(num2str(i),'-1, z1')); 
        colorbar; colormap(redblue); set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); axis off;
    end
end
saveas(gcf,'BOLD_T2sub_z1.tif');
export_fig BOLD_T2sub_z1.tif -q101


figure(2); %subtraction, z2
set(gcf,'Position',[100 100 1300 500], 'Color', 'w')
for i=2:size(t2map,4)
    subplot_tight(2,5,i-1,margins), imagesc(T2sub(:,:,i,2)), title(strcat(num2str(i),'-1, z2')); 
    colorbar; colormap(redblue); set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); axis off;
end
saveas(gcf,'BOLD_T2sub_pre_z2_cbL.tif');
export_fig BOLD_T2sub_pre_z2_cbL.tif -q101


figure(3); %subtraction, z3
set(gcf,'Position',[100 100 1300 500], 'Color', 'w')
for i=2:size(t2map,4)
    subplot_tight(2,5,i-1,margins), imagesc(T2sub(:,:,i,3)), title(strcat(num2str(i),'-1, z3')); 
    colorbar; colormap(redblue); set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); axis off;
end
saveas(gcf,'BOLD_T2sub_pre_z3_cbL.tif');
export_fig BOLD_T2sub_pre_z3_cbL.tif -q101

