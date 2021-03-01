function [ASIval,ETDFval,tau] = getASI(signals,fs,params)   
% function [ASIval,ETDFval,tau] = getASI(signals,fs,params)   

% Returns Activation Synchrony Index (ASI) between two time-series signals.
%
%   getASI(signals,fs) returns the ASI computed from the two signals 
%   in a Nx2 matrix, where N is the number of samples in both signals, and
%   fs is the sampling rate of the signals.
%
%   getASI(signals,fs,params) will use custom parameters in ASI
%   computation with parameters defined in a following struct:
%
%       params.window_step_size = 0.1;  % Window step size (in seconds)
%       params.window_size = 2;         % ETDF Window size (in seconds)
%       params.etdf_len = 5;            % Length of etdf (in seconds)
%       params.freq_cutoff_hz = 1.5;    % Highpass cutoff freq (in Hz)
%       params.cbsize = 8;              % Codebook size 
%   
%   Default values for different parameters are as defined above.
%
%
%   Outputs:
%
%   ASIval      =   ASI-index. Higher means more synchrony. ASIval close to 1 means random.
%   ETDFval        =   Energy-weighted temporal dependency function (ETDF) between the two
%                   signals (see Rasanen & Vanhatalo, NeuroImage, 2013).
%   tau         =   timestamps for the ETDFval  
%
%   USE EXAMPLE:
%   
%   Syntax:
%
%   [ASIval,ETDFval] = getASI(randn(15000,2),50)
%
%   will compute ASI from two random signals with assumed fs of 50 Hz.
% 
%   Note! Longer signals give more accurate ASI estimates.
%
%   (c) Okko Rasanen & Sampsa Vanhatalo, 2013


if(fs ~= 50)
    signals = resample(signals,50,fs);                                       % Downsample to 50 Hz
    fs = 50;
end

% Algorithm parameters
if(nargin <3)
    window_step_size = 0.1;     % Window step size (in seconds, default 0.1)
    window_size = 2;            % Energy envelope (FFT) window size (in seconds, default 2)
    etdf_len = 5;               % Length of etdf (+- seconds around zero delay; default 5)
    freq_cutoff_hz = 1.5;       % Highpass cutoff freq (default 1.5 Hz)
    cbsize = 8;                 % Codebook size (default 8)
else
    window_step_size = params.window_step_size;
    window_size = params.window_size;        
    etdf_len = params.etdf_len;       
    freq_cutoff_hz = params.freq_cutoff_hz;
    cbsize = params.cbsize;
end

% Define highpass cutoff in frequency bins
f = 0:fs/(window_size*fs):fs/2;
freq_cutoff = find(f >= freq_cutoff_hz,1);

% Concatenate both signals into one long signal
signals_concatenated = reshape(signals,numel(signals),1);

% Compute FFT features for the entire signal
fft_concatenated = getFFT(signals_concatenated,window_size,window_step_size,fs);
% Compute energy envelope as the sum across frequencies between lower and
% higher cutoff frequencies.
envelope_concatenated = sum(fft_concatenated(:,freq_cutoff:end),2)./length(freq_cutoff:51);

% Compute quantization codebook using the data from both signal channels
warning off all;
rng(1)
[~,codebook] = kmeans(envelope_concatenated,cbsize);
warning on all;

% Quantize energy envelopes of both channels separately using the obtained codebook

VQ_indices = cell(2,1);
for channel = 1:2
    % Energy envelope
    tmp = getFFT(signals(:,channel),window_size,window_step_size,fs);    
    envelope = sum(tmp(:,freq_cutoff:end),2)./length(freq_cutoff:51);
    
    % Nearest codebook entry for each frame
    d = pdist2(codebook,envelope,'euclidean');
    
    % Select the nearest VQ index for each frame
    [~,labels] = sort(d,'ascend');    
    VQ_indices{channel} = labels(1,:);
end

% Assign quantization indices and corresponding energy levels to
% variables "seq" and "en" for both channels.
seq1 = VQ_indices{1};
seq2 = VQ_indices{2};

en1 = codebook(seq1);
en2 = codebook(seq2);

fs = 1/window_step_size;

% Compute Energy-weighted temporal dependency function (ETDF) for different
% delays between the channels.
miffi = zeros(2*etdf_len*fs+1,1);
j = 1;
for delay = -etdf_len*fs:etdf_len*fs
    miffi(j) = ETDF(seq1,seq2,en1,en2,delay);
    j = j+1;
end

tau = -etdf_len:1/fs:etdf_len;

miffi = miffi-min(miffi);

% Define outputs
ASIval = miffi(etdf_len*fs+1)./mean(miffi);
ETDFval = miffi;


