function [AR1, AR2, AR3, AR4, AR5, AR6, AR7, AR8, AR9]=autoregressive_error(eeg_seg)


dat1=eeg_seg(1:floor(end/2));
dat2=eeg_seg(ceil(end/2)+1:end);

fit=ar_prediction_error_ns(dat1,dat2,9);

AR1 = fit(1);

AR2 = fit(2);

AR3 = fit(3);

AR4 = fit(4);

AR5 = fit(5);

AR6 = fit(6);

AR7 = fit(7);

AR8 = fit(8);

AR9 = fit(9);
end
