function bandpower_norm = band_norm_toronto(eeg_seg, fs_new,ff)

if (length(eeg_seg)-1)/(2*length(eeg_seg)) <= 32 || (length(eeg_seg)-1)/(2*length(eeg_seg)) <= max(ff)
    total_power = bandpower(eeg_seg);
    band = bandpower(eeg_seg, fs_new, ff);
    bandpower_norm = band./total_power;
else
    bandpower_norm = 1*NaN;
end