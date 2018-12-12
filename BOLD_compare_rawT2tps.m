cd('C:\Users\jihun\Documents\MATLAB\BOLD')
load('rawT2_pre_1d_1w.mat')
figure;
set(gcf,'Position',[200 200 700 700], 'Color', 'w')
%Slice 1
subaxis(3,3,1,'SpacingVert',0.03,'SpacingHoriz',0.005);
plot(1:11,values_dT2_pre(1:11,1,1),'-o'); hold on;
plot(1:11,values_dT2_pre(1:11,2,1),'-s'); hold on;
ylabel({'Z1';'T2* (ms)'});
title('Pre RT');
xlim([0 12]); ylim([0 45]);
yl = get(gca, 'YLim');
line( [3.5 3.5], yl,'Color','black','LineStyle','--'); hold on;

subaxis(3,3,2,'SpacingVert',0.03,'SpacingHoriz',0.005);%Post 1d
plot(1:11,values_dT2_1d(1:11,1,1),'-o'); hold on;
plot(1:11,values_dT2_1d(1:11,2,1),'-s'); hold on;
title('1d Post RT');
xlim([0 12]); ylim([0 45]);
set(gca,'ytick',[])
yl = get(gca, 'YLim');
line( [3.5 3.5], yl,'Color','black','LineStyle','--'); hold on;

subaxis(3,3,3,'SpacingVert',0.03,'SpacingHoriz',0.005);%Post 1w
plot(1:16,values_dT2_1w(1:16,1,1),'-o'); hold on;
plot(1:16,values_dT2_1w(1:16,2,1),'-s'); hold on;
title('1w Post RT');
xlim([0 17]); ylim([0 45]);
set(gca,'ytick',[])
yl = get(gca, 'YLim');
line( [3.5 3.5], yl,'Color','black','LineStyle','--'); hold on;
line( [6.5 6.5], yl,'Color','black','LineStyle','--'); hold on;
line( [11.5 11.5], yl,'Color','black','LineStyle','--'); hold on;
legend('Left Tumor','Right Tumor','Location','northeast');
%Slice 2
subaxis(3,3,4,'SpacingVert',0.03,'SpacingHoriz',0.005);%Pre
plot(1:11,values_dT2_pre(1:11,1,2),'-o'); hold on;
plot(1:11,values_dT2_pre(1:11,2,2),'-s'); hold on;
ylabel({'Z2';'T2* (ms)'});
xlim([0 12]); ylim([0 45]);
yl = get(gca, 'YLim');
line( [3.5 3.5], yl,'Color','black','LineStyle','--'); hold on;

subaxis(3,3,5,'SpacingVert',0.03,'SpacingHoriz',0.005);%Post 1d
plot(1:11,values_dT2_1d(1:11,1,2),'-o'); hold on;
plot(1:11,values_dT2_1d(1:11,2,2),'-s'); hold on;
xlim([0 12]); ylim([0 45]);
set(gca,'ytick',[])
yl = get(gca, 'YLim');
line( [3.5 3.5], yl,'Color','black','LineStyle','--'); hold on;

subaxis(3,3,6,'SpacingVert',0.03,'SpacingHoriz',0.005); %Post 1wd
plot(1:16,values_dT2_1w(1:16,1,2),'-o'); hold on;
plot(1:16,values_dT2_1w(1:16,2,2),'-s'); hold on;
xlim([0 17]); ylim([0 45]);
set(gca,'ytick',[])
yl = get(gca, 'YLim');
line( [3.5 3.5], yl,'Color','black','LineStyle','--'); hold on;
line( [6.5 6.5], yl,'Color','black','LineStyle','--'); hold on;
line( [11.5 11.5], yl,'Color','black','LineStyle','--'); hold on;
%Slice 3
subaxis(3,3,7,'SpacingVert',0.03,'SpacingHoriz',0.005);%Pre
plot(1:11,values_dT2_pre(1:11,1,3),'-o'); hold on;
plot(1:11,values_dT2_pre(1:11,2,3),'-s'); hold on;
xlabel('Time'); ylabel({'Z3';'T2* (ms)'});
xlim([0 12]); ylim([0 45]);
yl = get(gca, 'YLim');
line( [3.5 3.5], yl,'Color','black','LineStyle','--'); hold on;

subaxis(3,3,8,'SpacingVert',0.03,'SpacingHoriz',0.005);%Post 1d
plot(1:11,values_dT2_1d(1:11,1,3),'-o'); hold on;
plot(1:11,values_dT2_1d(1:11,2,3),'-s'); hold on;
xlabel('Time');
xlim([0 12]); ylim([0 45]);
set(gca,'ytick',[])
yl = get(gca, 'YLim');
line( [3.5 3.5], yl,'Color','black','LineStyle','--'); hold on;

subaxis(3,3,9,'SpacingVert',0.03,'SpacingHoriz',0.005); %Post 1w
plot(1:16,values_dT2_1w(1:16,1,3),'-o'); hold on;
plot(1:16,values_dT2_1w(1:16,2,3),'-s'); hold on;
xlabel('Time');
xlim([0 17]); ylim([0 45]);
set(gca,'ytick',[])
yl = get(gca, 'YLim');
line( [3.5 3.5], yl,'Color','black','LineStyle','--'); hold on;
line( [6.5 6.5], yl,'Color','black','LineStyle','--'); hold on;
line( [11.5 11.5], yl,'Color','black','LineStyle','--'); hold on;

saveas(gcf,'T2_compare_PrePost.tif');
export_fig T2_compare_PrePost.tif -q101