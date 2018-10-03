clear;
clc;
tic;
F = dir('MR*');

%% These have to be changed depending on the datasest
TR = [90 270 810 2430 7290];
nSlices = 3;

% For F6
% TR = [120 300 900 2700 8400];
% nSlices = 4;

%% Rest of the parameters are same
nTRs = 5;
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
    %disp('*********************')
    disp(xx); %up to 384
    %disp('*********************')
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
imagesc(T1_est(:,:,2),[0,2000]);set(gca,'dataAspectRatio',[1 1 1]);axis off;
colorbar;colormap jet;

info1 = dicominfo('MRIm01.dcm');
info2 = dicominfo('MRIm02.dcm');
info3 = dicominfo('MRIm03.dcm');
info4 = dicominfo('MRIm04.dcm');
info5 = dicominfo('MRIm05.dcm');
info6 = dicominfo('MRIm06.dcm');
info7 = dicominfo('MRIm07.dcm');
info8 = dicominfo('MRIm08.dcm');
info9 = dicominfo('MRIm09.dcm');
info10 = dicominfo('MRIm10.dcm');
info11 = dicominfo('MRIm11.dcm');
info12 = dicominfo('MRIm12.dcm');
info13 = dicominfo('MRIm13.dcm');
info14 = dicominfo('MRIm14.dcm');
info15 = dicominfo('MRIm15.dcm');
info16 = dicominfo('MRIm16.dcm');
info17 = dicominfo('MRIm17.dcm');
info18 = dicominfo('MRIm18.dcm');
info19 = dicominfo('MRIm19.dcm');
info20 = dicominfo('MRIm20.dcm');
%}