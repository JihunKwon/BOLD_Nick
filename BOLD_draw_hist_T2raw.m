%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% modified on 10/17/2018 by Jihun Kwon
% Draw histogram of dSI.
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
animal_name='M3';
bin = 3;
co = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560;
0.4660 0.6740 0.1880;
0.3010 0.7450 0.9330;
0.6350 0.0780 0.1840;];
y=0:0.001:0.32;
xrange_short = [-30 30];
xrange_long = [-70 70];
yrange = [0 0.1];

%% Part1: R2*
% Import all time points, all slices
cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PreRT');
load('Position_M3_PreRT.mat');
load('T2map_air_M3_para.mat');
load('T2map_O2_M3_para.mat');
R2_est_air = 1/T2_est_air;
R2_est_O2 = 1/T2_est_O2;
R2_rel_pre = 100*(R2_est_O2-R2_est_air)./R2_est_air;
R2_rel_pre_z1 = R2_rel_pre(:,:,1) .* b_z1;
R2_rel_pre_z2 = R2_rel_pre(:,:,2) .* b_z2;
R2_rel_pre_z3 = R2_rel_pre(:,:,3) .* b_z3;

cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT_10m');
load('Position_M3_PostRT_10m.mat');
load('T2map_air_M3_para.mat');
load('T2map_O2_M3_para.mat');
R2_est_air = 1/T2_est_air;
R2_est_O2 = 1/T2_est_O2;
R2_rel_post10 = 100*(R2_est_O2-R2_est_air)./R2_est_air;
R2_rel_post10_z1 = R2_rel_post10(:,:,1) .* b_z1;
R2_rel_post10_z2 = R2_rel_post10(:,:,2) .* b_z2;
R2_rel_post10_z3 = R2_rel_post10(:,:,3) .* b_z3;

cd('C:\Users\jihun\Documents\MATLAB\BOLD\Est_T1T2map\M3_PostRT_30m');
load('Position_M3_PostRT_30m.mat');
load('T2map_air_M3_para.mat');
load('T2map_O2_M3_para.mat');
R2_est_air = 1/T2_est_air;
R2_est_O2 = 1/T2_est_O2;
R2_rel_post30 = 100*(R2_est_O2-R2_est_air)./R2_est_air;
R2_rel_post30_z1 = R2_rel_post30(:,:,1) .* b_z1;
R2_rel_post30_z2 = R2_rel_post30(:,:,2) .* b_z2;
R2_rel_post30_z3 = R2_rel_post30(:,:,3) .* b_z3;

%% Get histogram if neither nan or zero
num_R2Prez1 = 0;
num_R2Prez2 = 0;
num_R2Prez3 = 0;
num_R2Post10z1 = 0;
num_R2Post10z2 = 0;
num_R2Post10z3 = 0;
num_R2Post30z1 = 0;
num_R2Post30z2 = 0;
num_R2Post30z3 = 0;
for i=1:size(b_z1,1)
    for j=1:size(b_z1,2)
        %Pre
        if (~isnan(R2_rel_pre_z1(i,j)) && (R2_rel_pre_z1(i,j)) ~= 0)
            num_R2Prez1 = num_R2Prez1+1;
            dist_R2_pre_z1(num_R2Prez1) = R2_rel_pre_z1(i,j);
        end
        if (~isnan(R2_rel_pre_z2(i,j)) && (R2_rel_pre_z2(i,j)) ~= 0)
            num_R2Prez2 = num_R2Prez2+1;
            dist_R2_pre_z2(num_R2Prez2) = R2_rel_pre_z2(i,j);
        end
        if (~isnan(R2_rel_pre_z3(i,j)) && (R2_rel_pre_z3(i,j)) ~= 0)
            num_R2Prez3 = num_R2Prez3+1;
            dist_R2_pre_z3(num_R2Prez3) = R2_rel_pre_z3(i,j);
        end
        %10min
        if (~isnan(R2_rel_post10_z1(i,j)) && (R2_rel_post10_z1(i,j)) ~= 0)
            num_R2Post10z1 = num_R2Post10z1+1;
            dist_R2_post10_z1(num_R2Post10z1) = R2_rel_post10_z1(i,j);
        end
        if (~isnan(R2_rel_post10_z2(i,j)) && (R2_rel_post10_z2(i,j)) ~= 0)
            num_R2Post10z2 = num_R2Post10z2+1;
            dist_R2_post10_z2(num_R2Post10z2) = R2_rel_post10_z2(i,j);
        end
        if (~isnan(R2_rel_post10_z3(i,j)) && (R2_rel_post10_z3(i,j)) ~= 0)
            num_R2Post10z3 = num_R2Post10z3+1;
            dist_R2_post10_z3(num_R2Post10z3) = R2_rel_post10_z3(i,j);
        end
        %30min
        if (~isnan(R2_rel_post30_z1(i,j)) && (R2_rel_post30_z1(i,j)) ~= 0)
            num_R2Post30z1 = num_R2Post30z1+1;
            dist_R2_post30_z1(num_R2Post30z1) = R2_rel_post30_z1(i,j);
        end
        if (~isnan(R2_rel_post30_z2(i,j)) && (R2_rel_post30_z2(i,j)) ~= 0)
            num_R2Post30z2 = num_R2Post30z2+1;
            dist_R2_post30_z2(num_R2Post30z2) = R2_rel_post30_z2(i,j);
        end
        if (~isnan(R2_rel_post30_z3(i,j)) && (R2_rel_post30_z3(i,j)) ~= 0)
            num_R2Post30z3 = num_R2Post30z3+1;
            dist_R2_post30_z3(num_R2Post30z3) = R2_rel_post30_z3(i,j);
        end
    end
end

%Calculate mean
mean_T2_pre_z1 = sum(sum(dist_R2_pre_z1))/num_R2Prez1;
mean_T2_pre_z2= sum(sum(dist_R2_pre_z2))/num_R2Prez2;
mean_T2_pre_z3= sum(sum(dist_R2_pre_z3))/num_R2Prez3;
mean_T2_post10_z1 = sum(sum(dist_R2_post10_z1))/num_R2Post10z1;
mean_T2_post10_z2= sum(sum(dist_R2_post10_z2))/num_R2Post10z2;
mean_T2_post10_z3= sum(sum(dist_R2_post10_z3))/num_R2Post10z3;
mean_T2_post30_z1 = sum(sum(dist_R2_post30_z1))/num_R2Post30z1;
mean_T2_post30_z2= sum(sum(dist_R2_post30_z2))/num_R2Post30z2;
mean_T2_post30_z3= sum(sum(dist_R2_post30_z3))/num_R2Post30z3;

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
h_pre.BinWidth = bin;
h_post_10.BinWidth = bin;
h_post_30.BinWidth = bin;
x1=mean_T2_pre_z1;
x2=mean_T2_post10_z1;
x3=mean_T2_post30_z1;
line([x1 x1],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
xlim(xrange_short);
ylim(yrange);
t1 = title('Slice 1', 'Units', 'normalized', 'Position', [0.08, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
set(gca,'xticklabels',num2str(''));

%Slice2
subaxis(3,1,2,'SpacingVert',0,'MR',0);
h_pre = histogram(dist_R2_pre_z2); hold on;
h_post_10 = histogram(dist_R2_post10_z2); hold on;
h_post_30 = histogram(dist_R2_post30_z2); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin;
h_post_10.BinWidth = bin;
h_post_30.BinWidth = bin;
x1=mean_T2_pre_z2;
x2=mean_T2_post10_z2;
x3=mean_T2_post30_z2;
line([x1 x1],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
xlim(xrange_short);
ylim(yrange);
t2 = title('Slice 2', 'Units', 'normalized', 'Position', [0.08, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
set(gca,'xticklabels',num2str(''));

%Slice3
subaxis(3,1,3,'SpacingVert',0,'MR',0);
h_pre = histogram(dist_R2_pre_z3); hold on;
h_post_10 = histogram(dist_R2_post10_z3); hold on;
h_post_30 = histogram(dist_R2_post30_z3); hold on;
h_pre.Normalization = 'probability';
h_post_10.Normalization = 'probability';
h_post_30.Normalization = 'probability';
h_pre.BinWidth = bin;
h_post_10.BinWidth = bin;
h_post_30.BinWidth = bin;
x1=mean_T2_pre_z3;
x2=mean_T2_post10_z3;
x3=mean_T2_post30_z3;
xlim(xrange_short);
ylim(yrange);
line([x1 x1],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(1,:)); hold on;
line([x2 x2],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(2,:)); hold on;
line([x3 x3],[yrange(1) yrange(end)], 'LineWidth',1,'LineStyle','--','Color',co(3,:)); hold on;
t3 = title('Slice 3', 'Units', 'normalized', 'Position', [0.08, 0.86, 0]); % Set Title with correct Position
ylabel('Probability');
xlabel('\DeltaR2*(%)');

cd ..\
%save Xrange short
subaxis(3,1,3); xlim(xrange_short);
legend({'Pre RT','Post RT','Mean, Pre RT','Mean, Post RT'},'Location','northeast','FontSize',8);
saveas(gcf,strcat('Histogram_dR2_',animal_name,'_Xshort.pdf'));

%save Xrange long
subaxis(3,1,1); xlim(xrange_long);
subaxis(3,1,2); xlim(xrange_long);
subaxis(3,1,3); xlim(xrange_long); legend({'Pre RT','Post RT, 10min','Post RT, 30min','Mean, Pre RT','Mean, Post RT, 10min','Mean, Post RT, 30min'},'Location','northeast','FontSize',8);
saveas(gcf,strcat('Histwogram_dR2_',animal_name,'_Xlong.pdf'));