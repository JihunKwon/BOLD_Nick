%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/17/2018 by Jihun Kwon
% Draw histogram of R2*, T2*, and SI.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
animal_name='M3';
bin_R2 = 5;
bin_SI = 6;
co = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560;
0.4660 0.6740 0.1880;
0.3010 0.7450 0.9330;
0.6350 0.0780 0.1840;];
y=0:0.001:0.32;

xrange_long_R2 = [-150 150];
yrange_R2 = [0 0.13];

xrange_long_T2 = [-150 150];
yrange_T2 = [0 0.13];

xrange_long_SI = [-150 150];
yrange_SI = [0 0.13];

%% Import all time points, all slices
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PreRT');
load('dSI_M3_PreRT.mat');
dSI_R2_pre = dSI_r2;
dSI_T2_pre = dSI_t2;
dSI_SI_pre = dSI_si;

cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT_10m');
load('dSI_M3_PostRT_10m.mat');
dSI_R2_post10 = dSI_r2;
dSI_T2_post10 = dSI_t2;
dSI_SI_post10 = dSI_si;

cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT_30m');
load('dSI_M3_PostRT_30m.mat');
dSI_R2_post30 = dSI_r2;
dSI_T2_post30 = dSI_t2;
dSI_SI_post30 = dSI_si;

cd ..\

%% Get histogram
%R2*
[dist_R2_pre_z1,mean_R2_pre_z1] = get_dist(dSI_R2_pre(:,:,1));
[dist_R2_pre_z2,mean_R2_pre_z2] = get_dist(dSI_R2_pre(:,:,2));
[dist_R2_pre_z3,mean_R2_pre_z3] = get_dist(dSI_R2_pre(:,:,3));
[dist_R2_post10_z1,mean_R2_post10_z1] = get_dist(dSI_R2_post10(:,:,1));
[dist_R2_post10_z2,mean_R2_post10_z2] = get_dist(dSI_R2_post10(:,:,2));
[dist_R2_post10_z3,mean_R2_post10_z3] = get_dist(dSI_R2_post10(:,:,3));
[dist_R2_post30_z1,mean_R2_post30_z1] = get_dist(dSI_R2_post30(:,:,1));
[dist_R2_post30_z2,mean_R2_post30_z2] = get_dist(dSI_R2_post30(:,:,2));
[dist_R2_post30_z3,mean_R2_post30_z3] = get_dist(dSI_R2_post30(:,:,3));
%T2*
[dist_T2_pre_z1,mean_T2_pre_z1] = get_dist(dSI_T2_pre(:,:,1));
[dist_T2_pre_z2,mean_T2_pre_z2] = get_dist(dSI_T2_pre(:,:,2));
[dist_T2_pre_z3,mean_T2_pre_z3] = get_dist(dSI_T2_pre(:,:,3));
[dist_T2_post10_z1,mean_T2_post10_z1] = get_dist(dSI_T2_post10(:,:,1));
[dist_T2_post10_z2,mean_T2_post10_z2] = get_dist(dSI_T2_post10(:,:,2));
[dist_T2_post10_z3,mean_T2_post10_z3] = get_dist(dSI_T2_post10(:,:,3));
[dist_T2_post30_z1,mean_T2_post30_z1] = get_dist(dSI_T2_post30(:,:,1));
[dist_T2_post30_z2,mean_T2_post30_z2] = get_dist(dSI_T2_post30(:,:,2));
[dist_T2_post30_z3,mean_T2_post30_z3] = get_dist(dSI_T2_post30(:,:,3));
%SI
[dist_SI_pre_z1,mean_SI_pre_z1] = get_dist(dSI_SI_pre(:,:,1));
[dist_SI_pre_z2,mean_SI_pre_z2] = get_dist(dSI_SI_pre(:,:,2));
[dist_SI_pre_z3,mean_SI_pre_z3] = get_dist(dSI_SI_pre(:,:,3));
[dist_SI_post10_z1,mean_SI_post10_z1] = get_dist(dSI_SI_post10(:,:,1));
[dist_SI_post10_z2,mean_SI_post10_z2] = get_dist(dSI_SI_post10(:,:,2));
[dist_SI_post10_z3,mean_SI_post10_z3] = get_dist(dSI_SI_post10(:,:,3));
[dist_SI_post30_z1,mean_SI_post30_z1] = get_dist(dSI_SI_post30(:,:,1));
[dist_SI_post30_z2,mean_SI_post30_z2] = get_dist(dSI_SI_post30(:,:,2));
[dist_SI_post30_z3,mean_SI_post30_z3] = get_dist(dSI_SI_post30(:,:,3));

%% Draw R2*
%Draw histogram. Slice1
figure('Position', [391 1 500 700]);
subaxis(3,1,1,'SpacingVert',0,'MR',0);
histogram(dist_R2_pre_z1);
h_pre = histogram(dist_R2_pre_z1); hold on;
h_post_10 = histogram(dist_R2_post10_z1); hold on;
h_post_30 = histogram(dist_R2_post30_z1); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin_R2;
h_post_10.BinWidth = bin_R2;
h_post_30.BinWidth = bin_R2;
x1=mean_R2_pre_z1;
x2=mean_R2_post10_z1;
x3=mean_R2_post30_z1;
line([x1 x1],[yrange_R2(1) yrange_R2(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange_R2(1) yrange_R2(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange_R2(1) yrange_R2(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
xlim(xrange_short_R2);
ylim(yrange_R2);
t1 = title('Slice 1, \DeltaR2*(%)', 'Units', 'normalized', 'Position', [0.14, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
set(gca,'xticklabels',num2str(''));

%Slice2, R2*
subaxis(3,1,2,'SpacingVert',0,'MR',0);
h_pre = histogram(dist_R2_pre_z2); hold on;
h_post_10 = histogram(dist_R2_post10_z2); hold on;
h_post_30 = histogram(dist_R2_post30_z2); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin_R2;
h_post_10.BinWidth = bin_R2;
h_post_30.BinWidth = bin_R2;
x1=mean_R2_pre_z2;
x2=mean_R2_post10_z2;
x3=mean_R2_post30_z2;
line([x1 x1],[yrange_R2(1) yrange_R2(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange_R2(1) yrange_R2(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange_R2(1) yrange_R2(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
xlim(xrange_short_R2);
ylim(yrange_R2);
t2 = title('Slice 2, \DeltaR2*(%)', 'Units', 'normalized', 'Position', [0.14, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
set(gca,'xticklabels',num2str(''));

%Slice3, R2*
subaxis(3,1,3,'SpacingVert',0,'MR',0);
h_pre = histogram(dist_R2_pre_z3); hold on;
h_post_10 = histogram(dist_R2_post10_z3); hold on;
h_post_30 = histogram(dist_R2_post30_z3); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin_R2;
h_post_10.BinWidth = bin_R2;
h_post_30.BinWidth = bin_R2;
x1=mean_R2_pre_z3;
x2=mean_R2_post10_z3;
x3=mean_R2_post30_z3;
xlim(xrange_short_R2);
ylim(yrange_R2);
line([x1 x1],[yrange_R2(1) yrange_R2(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange_R2(1) yrange_R2(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange_R2(1) yrange_R2(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
t3 = title('Slice 3, \DeltaR2*(%)', 'Units', 'normalized', 'Position', [0.14, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
xlabel('\DeltaR2*(%)');

%save Xrange long
subaxis(3,1,1); xlim(xrange_long_R2);
subaxis(3,1,2); xlim(xrange_long_R2);
subaxis(3,1,3); xlim(xrange_long_R2); legend({'Pre RT','Post RT, 10min','Post RT, 30min','Mean, Pre RT','Mean, Post RT, 10min','Mean, Post RT, 30min'},'Location','northeast','FontSize',7.5);
saveas(gcf,strcat('Histogram_dR2_',animal_name,'_Xlong.pdf'));
print(gcf,strcat('Histogram_dR2_',animal_name,'_Xlong.eps'), '-depsc2');

%{
%% Draw T2*
%Draw histogram. Slice1
figure('Position', [391 1 500 700]);
subaxis(3,1,1,'SpacingVert',0,'MR',0);
histogram(dist_T2_pre_z1);
h_pre = histogram(dist_T2_pre_z1); hold on;
h_post_10 = histogram(dist_T2_post10_z1); hold on;
h_post_30 = histogram(dist_T2_post30_z1); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin_R2;
h_post_10.BinWidth = bin_R2;
h_post_30.BinWidth = bin_R2;
x1=mean_T2_pre_z1;
x2=mean_T2_post10_z1;
x3=mean_T2_post30_z1;
line([x1 x1],[yrange_T2(1) yrange_T2(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange_T2(1) yrange_T2(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange_T2(1) yrange_T2(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
xlim(xrange_short_T2);
ylim(yrange_T2);
t1 = title('Slice 1, \DeltaT2*(%)', 'Units', 'normalized', 'Position', [0.14, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
set(gca,'xticklabels',num2str(''));

%Slice2, T2*
subaxis(3,1,2,'SpacingVert',0,'MR',0);
h_pre = histogram(dist_T2_pre_z2); hold on;
h_post_10 = histogram(dist_T2_post10_z2); hold on;
h_post_30 = histogram(dist_T2_post30_z2); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin_R2;
h_post_10.BinWidth = bin_R2;
h_post_30.BinWidth = bin_R2;
x1=mean_T2_pre_z2;
x2=mean_T2_post10_z2;
x3=mean_T2_post30_z2;
line([x1 x1],[yrange_T2(1) yrange_T2(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange_T2(1) yrange_T2(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange_T2(1) yrange_T2(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
xlim(xrange_short_T2);
ylim(yrange_T2);
t2 = title('Slice 2, \DeltaT2*(%)', 'Units', 'normalized', 'Position', [0.14, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
set(gca,'xticklabels',num2str(''));

%Slice3, T2*
subaxis(3,1,3,'SpacingVert',0,'MR',0);
h_pre = histogram(dist_T2_pre_z3); hold on;
h_post_10 = histogram(dist_T2_post10_z3); hold on;
h_post_30 = histogram(dist_T2_post30_z3); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin_R2;
h_post_10.BinWidth = bin_R2;
h_post_30.BinWidth = bin_R2;
x1=mean_T2_pre_z3;
x2=mean_T2_post10_z3;
x3=mean_T2_post30_z3;
xlim(xrange_short_T2);
ylim(yrange_T2);
line([x1 x1],[yrange_T2(1) yrange_T2(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange_T2(1) yrange_T2(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange_T2(1) yrange_T2(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
t3 = title('Slice 3, \DeltaT2*(%)', 'Units', 'normalized', 'Position', [0.14, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
xlabel('\DeltaT2*(%)');

%save Xrange long, T2*
subaxis(3,1,1); xlim(xrange_long_T2);legend({'Pre RT','Post RT, 10min','Post RT, 30min','Mean, Pre RT','Mean, Post RT, 10min','Mean, Post RT, 30min'},'Location','northeast','FontSize',7.5);
subaxis(3,1,2); xlim(xrange_long_T2);
subaxis(3,1,3); xlim(xrange_long_T2); 
saveas(gcf,strcat('Histogram_dT2_',animal_name,'_Xlong.pdf'));
print(gcf,strcat('Histogram_dT2_',animal_name,'_Xlong.eps'), '-depsc2');
%}

%% Draw dSI
%Draw histogram. Slice1
figure('Position', [391 1 500 700]);
subaxis(3,1,1,'SpacingVert',0,'MR',0);
histogram(dist_SI_pre_z1);
h_pre = histogram(dist_SI_pre_z1); hold on;
h_post_10 = histogram(dist_SI_post10_z1); hold on;
h_post_30 = histogram(dist_SI_post30_z1); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin_SI;
h_post_10.BinWidth = bin_SI;
h_post_30.BinWidth = bin_SI;
x1=mean_SI_pre_z1;
x2=mean_SI_post10_z1;
x3=mean_SI_post30_z1;
line([x1 x1],[yrange_SI(1) yrange_SI(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange_SI(1) yrange_SI(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange_SI(1) yrange_SI(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
xlim(xrange_short_SI);
ylim(yrange_SI);
t1 = title('Slice 1, \DeltaSI(%)', 'Units', 'normalized', 'Position', [0.14, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
set(gca,'xticklabels',num2str(''));

%Slice2, SI*
subaxis(3,1,2,'SpacingVert',0,'MR',0);
h_pre = histogram(dist_SI_pre_z2); hold on;
h_post_10 = histogram(dist_SI_post10_z2); hold on;
h_post_30 = histogram(dist_SI_post30_z2); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin_SI;
h_post_10.BinWidth = bin_SI;
h_post_30.BinWidth = bin_SI;
x1=mean_SI_pre_z2;
x2=mean_SI_post10_z2;
x3=mean_SI_post30_z2;
line([x1 x1],[yrange_SI(1) yrange_SI(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange_SI(1) yrange_SI(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange_SI(1) yrange_SI(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
xlim(xrange_short_SI);
ylim(yrange_SI);
SI = title('Slice 2, \DeltaSI(%)', 'Units', 'normalized', 'Position', [0.14, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
set(gca,'xticklabels',num2str(''));

%Slice3, SI*
subaxis(3,1,3,'SpacingVert',0,'MR',0);
h_pre = histogram(dist_SI_pre_z3); hold on;
h_post_10 = histogram(dist_SI_post10_z3); hold on;
h_post_30 = histogram(dist_SI_post30_z3); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin_SI;
h_post_10.BinWidth = bin_SI;
h_post_30.BinWidth = bin_SI;
x1=mean_SI_pre_z3;
x2=mean_SI_post10_z3;
x3=mean_SI_post30_z3;
xlim(xrange_short_SI);
ylim(yrange_SI);
line([x1 x1],[yrange_SI(1) yrange_SI(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange_SI(1) yrange_SI(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange_SI(1) yrange_SI(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
t3 = title('Slice 3, \DeltaSI(%)', 'Units', 'normalized', 'Position', [0.14, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
xlabel('\DeltaSI(%)');

%save Xrange long, SI*
subaxis(3,1,1); xlim(xrange_long_SI);legend({'Pre RT','Post RT, 10min','Post RT, 30min','Mean, Pre RT','Mean, Post RT, 10min','Mean, Post RT, 30min'},'Location','northeast','FontSize',7.5);
subaxis(3,1,2); xlim(xrange_long_SI);
subaxis(3,1,3); xlim(xrange_long_SI); 
saveas(gcf,strcat('Histogram_dSI_',animal_name,'_Xlong.pdf'));
print(gcf,strcat('Histogram_dSI_',animal_name,'_Xlong.eps'), '-depsc2');