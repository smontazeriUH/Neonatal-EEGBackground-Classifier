function [t, bm] = detector_per_channel_palmu(eeg_data, Fs, varargin);
% Kirsi's EEG 'burst' detector. Code based on the paper - Palmu et al,
% Physiol Meas 31:85-93, 2010.
%
% [t, bm] = detector_per_channel_palmu(eeg_data, Fs)
%
% Inputs:- eeg_data, a single channel of EEG (vector 1xN)
%              - Fs, sampling frequency of EEG
%               - a vector containing variables for 
%                               win - smoothing duration for the smoothed
%                               nonlinear energy operatoor (SNLEO)
%                               wc - period for baseline correction
%                               md -  minimum burst duration
%                               th - the threshold to determin the presence
%                               of a burst in the SNLEO
%
%  Recommended inputs: win = 1.5, wc = 60, md = 1, th = 1.5
%
% Outputs - time vector (output is sampled at 16Hz - vector 1xM)
%                 - binary burst mask (1 - burst, 0 - not burst - vector 1xM)
%
% Dependencies - requires a IIR bandpass filter with a passband of 0.5-10Hz
%
% Nathan Stevenson
% August 2016
% University of Helsinki

% Initialise Parameters (feel free to tinker)
if length(varargin)==0
    win = 1.5;
    wc = 60;
    md = 1;   
    th = 1.5;
end

load  kirsi_BD_filters_256 % HP 6th order Elliptical fc = 10Hz. LP 1st order Butterworth fc = 0.5Hz

% Initialise Parameters
fs1 = 256; fs2 = 16;
dat = resample(eeg_data, fs1, Fs);  % NB - must be resampled to 256 as NLEO is different when when fs changes .

dat = filter(Num_LP, Den_LP, dat);   % Filter data between 0.5-10Hz
dat = filter(Num_HP, Den_HP, dat);

snleo = nlin_energy(dat, win*fs1);      % Smoothed Absolute Nonlinear Energy Operator
s1 = resample(snleo, fs2, fs1); s2 = s1; % downsample
epl = fs2*wc; 
for ii = epl+1:length(s1);                      % Baseline Correction
    r1 = ii-epl; r2 = ii-1; 
    s2(ii) = s1(ii)-min(s1(r1:r2));
end

bm = zeros(1, length(s1));                  % Generate Burst Mask
bm(s2>th) = 1;
r1 = find(diff([0 bm 0])==1);
r2 = find(diff([0 bm 0])==-1);
qq = find(r2-r1<fs2*md);
for ii = 1:length(qq)                               % Remove short duration bursts
    bm(r1(qq(ii)):r2(qq(ii))-1)=0;
end
t = 0:1/fs2:(length(bm)-1)/fs2;

end