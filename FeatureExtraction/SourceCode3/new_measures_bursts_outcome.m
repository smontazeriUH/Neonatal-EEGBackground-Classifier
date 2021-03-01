function fv = new_measures_bursts_outcome(dat, fs, art)
% Estimate several features from the literature that show correlation with
% PMA in preterm infants (<38 weeks GA)
%
% Nathan Stevenson
% QIMR Berghofer 2019
%

%fv(1) = median(bw);

% Suppression Curve
fv(1)=calculateSC_NS(dat, fs, art);

% MSE
fvx = estimate_mse(dat, fs, art);
fv(2) = fvx(1);
fv(3) = fvx(2);
fv(4) = fvx(3);

