function [dist,mean] = get_dist(map)
%get_dist Get 2D map values such as R2* or T2*. Return 1D histogram and
%mean of histogram

num=0;
for i=1:size(map,1)
    for j=1:size(map,2)
        % if neither nan or zero
        if (~isnan(map(i,j)) && (map(i,j)) ~= 0)
            num = num+1;
            dist(num) = map(i,j);
        end
    end
end

mean = sum(sum(dist))/num;
end

