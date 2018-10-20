function [dist,out,p] = BOLD_contour(animal_name,time_name,target,air,tar_name_s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/17/2018 by Jihun Kwon
% Contour subtracted T1 or T2* map and get histogram information
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% calulate ROI values and plot
c_min = 0; c_max = 100;
c_pattern = jet; % redblue or gray

mkdir('results');
dir = pwd;
[values(:,:,1),b(:,:,:,1),p{1}]=BOLD_roi_values(air,air(:,:,1,1),1,tar_name_s); %last parameter is number of ROI.
clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
imagesc(target(:,:,1,1)); pbaspect([1 1 1]);
colormap(c_pattern);caxis([c_min c_max]);img_setting1;title('ROI');hold on
roi_para_drawing(p{1},1)
saveas(gcf,strcat(dir,'\results\plot_s_',tar_name_s,'.tif'))

vol = sum(sum(b));

%out(:,:,1) = (values(:,:,1));
%xlswrite(strcat('\results\ROI_values_',tar_name_s,'_',animal_name,'_',time_name,'.xlsx'),out(:,:,1));

%Apply ROI (contoured on air image) to target (subtaction image)
target_new = target .* b;

%Get histogram
count = 0;
for i=1:size(b,1)
    for j=1:size(b,2)
        if (~isnan(target_new(i,j,1,1)) && (target_new(i,j,1,1)) ~= 0)
            count = count + 1;
            dist(count) = target_new(i,j,1,1);
        end
    end
end

if (vol ~= count)
    disp('volume incorrect!!')
    %return %Force stop this code when volume is not correct
end

out = sum(dist)/count;
%save(strcat('ROI_',tar_name_s,'_',animal_name,'_',time_name,'.mat'));
end