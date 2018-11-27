%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 11/13/2018 by Jihun Kwon
% This code finds optimum TE which maximizes the difference between the
% signal with O2 and air breathing. Compare multiple pixel around center
% pixel
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Air breathing
time_name = 'PreRT'; % or 'PreRT','PostRT_10m', 'PostRT_30m'
basefolder_air = strcat('C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_',time_name,'\2_crop_G1');

if strcmp(time_name,'PostRT_30m') %30min uses same air data with 10min
    basefolder_air = 'C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_PostRT_10m\2_crop_G1';
end
cd(basefolder_air);
% figure;
% imshow('MRIc33.dcm');

%Chose pixel
if strcmp(time_name,'PreRT')
    X=[26 30 29]; % These cordinate are as shown in imshow('MRIc04.dcm').
    Y=[36 35 36];
else % Same for PostRT 10 and 30 min
    X=[31 30 31]; % These cordinate are as shown in imshow('MRIc04.dcm').
    Y=[33 33 32];
end

distance=3; %Distance between center ROI and other ROIs.
ROI_mean_air = zeros(3,15,9); %(num of slices, num of TEs, num of pixels)
fcount = 0;
for z = 1:3
    for te=1:15
        fcount = fcount+1; %Count file number 
        fname_temp = sprintf('MRIc%02d.dcm', fcount);
        fname = fullfile(basefolder_air, fname_temp);
        
        if exist(fname,'file')
            img = dicomread(fname);
            %img(Y,X); 

            % X and Y are fliped to see in the same cordinate with image.
            % X and Y specified on the top is the position of "22".
            % 11 12 13      1 2 3
            % 21 22 23  ->  4 5 6
            % 31 32 33      7 8 9
            ROI(1,:) = [Y(z)-1 X(z)-1];
            ROI(2,:) = [Y(z)-1 X(z)];
            ROI(3,:) = [Y(z)-1 X(z)+1];
            ROI(4,:) = [Y(z) X(z)-1];
            ROI(5,:) = [Y(z) X(z)];
            ROI(6,:) = [Y(z) X(z)+1];
            ROI(7,:) = [Y(z)+1 X(z)-1];
            ROI(8,:) = [Y(z)+1 X(z)];
            ROI(9,:) = [Y(z)+1 X(z)+1];
            
            for roi = 1:9
                ROI_mean_air(z,te,roi) = ROI(roi);
            end

        else
            fprintf('File %s does not exist.\n', fname);
        end
    end
end


%% O2 breathing
basefolder_O2 = strcat('C:\Users\jihun\Documents\MATLAB\BOLD\Input_T1wI\M3_',time_name,'\4_crop_G1');
cd(basefolder_O2);

%Chose pixel
ROI_mean_O2 = zeros(3,15,9);
fcount = 0;
for z = 1:3
    for te=1:15
        fcount = fcount+1; %Count file number 
        fname_temp = sprintf('MRIc%02d.dcm', fcount);
        fname = fullfile(basefolder_air, fname_temp);
        
        if exist(fname,'file')
            img = dicomread(fname);
            %img(Y,X); 

            % X and Y are fliped to see in the same cordinate with image.
            % X and Y specified on the top is the position of "22".
            % 11 12 13      1 2 3
            % 21 22 23  ->  4 5 6
            % 31 32 33      7 8 9
            ROI(1,:) = [Y(z)-1 X(z)-1];
            ROI(2,:) = [Y(z)-1 X(z)];
            ROI(3,:) = [Y(z)-1 X(z)+1];
            ROI(4,:) = [Y(z) X(z)-1];
            ROI(5,:) = [Y(z) X(z)];
            ROI(6,:) = [Y(z) X(z)+1];
            ROI(7,:) = [Y(z)+1 X(z)-1];
            ROI(8,:) = [Y(z)+1 X(z)];
            ROI(9,:) = [Y(z)+1 X(z)+1];
            
            for roi = 1:9
                ROI_mean_air(z,te,roi) = ROI(roi);
            end

        else
            fprintf('File %s does not exist.\n', fname);
        end
    end
end

%{
%% Plot signal change
cd('C:\Users\jihun\Documents\MATLAB\BOLD');
close all
TE = [3 7 11 15 19 23 27 31 35 39 43 47 51 55 59];
ROI_mean_sub = ROI_mean_O2 - ROI_mean_air;

figure(1);
plot(TE,ROI_mean_air(1,:),'-o'); hold on;
plot(TE,ROI_mean_O2(1,:),'-x'); hold on;
plot(TE,ROI_mean_sub(1,:),'-s');
title('z1');
legend('air','O_2','O_2 - air');
set(gcf, 'Color', 'w');
saveas(gcf,'SI_TE_10min.tiff');
export_fig SI_TE_10min.tiff -q101

figure(2);
plot(TE,ROI_mean_air(2,:),'-o'); hold on;
plot(TE,ROI_mean_O2(2,:),'-x'); hold on;
plot(TE,ROI_mean_sub(2,:),'-s');
title('z2');
legend('air','O_2','O_2 - air');

figure(3);
plot(TE,ROI_mean_air(3,:),'-o'); hold on;
plot(TE,ROI_mean_O2(3,:),'-x'); hold on;
plot(TE,ROI_mean_sub(3,:),'-s');
title('z3');
legend('air','O_2','O_2 - air');

figure(4);
plot(TE,ROI_mean_sub(3,:),'-o');
title('z3, O_2 - air');
legend('O_2 - air');
set(gcf, 'Color', 'w');
saveas(gcf,'SI_TE_diff_30min.tiff');
export_fig SI_TE_diff_30min.tiff -q101
%}