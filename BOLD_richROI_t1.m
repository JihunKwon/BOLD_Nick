function values_sq = BOLD_richROI_t1(dirname,map,condition)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%map(map>100)=nan;
flag=1;
while flag
    try 
        numofrois=uint8(input('number of ROI: '));
        flag=0;
    catch em
    end
end
    
for i=1:size(map,3) %Slice number
    [values(:,:,i),b(:,:,:,i),p{i}]=roi_values_TOLD(map,map(:,:,i),numofrois);
    clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
    subplot(1,2,1);imagesc(map(:,:,i));colormap(gray);
    caxis([0 3000]);
    img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois)
    saveas(gcf,strcat(dirname,'\results\plot_s_',condition,'_',num2str(i),'.tif'))
    
end

values_sq = squeeze(values);
figure;
for i=1:numofrois %ROI number
    plot(1:size(map,3),values_sq(i,:),'-o','LineWidth',2);
    hold on;
end
    xlabel('Slice');
    ylabel('T1 (ms)');
    axis_setting1; title('T1');
    ylim([0 5000]);
end

