function BOLD_get_refROI(animal_name,time_name,base_name)
%This function contours raw dcm image and save position and bw.
%This is useful for calling same ROIs. 
%b(x_axis,y_axis,ROI,slice)

cd(base_name)
flag=1;
while flag
    try 
        numofrois=uint8(input('number of ROI: '));
        flag=0;
    catch em
    end
end

X(:,:,1) = dicomread('MRIc0001.dcm');
X(:,:,2) = dicomread('MRIc0016.dcm');
X(:,:,3) = dicomread('MRIc0031.dcm');
cd ..
for i=1:size(X,3)
    [b(:,:,:,i),p{i}]=roi_values_ref(X,X(:,:,i),numofrois);
    clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
    imagesc(X(:,:,i));colormap(gray);
    %caxis([0 1000]);
    img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois);
    saveas(gcf,strcat('ref_ROI_',animal_name,'_',time_name,'_',num2str(i),'.tif'))
end


save('reference_2ROIs.mat','b','p','X');
end