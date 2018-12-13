%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 12/05/2018 by Jihun Kwon
% This code calculate the slope of dynamic T2* signal between two
% timepoints.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear

base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018\results';
%base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_C_2018\results';
%base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_D_2018\results';
%base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_E_2018\results';
%base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_F_2018\results';

cd(base_name)
load('t2map.mat')

%set two timepoints
tp_pre = 3;
tp_post = 5;
sigma = 0.2;
slope = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
rel_inc = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
slope_thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
rel_inc_thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));
thr = zeros(size(t2map,1),size(t2map,2),size(t2map,4));

for z = 1:size(t2map,4) %Slice
%     for tp = 1:size(t2map,3)
%         t2map(:,:,tp,z) = imgaussfilt(t2map(:,:,tp,z),0.5);
%     end
    %t2map =  BOLD_Gaussian_postT2(t2map, sigma);
    %t2map(isnan(t2map)) = 0.0000000000001;
    
    %Get T2* value of each slice at two timepoints
    img_pre = t2map(:,:,tp_pre,z);
    img_post = t2map(:,:,tp_post,z);
    img_pre(isnan(img_pre))=0;
    img_post(isnan(img_post))=0;
    
    %Calculate Slope
    slope(:,:,z) = (img_post - img_pre)/(tp_post - tp_pre);
    
    %Show Slope map
    %slope = int(slope);
    figure;
    %slope(slope<0) = NaN;
    b1 = imagesc(slope(:,:,z));
    %set(b1,'AlphaData',~isnan(slope))
    cmap = jet(round(max(max(slope(:,:,z)))));
    pbaspect([1 1 1]);
    %colormap(flipud(parula))
    colormap(jet)
    caxis([-2 2]);
    colorbar;
    set(gca,'xtick',[],'ytick',[]);
    title('Slope map');

    %Calculate Relative Increase(%). In this case, baseline has to be the
    %average of timepoint 1 to 3.
    img_base = (t2map(:,:,1,z)+t2map(:,:,2,z)+t2map(:,:,3,z))/3;
    img_base(isnan(img_base))=0;
    rel_inc(:,:,z) = (img_post - img_base)./img_base * 100;
    
    %Show Slope map
    %slope = int(slope);
    figure;
    %rel_inc(rel_inc<0) = NaN;
    b2 = imagesc(rel_inc(:,:,z));
    %set(b2,'AlphaData',~isnan(rel_inc))
    pbaspect([1 1 1]);
    %colormap(flipud(parula))
    colormap(jet)
    caxis([-15 15]);
    colorbar;
    set(gca,'xtick',[],'ytick',[]);
    title('Relative Increase map');
end

%Thresholding
thr = (rel_inc >= -10 & rel_inc <= 10); 
rel_inc_thr = rel_inc .* thr;

for z=1:size(thr,4)
    figure;
    imshow(thr(:,:,z));
    title('Relative Increase map, thr');
end


%{
%% calulate ROI values and plot
t2map(t2map>100)=nan;
flag=1;
while flag
    try 
        numofrois=uint8(input('number of ROI: '));
        flag=0;
    catch em
    end
end
    
for i=1:size(t2map,4)
    [values(:,:,i),b(:,:,:,i),p{i}]=roi_values(t2map,t2map(:,:,1,i),numofrois);
    clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
    subplot(1,2,1);imagesc(t2map(:,:,1,i));colormap(gray);caxis([0 60]);img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois)
    subplot(1,2,2);plot(values(:,:,i),'LineWidth',2);
    axis_setting1; title('Dynamic T2');ylim([0 70]); %2roi:ylim([0 50]); 5roi:ylim([0 70]);
 end
%}