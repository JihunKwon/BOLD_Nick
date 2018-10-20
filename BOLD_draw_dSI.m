%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/17/2018 by Jihun Kwon
% Draw histogram of pre and post RT
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
%% draw histogram
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PreRT');
load('dSI_M3_PreRT.mat');
T2dSI_pre = T2dSI;
T2dSI_tot_pre = tot_dSI;
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT_10m');
load('dSI_M3_PostRT_10m.mat');
T2dSI_10 = T2dSI;
T2dSI_tot_10 = tot_dSI;
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT_30m');
load('dSI_M3_PostRT_30m.mat');
T2dSI_30 = T2dSI;
T2dSI_tot_30 = tot_dSI;

figure;
c = categorical({'Slice 1','Slice 2','Slice 3'});
y = [T2dSI_tot_pre(1) T2dSI_tot_pre(2) T2dSI_tot_pre(3);
     T2dSI_tot_10(1) T2dSI_tot_10(2) T2dSI_tot_10(3);
     T2dSI_tot_30(1) T2dSI_tot_30(2) T2dSI_tot_30(3)];
bar(c,y);
legend({'Pre RT, 10min','Post RT, 10min','Post RT, 30min'},'Location','northeast','FontSize',8);
ylabel('Average \DeltaSI');
ylim([-20 20])