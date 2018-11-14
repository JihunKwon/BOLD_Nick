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
dSI_pre_t2 = dSI_t2;
dSI_tot_pre_t2 = tot_dSI_t2;
dSI_pre_r2 = dSI_r2;
dSI_tot_pre_r2 = tot_dSI_r2;
dSI_pre_si = dSI_si;
dSI_tot_pre_si = tot_dSI_si;
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT_10m');
load('dSI_M3_PostRT_10m.mat');
dSI_10_t2 = dSI_t2;
dSI_tot_10_t2 = tot_dSI_t2;
dSI_10_r2 = dSI_r2;
dSI_tot_10_r2 = tot_dSI_r2;
dSI_10_si = dSI_si;
dSI_tot_10_si = tot_dSI_si;
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT_30m');
load('dSI_M3_PostRT_30m.mat');
dSI_30_t2 = dSI_t2;
dSI_tot_30_t2 = tot_dSI_t2;
dSI_30_r2 = dSI_r2;
dSI_tot_30_r2 = tot_dSI_r2;
dSI_30_si = dSI_si;
dSI_tot_30_si = tot_dSI_si;

cd ..

figure(1);
c = categorical({'Slice 1','Slice 2','Slice 3'});
% y_t2 = [dSI_tot_pre_t2(1) dSI_tot_pre_t2(2) dSI_tot_pre_t2(3);
%      dSI_tot_10_t2(1) dSI_tot_10_t2(2) dSI_tot_10_t2(3);
%      dSI_tot_30_t2(1) dSI_tot_30_t2(2) dSI_tot_30_t2(3)];
 
y_t2 = [dSI_tot_pre_t2(1) dSI_tot_10_t2(1) dSI_tot_30_t2(1);
        dSI_tot_pre_t2(2) dSI_tot_10_t2(2) dSI_tot_30_t2(2);
        dSI_tot_pre_t2(3) dSI_tot_10_t2(3) dSI_tot_30_t2(3)];
 
bar(c,y_t2);
legend({'Pre RT, 10min','Post RT, 10min','Post RT, 30min'},'Location','northwest','FontSize',8);
ylabel('\DeltaT2*(%)');
title('\DeltaT2*(%)');
ylim([-15 20])

saveas(gcf,strcat('dSI_T2_total_M3.pdf'));
print(gcf,strcat('dSI_T2_total_M3.eps'), '-depsc2');

figure(2);
% y_r2 = [dSI_tot_pre_r2(1) dSI_tot_pre_r2(2) dSI_tot_pre_r2(3);
%      dSI_tot_10_r2(1) dSI_tot_10_r2(2) dSI_tot_10_r2(3);
%      dSI_tot_30_r2(1) dSI_tot_30_r2(2) dSI_tot_30_r2(3)];
 
y_r2 = [dSI_tot_pre_r2(1) dSI_tot_10_r2(1) dSI_tot_30_r2(1);
        dSI_tot_pre_r2(2) dSI_tot_10_r2(2) dSI_tot_30_r2(2);
        dSI_tot_pre_r2(3) dSI_tot_10_r2(3) dSI_tot_30_r2(3)];
 
bar(c,y_r2);
legend({'Pre RT, 10min','Post RT, 10min','Post RT, 30min'},'Location','northeast','FontSize',8);
ylabel('\DeltaR2*(%)'); 
title('\DeltaR2*(%)');
ylim([-15 40])

saveas(gcf,strcat('dSI_R2_total_M3.pdf'));
print(gcf,strcat('dSI_R2_total_M3.eps'), '-depsc2');


figure(3);
% y_si = [dSI_tot_pre_si(1) dSI_tot_pre_si(2) dSI_tot_pre_si(3);
%      dSI_tot_10_si(1) dSI_tot_10_si(2) dSI_tot_10_si(3);
%      dSI_tot_30_si(1) dSI_tot_30_si(2) dSI_tot_30_si(3)];
 
y_si = [dSI_tot_pre_si(1) dSI_tot_10_si(1) dSI_tot_30_si(1);
        dSI_tot_pre_si(2) dSI_tot_10_si(2) dSI_tot_30_si(2);
        dSI_tot_pre_si(3) dSI_tot_10_si(3) dSI_tot_30_si(3)];
 
bar(c,y_si);
legend({'Pre RT, 10min','Post RT, 10min','Post RT, 30min'},'Location','northwest','FontSize',8);
ylabel('\DeltaSI(%)'); 
title('\DeltaSI(%)');
ylim([-15 35])

saveas(gcf,strcat('dSI_SI_total_M3.pdf'));
print(gcf,strcat('dSI_SI_total_M3.eps'), '-depsc2');