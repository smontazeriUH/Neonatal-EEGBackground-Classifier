function [Nonlinear_energy, Line_length] = cal_nonlinearEnergy(eeg_seg, fs_new)

[Nonlinear_energy,Line_length] = nonlin(eeg_seg,fs_new);

