function [flipped] = flip2y(original)
%flip2y this function flip 2D-matrix to y direction (not x)
%       this is useful when comparing imshow and contour plot

k=size(original,1);
for i=1:size(original,1)
    k = size(original,1)-i+1;
    for j=1:size(original,2)
        flipped(i,j) = original(k,j);
    end
end
end

