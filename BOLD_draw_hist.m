%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/17/2018 by Jihun Kwon
% Draw histogram of pre and post RT
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
bin = 1.5;
co = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560;
0.4660 0.6740 0.1880;
0.3010 0.7450 0.9330;
0.6350 0.0780 0.1840;];
y=0:0.001:0.32;
xrange_short = [-30 30];
xrange_long = [-50 50];
yrange = [0 0.23];
%% draw histogram
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PreRT');
load('Dist_T2sub_M3_PreRT.mat');
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT');
load('Dist_T2sub_M3_PostRT.mat');
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT_30m');
load('Dist_T2sub_M3_PostRT_30m.mat');

figure('Position', [391 1 500 700]);
subaxis(3,1,1,'SpacingVert',0,'MR',0);
histogram(dist_T2_z1_pre);
h_pre = histogram(dist_T2_z1_pre); hold on;
h_post_10 = histogram(dist_T2_z1_post); hold on;
h_post_30 = histogram(dist_T2_z1_post_30); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin;
h_post_10.BinWidth = bin;
h_post_30.BinWidth = bin;
x1=mean_T2_z1_pre;
x2=mean_T2_z1_post;
x3=mean_T2_z1_post_30;
line([x1 x1],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
xlim(xrange_short);
ylim(yrange);
t1 = title('Slice 1', 'Units', 'normalized', 'Position', [0.08, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
set(gca,'xticklabels',num2str(''));

subaxis(3,1,2,'SpacingVert',0,'MR',0);
h_pre = histogram(dist_T2_z2_pre); hold on;
h_post_10 = histogram(dist_T2_z2_post); hold on;
h_post_30 = histogram(dist_T2_z2_post_30); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin;
h_post_10.BinWidth = bin;
h_post_30.BinWidth = bin;
x1=mean_T2_z2_pre;
x2=mean_T2_z2_post;
x3=mean_T2_z2_post_30;
line([x1 x1],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
xlim(xrange_short);
ylim(yrange);
t2 = title('Slice 2', 'Units', 'normalized', 'Position', [0.08, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
set(gca,'xticklabels',num2str(''));

subaxis(3,1,3,'SpacingVert',0,'MR',0);
h_pre = histogram(dist_T2_z3_pre); hold on;
h_post_10 = histogram(dist_T2_z3_post); hold on;
h_post_30 = histogram(dist_T2_z3_post_30); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin;
h_post_10.BinWidth = bin;
h_post_30.BinWidth = bin;
x1=mean_T2_z3_pre;
x2=mean_T2_z3_post;
x3=mean_T2_z3_post_30;
xlim(xrange_short);
ylim(yrange);
line([x1 x1],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
t3 = title('Slice 3', 'Units', 'normalized', 'Position', [0.08, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
xlabel('Subtraction (ms)');

cd ..\
%save Xrange short
subaxis(3,1,1); xlim(xrange_short);
legend({'Pre RT','Post RT','Mean, Pre RT','Mean, Post RT'},'Location','northeast','FontSize',8);
saveas(gcf,strcat('Histogram_',animal_name,'_Xshort.pdf'));

%save Xrange long
subaxis(3,1,1); xlim(xrange_long); legend({'Pre RT','Post RT, 10min','Post RT, 30min','Mean, Pre RT','Mean, Post RT, 10min','Mean, Post RT, 30min'},'Location','northeast','FontSize',8);
subaxis(3,1,2); xlim(xrange_long);
subaxis(3,1,3); xlim(xrange_long);
saveas(gcf,strcat('Histogram_',animal_name,'_Xlong.pdf'));

tar = dist_T2_z3_pre;
pos = 0;
neg = 0;
for i=1:size(tar,2)
    if tar(1,i)>0
        pos = pos+1;
    else
        neg = neg+1;
    end
end
pos_per = pos/size(tar,2)*100;
neg_per = neg/size(tar,2)*100;