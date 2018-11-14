function [p,b] = BOLD_contour2(target,T2map,tar_name_s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/19/2018 by Jihun Kwon
% Contour T1map (no histogram calculation)
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% calulate ROI values and plot
c_min = 0; c_max = 30;
c_pattern = redblue; % redblue or gray

mkdir('results');
dir = pwd;
[values(:,:,1),b(:,:,:,1),p{1}]=BOLD_roi_values(T2map,T2map(:,:,1,1),1,tar_name_s); %last parameter is number of ROI.
clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
imagesc(target(:,:,1,1)); pbaspect([1 1 1]);
colormap(c_pattern);caxis([c_min c_max]);img_setting1;title('ROI');hold on
roi_para_drawing(p{1},1)
saveas(gcf,strcat(dir,'\results\plot_s_',tar_name_s,'.tif'))

end