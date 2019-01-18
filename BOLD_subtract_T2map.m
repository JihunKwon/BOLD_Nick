%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0
% created on 12/09/2018 by Jihun Kwon
% Subtract T2* map of O2 from air (T2*air - T2*oxy).
% Email: jkwon3@bwh.harvard.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

animal_name = 'M4';
time_name = 'PreRT'; %'PreRT'or 'PostRT' or 'Post1w' or 'Post2w'
ani_time_name = strcat(animal_name,'_',time_name);
margins = [.007 .007];
cb_t2sub = [-15 15];
cb_t2rel = [-50 50];

if strcmp(time_name,'PreRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\';
elseif strcmp(time_name,'PostRT')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181128_111344_Berbeco_Bi_Gd_1_26\';
elseif strcmp(time_name,'Post1w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181206_111438_Berbeco_Bi_Gd_1_27\';
elseif strcmp(time_name,'Post2w')
    base_name = 'C:\Users\jihun\Documents\MATLAB\BOLD\20181217_124457_Berbeco_Bi_Gd_1_28\';
end


cd(base_name)
%cd T2_dynamic\results_G0.5
%cd T2_dynamic_tumor\results_G05
%cd T2_dynamic_brain\results_G1_Andr
cd T2_dynamic\results_tr_G05
load('t2map.mat')

T2sub = zeros(size(t2map));
T2sub_air_ave = zeros(size(t2map));
T2rel_air_ave = zeros(size(t2map));

for z = 1:3
    for i = 2:size(t2map,3)
        T2sub(:,:,i,z) = t2map(:,:,i,z) - t2map(:,:,1,z);
    end
end

for z = 1:3
    for i = 1:size(t2map,3)
        T2sub_air_ave(:,:,i,z) = t2map(:,:,i,z) - (t2map(:,:,1,z)+t2map(:,:,2,z)+t2map(:,:,3,z))/3;
    end
end
% 
% figure
% imagesc(t2map(:,:,1,1));
% colormap gray; 

%% other - air1
for z=1:3
    figure(z); %subtraction, z1
    set(gcf,'Position',[100 100 1300 500], 'Color', 'w')
    z_s = num2str(z);
    for i=2:8 %6
        subplot_tight(2,5,i-1,margins), imagesc(T2sub(:,:,i,z)), title(strcat(num2str(i),'-1, z',z_s)); 
        colorbar; colormap(redblue); set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); axis off;
    end
    savename = strcat('T2sub_',time_name,'_z',z_s,'_brain_Andr.tif');
    saveas(gcf,savename);
    export_fig((savename), '-q101')
end

%% other - air(average)
for z=1:3
    figure(z+3); %subtraction, z1
    set(gcf,'Position',[100 100 1300 500], 'Color', 'w')
    z_s = num2str(z);
    for i=2:6
        subaxis(2,5,i-1,'SpacingVert',0.01,'SpacingHoriz',0.005);
        imagesc(T2sub_air_ave(:,:,i,z)), 
        title(strcat(num2str(i),'-air, z',z_s)); 
        %colorbar;
        colormap(redblue); 
        set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); 
        axis off;
    end
    savename = strcat('T2sub_airave',time_name,'_z',z_s,'_tr_G05.tif');
    saveas(gcf,savename);
    export_fig((savename), '-q101')
end


%% other - air1+air2(average)
%Air_ave has to be calculated from "TWO" air images
for z = 1:3
    for i = 1:size(t2map,3)
        T2sub_air_ave(:,:,i,z) = t2map(:,:,i,z) - (t2map(:,:,1,z)+t2map(:,:,2,z))/2;
    end
end

for z=1:3
    figure(z); %subtraction, z1
    set(gcf,'Position',[100 100 1300 500], 'Color', 'w')
    z_s = num2str(z);
    for i=1:5
        subaxis(1,5,i,'SpacingVert',0.01,'SpacingHoriz',0.005);
        imagesc(T2sub_air_ave(:,:,i,z)), 
        title(strcat(num2str(i),'-air, z',z_s)); 
        %colorbar;
        colormap(redblue); 
        set(gca,'clim',cb_t2sub,'dataAspectRatio',[1 1 1]); 
        axis off;
    end
    savename = strcat('T2sub_airave',time_name,'_z',z_s,'_tr_G05.tif');
    saveas(gcf,savename);
    export_fig((savename), '-q101')
end


%% (other - air(average))/ air(ave)
for z = 1:3
    for i = 1:size(t2map,3)
        
        if strcmp(time_name,'PreRT')
            air_ave = (t2map(:,:,1,z)+t2map(:,:,2,z)+t2map(:,:,3,z))/3;
        elseif strcmp(time_name,'PostRT')
            air_ave = (t2map(:,:,1,z)+t2map(:,:,2,z)+t2map(:,:,3,z))/3;
        elseif strcmp(time_name,'Post1w')
            air_ave = (t2map(:,:,1,z)+t2map(:,:,2,z)+t2map(:,:,3,z))/3;
        elseif strcmp(time_name,'Post2w')
            air_ave = (t2map(:,:,1,z)+t2map(:,:,2,z))/2;
        end
        T2rel_air_ave(:,:,i,z) = 100*(t2map(:,:,i,z) - air_ave)./air_ave;
        %T2rel_air_ave(:,:,i,z) = 100*(t2map(:,:,i,z) - t2map(:,:,1,z))./t2map(:,:,1,z);
    end
end
for z=1:3
    figure(z+3); %subtraction, z1
    set(gcf,'Position',[100 100 1300 500], 'Color', 'w')
    z_s = num2str(z);
    for i=2:6
        subaxis(2,5,i-1,'SpacingVert',0.01,'SpacingHoriz',0.005);
        imagesc(T2rel_air_ave(:,:,i,z)), 
        title(strcat(num2str(i),', z',z_s)); 
        %colorbar;
        colormap(redblue); 
        set(gca,'clim',cb_t2rel,'dataAspectRatio',[1 1 1]); 
        axis off;
    end
    savename = strcat('T2rel_airave',time_name,'_z',z_s,'_tr_G05.tif');
    saveas(gcf,savename);
    export_fig((savename), '-q101')
end
