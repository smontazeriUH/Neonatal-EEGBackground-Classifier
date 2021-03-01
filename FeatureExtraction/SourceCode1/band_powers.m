
function [band,band_norm]=band_powers(eeg_seg,fs_new)
[band(1,1)] = (bandpower_toronto(eeg_seg, fs_new,[0 2]));

[band(1,2)] = (bandpower_toronto(eeg_seg, fs_new,[1 3]));

[band(1,3)] = (bandpower_toronto(eeg_seg, fs_new,[2 4]));

[band(1,4)] = (bandpower_toronto(eeg_seg, fs_new,[3 5]));

[band(1,5)] = (bandpower_toronto(eeg_seg, fs_new,[4 6]));

[band(1,6)] = (bandpower_toronto(eeg_seg, fs_new,[5 7]));

[band(1,7)] = (bandpower_toronto(eeg_seg, fs_new,[6 8]));

[band(1,8)] = (bandpower_toronto(eeg_seg, fs_new,[7 9]));

[band(1,9)] = (bandpower_toronto(eeg_seg, fs_new,[8 10]));

[band(1,10)] = (bandpower_toronto(eeg_seg, fs_new,[9 11]));

[band(1,11)] = (bandpower_toronto(eeg_seg, fs_new,[10 12]));

[band(1,12)] = (bandpower_toronto(eeg_seg, fs_new,[13 30]));

% normalized

[band_norm(1,1)] = (band_norm_toronto(eeg_seg, fs_new,[0 2]));

[band_norm(1,2)] = (band_norm_toronto(eeg_seg, fs_new,[1 3]));

[band_norm(1,3)] = (band_norm_toronto(eeg_seg, fs_new,[2 4]));

[band_norm(1,4)] = (band_norm_toronto(eeg_seg, fs_new,[3 5]));

[band_norm(1,5)] = (band_norm_toronto(eeg_seg, fs_new,[4 6]));

[band_norm(1,6)] = (band_norm_toronto(eeg_seg, fs_new,[5 7]));

[band_norm(1,7)] = (band_norm_toronto(eeg_seg, fs_new,[6 8]));

[band_norm(1,8)] = (band_norm_toronto(eeg_seg, fs_new,[7 9]));

[band_norm(1,9)] = (band_norm_toronto(eeg_seg, fs_new,[8 10]));

[band_norm(1,10)] = (band_norm_toronto(eeg_seg, fs_new,[9 11]));

[band_norm(1,11)] = (band_norm_toronto(eeg_seg, fs_new,[10 12]));

[band_norm(1,12)] = (band_norm_toronto(eeg_seg, fs_new,[13 30]));