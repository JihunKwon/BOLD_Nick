c_min = -5000;
c_max = 20000;

%% Air
base_air = 'C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_PreRT\2_crop';
cd(base_air);

X3 = dicomread('MRIc03.dcm');
X6 = dicomread('MRIc06.dcm');
X9 = dicomread('MRIc09.dcm');
X12 = dicomread('MRIc12.dcm');
X15 = dicomread('MRIc15.dcm');

cd ..
figure(1);
imshow(X3);colormap(gray);caxis([c_min c_max]);
saveas(gcf,strcat('T2wI_air_03.pdf'));
print(gcf,strcat('T2wI_air_03.eps'), '-depsc2');

imshow(X6);colormap(gray);caxis([c_min c_max]);
saveas(gcf,strcat('T2wI_air_06.pdf'));
print(gcf,strcat('T2wI_air_06.eps'), '-depsc2');

imshow(X9);colormap(gray);caxis([c_min c_max]);
saveas(gcf,strcat('T2wI_air_09.pdf'));
print(gcf,strcat('T2wI_air_09.eps'), '-depsc2');

imshow(X12);colormap(gray);caxis([c_min c_max]);
saveas(gcf,strcat('T2wI_air_12.pdf'));
print(gcf,strcat('T2wI_air_12.eps'), '-depsc2');

imshow(X15);colormap(gray);caxis([c_min c_max]);
saveas(gcf,strcat('T2wI_air_15.pdf'));
print(gcf,strcat('T2wI_air_15.eps'), '-depsc2');

%% O2
base_O2 = 'C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_PreRT\4_crop';
cd(base_O2);

X3 = dicomread('MRIc03.dcm');
X6 = dicomread('MRIc06.dcm');
X9 = dicomread('MRIc09.dcm');
X12 = dicomread('MRIc12.dcm');
X15 = dicomread('MRIc15.dcm');

cd ..
figure(1);
imshow(X3);colormap(gray);caxis([c_min c_max]);
saveas(gcf,strcat('T2wI_O2_03.pdf'));
print(gcf,strcat('T2wI_O2_03.eps'), '-depsc2');

imshow(X6);colormap(gray);caxis([c_min c_max]);
saveas(gcf,strcat('T2wI_O2_06.pdf'));
print(gcf,strcat('T2wI_O2_06.eps'), '-depsc2');

imshow(X9);colormap(gray);caxis([c_min c_max]);
saveas(gcf,strcat('T2wI_O2_09.pdf'));
print(gcf,strcat('T2wI_O2_09.eps'), '-depsc2');

imshow(X12);colormap(gray);caxis([c_min c_max]);
saveas(gcf,strcat('T2wI_O2_12.pdf'));
print(gcf,strcat('T2wI_O2_12.eps'), '-depsc2');

imshow(X15);colormap(gray);caxis([c_min c_max]);

saveas(gcf,strcat('T2wI_O2_15.pdf'));
print(gcf,strcat('T2wI_O2_15.eps'), '-depsc2');