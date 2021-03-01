function out= adurplot(areas,durations,Fs,bins)
scale = 1/Fs;
durbins = 50:100:1350;
firstbin=durbins(1); first_bin = firstbin*scale; 
endbin=durbins(end); 
reduced_bins= exp(linspace(log(min(durations)),log(max(durations)),bins));

% All data with unique durations
durs_bin = unique(durations); %Find first unique bins
durs_bin = durs_bin(durs_bin>=first_bin*2); %Discard small durations (optional)
area_bin_all = zeros(1,numel(durs_bin)); %Bin areas according to durs_bin
area_mat= cell(1,numel(durs_bin)-1); %Areas corresponding to durs
dur_loc= cell(1,numel(durs_bin)-1);
are_loc= cell(1,numel(durs_bin)-1);  %indices of durations
for n = 1:numel(durs_bin);
    area_bin_all(n) = mean(areas(durs_bin(n)==durations));
    area_mat{n} = areas(durs_bin(n)==durations);
    dur_loc{n} = find(durs_bin(n)==durations);
end

% Re-bin durations according to reduced bin space
rebinned_durs=cell(1,length(reduced_bins)-1);
rebinned_area=cell(1,length(reduced_bins)-1);
for k=1:length(reduced_bins)-1
    rebinned_durs{k}=durs_bin(durs_bin>=reduced_bins(k)&durs_bin<reduced_bins(k+1));
end
rebinned_durs= rebinned_durs(~cellfun('isempty',rebinned_durs));
duration_bin = cellfun(@median,rebinned_durs);

area_bin = cell(1,numel(reduced_bins));
% Re-bin areas according to re-binned durations
for k=1:length(rebinned_durs)
    if numel(rebinned_durs{k})==1
        area_bin{k}=median(areas(rebinned_durs{k}==durations));
    else
        areas_within=cell(1,length(rebinned_durs)-1);
        for n = 1:length(rebinned_durs{k})
            areas_within{n}=median(areas(rebinned_durs{k}(n)==durations));
        end
        areas_within = cell2mat(areas_within);
        area_bin{k}= median(areas_within);
    end
end
area_bin= area_bin(~cellfun('isempty',area_bin));
area_bin= cell2mat(area_bin);

fit_rf = robustfit(log(area_bin),log(duration_bin));

out.xbin=area_bin;
out.ybin=duration_bin;
out.fit=fit_rf;

end