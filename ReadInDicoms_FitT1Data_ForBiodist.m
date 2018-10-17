%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.1
% modified on 10/04/2018 by Jihun Kwon
% Fit T1wI and estimate T1map
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
tic;
F = dir('MR*');

%% These have to be changed depending on the datasest
%% Mouse 1
%*For F2, F2b
%TR = [90 270 810 2430 7290]; nSlices = 3; nTRs = 5;
%*For F3,F4
%TR = [100 300 900 2700 8400]; nSlices = 3; nTRs = 5;
%*For F6,F7,F7b
%TR = [120 300 900 2700 8400]; nSlices = 4; nTRs = 5;
%*For F8,F9,F10,F11
%TR = [100 200 400 800 1600 3200 7000]; nSlices = 3; nTRs = 7;

%% Mouse 3
TR = [100 150 300 500 1000 2000 3000 5000 8000]; nSlices = 3; nTRs = 9;
%% Rest of the parameters are same
counter = 1; %Count the number of files. Usually 15=3(Slice)*5
clear ims

%Changed specifically for Biodistribution datasets.
%Because 1~3:TR1,different slices. 4~6:TR2,dfferent slices...
for ii=1:nTRs
    for jj=1:nSlices
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
    for yy = 1:m
        for zz = 1:n
            if mask(xx,yy,zz)==1;
            
                ydata = double(squeeze((ims(xx,yy,zz,:))))';

                x0 = [ydata(end) 1500];

                options = optimoptions('lsqcurvefit','Display','none');
                [params,resnorm,resid,exitflag] = lsqcurvefit(@myfun_Exp_Increase,x0,xdata,ydata,[],[],options);

                T1_est(xx,yy,zz) = params(2);
                A_est(xx,yy,zz) = params(1);
                %A_est(xx,yy,zz) = params(1);
                Error(xx,yy,zz) = resnorm;
                exflg = exitflag;
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
% Show five TR
subplot(3,5,1), subimage(ims(:,:,1,1)); axis off; title('Z1 TR1');
subplot(3,5,2), subimage(ims(:,:,1,2)); axis off; title('Z1 TR2');
subplot(3,5,3), subimage(ims(:,:,1,3)); axis off; title('Z1 TR3');
subplot(3,5,4), subimage(ims(:,:,1,4)); axis off; title('Z1 TR4');
subplot(3,5,5), subimage(ims(:,:,1,5)); axis off; title('Z1 TR5');
subplot(3,5,6), subimage(ims(:,:,2,1)); axis off; title('Z2 TR1');
subplot(3,5,7), subimage(ims(:,:,2,2)); axis off; title('Z2 TR2');
subplot(3,5,8), subimage(ims(:,:,2,3)); axis off; title('Z2 TR3');
subplot(3,5,9), subimage(ims(:,:,2,4)); axis off; title('Z2 TR4');
subplot(3,5,10), subimage(ims(:,:,2,5)); axis off; title('Z2 TR5');
subplot(3,5,11), subimage(ims(:,:,3,1)); axis off; title('Z3 TR1');
subplot(3,5,12), subimage(ims(:,:,3,2)); axis off; title('Z3 TR2');
subplot(3,5,13), subimage(ims(:,:,3,3)); axis off; title('Z3 TR3');
subplot(3,5,14), subimage(ims(:,:,3,4)); axis off; title('Z3 TR4');
subplot(3,5,15), subimage(ims(:,:,3,5)); axis off; title('Z3 TR5');

imshow(ims(:,:,2,5)); axis off;

plot(ims(:,:,2,5)); axis off;
% Specify pixel of interest on the figure
x = 307;
y = 28;
z = 2;

% Plot both data points and fitted line
for i = 1:5
    a(i) = ims(x,y,z,i);
end
figure
F = A_est(x,y,z)*(1-exp(-xdata/T1_est(x,y,z)));
plot(xdata(:),a(:),'ko',xdata(:),F(:),'b-'); 

% Show T1map
imagesc(T1_est(:,:,1),[0,2000]);set(gca,'dataAspectRatio',[1 1 1]);axis off;
colorbar;colormap jet;
%}