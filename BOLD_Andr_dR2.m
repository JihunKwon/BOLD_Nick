clear
close all
load('t2map.mat');
r2map = 1./t2map;

r2map_air = (r2map(:,:,1,1)+r2map(:,:,2,1)+r2map(:,:,3,1))/3;


r2map_o2 = zeros(size(t2map,1),size(t2map,2),size(t2map,3));
d_r2map = zeros(size(t2map,1),size(t2map,2),size(t2map,3));

for i=1:size(t2map,1) %X
    for j=1:size(t2map,2) %Y
        for k=4:size(t2map,3) %Time
            r2map_o2(i,j,k) = r2map_o2(i,j,k) + r2map(i,j,k,1);
        end
    end
end


cb_r2 = [-40 40];
for k=4:size(t2map,3)
    d_r2map(:,:,k) = (r2map_o2(:,:,k) - r2map_air) ./ r2map_air(:,:) * 100;
    
    if (k==4 || k==5 || k==6)
        figure('rend','painters','pos',[10 10 500 500])
        imshow(d_r2map(:,:,k))
        
        colorbar;
        colormap(jet);
        set(gca,'clim',cb_r2);
    end
end

