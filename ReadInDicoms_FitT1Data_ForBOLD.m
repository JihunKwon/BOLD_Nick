%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.1
% modified on 10/04/2018 by Jihun Kwon
% Fit T1wI and estimate T1map
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;
tic;
F = dir('MR*');

%% Mouse 1
%TR = [100 300 900 2700 6500]; nSlices = 3; nTRs = 5;
%% Mouse 3
TR = [100 150 300 500 1000 2000 3000 5000 8000]; nSlices = 3; nTRs = 9;

%% Rest of the parameters are same
counter = 1; %Count the number of files. Usually 15=3(Slice)*5
clear ims

%Changed specifically for BOLD datasets.
for ii=1:nTRs %5
    for jj=1:nSlices %3
        ims(:,:,jj,ii) = dicomread(F(counter).name);
        counter = counter+1;
    end
end


T1_est = zeros(size(ims,1),size(ims,2),nSlices);
mask = ims(:,:,:,1)*0;
gg = find(ims(:,:,:,end)>.2*mean(mean(mean(ims(:,:,:,end),1),2),3));
mask(gg)=1;

xdata = TR;

m = size(ims,2);
n = nSlices;

for xx=1:size(ims,1)
    for yy = 1:size(ims,2)
        for zz = 1:size(ims,3)
            if mask(xx,yy,zz)==1;
            
                ydata = double(squeeze((ims(xx,yy,zz,:))))';

                x0 = [ydata(end) 1500];

                options = optimoptions('lsqcurvefit','Display','none');
                [params,resnorm,resid,exitflag] = lsqcurvefit(@myfun_Exp_Increase,x0,xdata,ydata,[],[],options);

                T1_est(xx,yy,zz) = params(2);
                A_est(xx,yy,zz) = params(1);
                A_est(xx,yy,zz) = params(1);
                Error(xx,yy,zz) = resnorm;
            end
        end
    end
    disp(xx); %up to 384
end
toc;

%% Jihun edit
%{
% Show three slices
subplot(1,3,1), subimage(ims(:,:,1,5)); axis off;
subplot(1,3,2), subimage(ims(:,:,2,5)); axis off;
subplot(1,3,3), subimage(ims(:,:,3,5)); axis off;
imshow(ims(:,:,2,5)); axis off;

plot(ims(:,:,2,5)); axis off;
% Specify pixel of interest on the figure
x = 194;
y = 34;
z = 2;

% Plot both data points and fitted line
for i = 1:9
    a(i) = ims(x,y,z,i);
end
figure
F = A_est(x,y,z)*(1-exp(-xdata/T1_est(x,y,z)));
plot(xdata(:),a(:),'ko',xdata(:),F(:),'b-'); 

% Show T1map
imagesc(T1_est(:,:,2),[0,3000]);
set(gca,'dataAspectRatio',[1 1 1]);
axis off;
colorbar;
colormap jet;
%}