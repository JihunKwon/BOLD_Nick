function [t2map_g] = BOLD_Gaussian_postT2(t2map, sigma)
%This function imports estimated t2map and apply 2D gaussian filter to each
%slice of t2map.

t2map_g = zeros(size(t2map));

for z=1:size(t2map,4) %Slice
    for tp=1:size(t2map,3)
        X = t2map(:,:,tp,z);
        t2map_g(:,:,tp,z) = imgaussfilt(X,sigma);
    end
end