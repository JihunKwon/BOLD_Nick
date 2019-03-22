%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.1
% modified on 02/09/2019 by Jihun Kwon
% This code finds optimum TE which maximizes the signal difference between the
% O2 and air breathing. Compare multiple pixels around center pixel
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Parameters
num_z = 5; %Total number of slice
num_te = 15; %Total number of TEs
tp_air = 10;
tp_total = 20;
target_air = 1; %First Air timepoint
target_oxy = 15; %15th Oxygen timepoint
target_z = 4; %Target Slice

%Week 2, Animal B
base_name_te = 'C:\Users\jihun\Documents\MATLAB\BOLD\20190125_Andrea\01-18-2019\BOLD_A_2019_crop_G05';

%% Air breathing
cd(base_name_te);

%Visualize 
figure;
ref_img = dicomread('MRIc0046.dcm');
imshow(ref_img, [5000 20000]);

%Chose SouthEast of tumor. User has to manually set this cordinate
X = 41;
Y = 25;

distance=5; %Distance between center ROI and other ROIs.
ROI_air = zeros(1,num_te);
ROI = zeros(distance);
fcount = num_te*(target_z-1)*target_air;

for te=1:num_te
    fcount = fcount+1; %Count file number 
    fname_temp = sprintf('MRIc%04d.dcm', fcount);
    fname = fullfile(base_name_te, fname_temp);

    if exist(fname,'file')
        img = dicomread(fname);
        %img(Y,X); 

        % X and Y are fliped to see in the same cordinate with image.
        % For example, when distance=3, X and Y set above is the position of "33".
        % 11 12 13      1 2 3
        % 21 22 23  ->  4 5 6
        % 31 32 33      7 8 9
        
        for i=1:distance
            for j = 1:distance
                ROI(i,j) = img(Y-i, X-j);
                ROI_air(1,te) = ROI_air(1,te) + ROI(i,j);
            end
        end
        ROI_air(1,te) =  ROI_air(1,te)/(distance^2);

    else
        fprintf('File %s does not exist.\n', fname);
    end
end

%% O2 breathing. Average of all timepoints except first O2.
%Chose pixel
ROI_oxy = zeros(1,num_te);
fcount = num_te*(target_z-1)*target_oxy;
for tp = tp_air+2:tp_total %Skip first O2
    for te=1:num_te
        fcount = fcount+1; %Count file number 
        fname_temp = sprintf('MRIc%04d.dcm', fcount);
        fname = fullfile(base_name_te, fname_temp);

        if exist(fname,'file')
            img = dicomread(fname);
            %img(Y,X); 

            for i=1:distance
                for j = 1:distance
                    ROI(i,j) = img(Y-i, X-i);
                    ROI_oxy(1,te) = ROI_oxy(1,te) + ROI(i,j);
                end
            end
            ROI_oxy(1,te) =  ROI_oxy(1,te)/(distance^2);

        else
            fprintf('File %s does not exist.\n', fname);
        end
        ROI_oxy_tp(tp,te) = ROI_oxy(1,te);
    end
end
ROI_oxy_mean(1,:) = mean(ROI_oxy_tp(tp_air+2:tp_total,:));

%% Plot signal change
TE = [2.5592 6.1152 9.6712 13.2272 16.7832 20.3392 23.8952 27.4512 31.0072 34.5633 38.1193 41.6753 45.2313 48.7873 52.3433];

ROI_mean_sub = ROI_oxy_mean - ROI_air;
ROI_mean_ratio = ROI_oxy_mean./ROI_air;

figure;
plot(TE,ROI_oxy_mean(1,:),'-o'); hold on;
plot(TE,ROI_air(1,:),'-x'); hold on;
plot(TE,ROI_mean_sub(1,:),'-s');
title('Tissue Signal Decay Curve');
legend('O_2','air','O_2 - air');
xlabel('TE (ms)')
ylabel('Signal Intensity')
set(gcf, 'Color', 'w');
saveas(gcf,'SI_TE.tiff');
export_fig SI_TE.tiff -q101

figure;
plot(TE,ROI_mean_ratio(1,:),'-o')
title('Ratio (Oxygen/Air)');
xlabel('TE (ms)')
ylabel('Ratio')
set(gcf, 'Color', 'w');
saveas(gcf,'SI_ratio.tiff');
export_fig SI_ratio.tiff -q101