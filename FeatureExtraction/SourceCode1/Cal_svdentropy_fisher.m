function [svd_entropy, fisher] = Cal_svdentropy_fisher(eeg_seg)

[svd_entropy, fisher] = inf_theory(eeg_seg);