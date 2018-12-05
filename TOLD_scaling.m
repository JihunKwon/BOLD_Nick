function [values_scaled,values_scaled_rel] = TOLD_scaling(values_air,values_oxy,values)
%TOLD_scaling This function scales dynamic TOLD signal to match timepoint1
%to air(baseline) image and the last timpoint to oxygen image.
%INPUT:
% values_air: ROI value from T1map at baseline (1*ROI*Slice)
% values_oxy: ROI value from T1map at oxy breathiing (1*ROI*Slice)
% values: ROI values from dynamic psudo-T1map (Time*ROI*Slice)
%OUTPUT
% values_scaled: scallled value of dynamic TOLD(Time*ROI*Slice)

Vec_air = [0 0 0];
Vec_oxy = [0 0 0];
values_tot = zeros(size(values,1),1,3);
values_tot_air = zeros(size(values_air,1),1,3);
values_tot_oxy = zeros(size(values_oxy,1),1,3);
values_scale2oxy = zeros(size(values,1),3);

%sum up all ROIs
for tp = 1:size(values,1)
    for roi = 1:size(values,2)
        values_tot(tp,1,:) = values_tot(tp,1,:)+values(tp,roi,:);
        values_tot_air(1,1,:) = values_tot_air(1,1,:)+values_air(1,roi,:);
        values_tot_oxy(1,1,:) = values_tot_oxy(1,1,:)+values_oxy(1,roi,:);
    end
end

%Calculate ratio of ROIs
for tp = 1:size(values,1)
    values_ratio_roi1(tp,:) = squeeze(values(tp,1,:) ./ values_tot(tp,1,:))';
    values_ratio_roi2(tp,:) = 1 - values_ratio_roi1(tp,:);
    values_ratio_roi_all(tp,1,:) = values_ratio_roi1(tp,:);
    values_ratio_roi_all(tp,2,:) = values_ratio_roi2(tp,:);
end

%Eliminate second dimension (ROI number)
values_tot_sq = squeeze(values_tot);
values_tot_air_sq = squeeze(values_tot_air)';
values_tot_oxy_sq = squeeze(values_tot_oxy)';

%% Scale to baseline
%Get Scalar vector to scale "dynamic" to baseline (T1wI)
Vec_air = values_tot_air_sq(1,:) ./ values_tot_sq(1,:);
Vec_air = squeeze(Vec_air);

%Apply "baseline" Scalar vector to all timpoints of dynamic TOLD
for tp = 1:size(values,1)
    values_scale2air(tp,:) = values_tot_sq(tp,3) .* Vec_air;
end

%% Scale to oxygen (last timepoint)
%Compare T1wI values, air vs oxy
%scalefactor = T1map(oxy,last) / psudo-T1map(oxy,last)
scalefactor = squeeze(values_tot_oxy_sq./values_scale2air(size(values_scale2air,1),:));

%scale dynamic TOLD to oxygen T1map by scalefactor. (Except 1st tp)
values_scale2oxy(1,:) = values_tot_air_sq;
for tp = 2:size(values,1)
    values_scale2oxy(tp,:) = values_scale2air(tp,:) .* scalefactor;
end

values_scale2oxy_new = values_scale2oxy;
values_scale2oxy_new(end, end, 2) = 0;
values_scale2oxy_new(:,:,2) = 1;
values_scale2oxy_new = permute(values_scale2oxy_new, [1,3,2]);
%Raw value (signal intensity)
for tp = 1:size(values,1)
    for roi = 1:size(values,2)
        values_scaled(tp,roi,:) = values_scale2oxy_new(tp,1,:) .* values_ratio_roi_all(tp,roi,:);
    end
end
%Relative change (TOLD.) !Using average of baseline instead of using only
%the first air timpoint.
for tp = 1:size(values,1)
    for roi = 1:size(values,2)
        values_scaled_rel(tp,roi,:) = (values_scaled(tp,roi,:) - values_scaled(1,roi,:))...
            ./ values_scaled(1,roi,:)*100;
    end
end

end