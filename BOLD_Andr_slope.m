%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 12/05/2018 by Jihun Kwon
% This code calculate the slope of dynamic T2* signal between two
% timepoints.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear


base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018\results';
raw_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018_crop';
gauss_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181106_Andrea\BOLD_B_2018_crop_G05';

cd(base_name)
load('t2map.mat')

%set two timepoints
tp_max = 25; 
z_max = 5; 
te_max = 15;
te_target = 11;
tp_pre = 3;
tp_post = 5;
sigma = 0.2;

T2wI_raw = zeros(97,97,tp_max,z_max);
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

%Get every image with TE=39. TEs(10)
count = 0;
for tp = 1:tp_max
    for z = 1:z_max
        for te = 1:te_max
            count = count + 1;
            if te == te_target
                %raw image (used for overlay)
                cd(raw_name)
                sname = sprintf('MRIc%04d.dcm',count);
                fname = fullfile(raw_name, sname);
                T2wI_raw(:,:,tp,z) = dicomread(fname);
            end
        end
    end
end

%Thresholding
low_lim = -10;
high_lim = 10;
thr = (rel_inc >= low_lim & rel_inc <= high_lim); 
rel_inc_thr = rel_inc .* thr;

% for z=1:size(thr,4)
%     figure;
%     imshow(thr(:,:,z));
%     title('Relative Increase map, thr');
% end

%% Overlay
% Overlay one image transparently onto another 
cd(gauss_name)
time = 8;
slice = 2;
imB = T2wI_raw(:,:,time,slice); % Background image 
imF = thr(:,:,slice); % Foreground image 
[hf,hb] = imoverlay(imB,imF,[1,2],[0 10000],'flag',0.7); 
colormap('flag'); % figure colormap still applies
savename = strcat('Slope_overlay_t',num2str(time),'_z',num2str(slice),'_',num2str(low_lim),'to',num2str(high_lim),'.tif');
saveas(gcf,savename);