%-------------------------------------------------------------------------------
% calculate_features: feature extraction for each epoch of EEG using parallel processing
%
% Syntax: feats = calculate_features(eeg_seg,fs_new,features,labels,artefactThreshold)
%
% Inputs:
%     eeg_data            - EEG signal
%     fs_new	          - sampling frequency
%     features            - list of features
%     labels              - label of channels
%     artefactThreshold   - channel rejection threshold
%
% Outputs:
%     feats               - features
%
% Saeed Montazeri M., University of Helsinki
% Started: 10-11-2019
%-------------------------------------------------------------------------------
function [feats] = extractFeatures(eeg_seg,fs_new,features,labels,artefactThreshold)

% rejecting artefact-contaminated channels
eeg_seg_accepted = cell(1);
acceptedChannel = cell(1);
findNan = isnan(eeg_seg);
k = 1;
for ch = 1:size(findNan,1)
    nansInCh = sum(findNan(ch,:));
    if nansInCh <= (artefactThreshold/100) * length(findNan(ch,:))
        acceptedChannel{k} = labels{ch};
        eeg_seg_accepted{k,:} = eeg_seg(ch,~isnan(eeg_seg(ch,:)));
        k = k + 1;
    end
end

% calculating ASI and BSI features
if size(acceptedChannel,2) == size(labels,2)
    %     Inter-hemispheric features
    % Asymmetry index
    asi = cal_ASI(eeg_seg,fs_new,labels);
    
    % Brain symmetry index
    NanInChs = sum(~findNan);
    signal = eeg_seg(:,NanInChs == size(labels,2));
    bsi = estimate_bsi(signal,fs_new,[0 20],labels); %freq_range=[0 20]
    
else
    asi = NaN;
    bsi = NaN;
end

% rejecting artefact-contaminated epochs
if size(acceptedChannel,2) >= round(0.5 * size(labels,2))
    
    % feature extraction
    parfor ch = 1 : size(eeg_seg_accepted, 1)
        eeg_pure = eeg_seg_accepted{ch,:};
        eeg_pure = eeg_pure(~isnan(eeg_pure));
        
        win_size = length(eeg_pure);
        freq = fs_new*(0:win_size/2)/win_size;
        
        % preparation
        [~,inst_amp_channelwise,inst_freq_channelwise] = process_imf(eeg_pure,fs_new);
        
        % First 4 moments of instantaneous amplitude (4)
        amp_mean_channelwise(ch) = mean(inst_amp_channelwise,2);
        amp_variance_channelwise(ch) = var(inst_amp_channelwise,0,2);
        amp_skew_channelwise(ch) = skewness(inst_amp_channelwise');
        amp_kurt_channelwise(ch) = kurtosis(inst_amp_channelwise');
        
        % First 4 moments of instantaneous frequency (4)
        freq_mean_channelwise(ch) = mean(inst_freq_channelwise,2);
        freq_variance_channelwise(ch) = var(inst_freq_channelwise,0,2);
        freq_skew_channelwise(ch) = skewness(inst_freq_channelwise');
        freq_kurt_channelwise(ch) = kurtosis(inst_freq_channelwise');
        
        % Covariance between instantaneous amplitude and instantaneous frequency
        Cov_IA_IF_channelwise(ch) = calc_cov(inst_amp_channelwise,inst_freq_channelwise);
        
        % Complexity features
        fractal_dim_channelwise(ch) = calc_FD(eeg_pure);
        
        % Monofractal analysis
        
        dfa_channelwise(ch) = monofractal_analysis(eeg_pure);
        [mdfa_channelwise(ch),...
            mdfa_max_channelwise(ch)] = multifractal_analysis(eeg_pure);
        
        % Inter-burst intervals
        [burst_nro_channelwise(ch),burst_duration_channelwise(ch),...
            ibi_channelwise(ch)] = calc_burst_features(eeg_pure, fs_new);
        
        
        % rEEG features
        [rEEG_5_channelwise(ch),...
            m_med_channelwise(ch)] = estimate_rEEG(eeg_pure, fs_new);
        
        % kurtosis
        kurt_channelwise(ch) = kurtosis(eeg_pure');
        
        % skewness
        skew_channelwise(ch) = skewness(eeg_pure');
        
        % total power
        total_power_channelwise(ch) = bandpower_toronto(eeg_pure', fs_new, [0 30]);
        
        % bandpowers: 0-2, 1-3, 2-4,...,10-12, 12-30 and normalized bandpowers
        [band_channelwise(ch,:),band_norm_channelwise(ch,:)] = band_powers(eeg_pure',fs_new);
        
        % wavelet energy
        wavelet_energy_channelwise(ch) = wavelet_coeff_toronto(eeg_pure,fs_new);
        
        % number of minima and maxima
        min_max_channelwise(ch) = minmax_kt_toronto(eeg_pure);
        
        % rms amplitude
        RMS_amp_channelwise(ch) = RMS_amplitude_toronto(eeg_pure);
        
        % shannon entropy
        H_shannon_channelwise(ch) = cal_shanon(eeg_pure);
        
        % hjorth parameters
        [activity_channelwise(ch), mobility_channelwise(ch),...
            complexity_channelwise(ch)] = hjorth_toronto(eeg_pure);
        
        % (nlin energy)
        [Nonlinear_energy_channelwise(ch),...
            Line_length_channelwise(ch)] = cal_nonlinearEnergy(eeg_pure,fs_new);
        
        % zero crossings
        Zero_crossings_channelwise(ch) = cal_zerocrossing(eeg_pure);
        
        [AR1_channelwise(ch), AR2_channelwise(ch), AR3_channelwise(ch),...
            AR4_channelwise(ch), AR5_channelwise(ch), AR6_channelwise(ch),...
            AR7_channelwise(ch), AR8_channelwise(ch),...
            AR9_channelwise(ch)] = autoregressive_error(eeg_pure);
        
        % singular value decomposition entropy and Fisher entropy
        [svd_entropy_channelwise(ch),...
            fisher_channelwise(ch)] = Cal_svdentropy_fisher(eeg_pure);
        
        % zero crossings first and second derivative and variance first and second derivative
        [ZC1d_channelwise(ch), ZC2d_channelwise(ch), V1d_channelwise(ch),...
            V2d_channelwise(ch)] = raw_analysis_toronto(eeg_pure);
        
        % Frequency features
        [pxx, ~] = periodogram(eeg_pure);
        
        % peak frequency
        peak_freq_channelwise(ch) = dominant_freq_toronto(pxx);
        
        % spectral entropy
        H_spectral_channelwise(ch) = cal_spectral_entropy(pxx);
        
        % spectral edge frequencies: 90, 95, 80
        [SEF90_channelwise(ch), TP] = spectral_edge_toronto(pxx,freq,0.5,12,.9);
        
        [SEF95_channelwise(ch), TP] = spectral_edge_toronto(pxx,freq,0.5,12,.95);
        
        [SEF80_channelwise(ch), TP] = spectral_edge_toronto(pxx,freq,0.5,12,.8);
        
        art_ch = zeros(1, length(eeg_pure));
        fv1_channelwise(ch,:) = burst_measures_original(eeg_pure, art_ch, fs_new); % burst metrics

        fv2_channelwise(ch,:) = new_measures_bursts_outcome(eeg_pure, fs_new, art_ch); % other measures including MSE, rEEG, and suppression curve
        
    end
    
    amp_mean = nanmedian(amp_mean_channelwise);
    amp_variance = nanmedian(amp_variance_channelwise);
    amp_skew = nanmedian(amp_skew_channelwise);
    amp_kurt = nanmedian(amp_kurt_channelwise);
    freq_mean = nanmedian(freq_mean_channelwise);
    freq_variance = nanmedian(freq_variance_channelwise);
    freq_skew = nanmedian(freq_skew_channelwise);
    freq_kurt = nanmedian(freq_kurt_channelwise);
    Cov_IA_IF=nanmedian(Cov_IA_IF_channelwise);
    fractal_dim=nanmedian(fractal_dim_channelwise);
    dfa=nanmedian(dfa_channelwise);
    mdfa=nanmedian(mdfa_channelwise);
    mdfa_max=nanmedian(mdfa_max_channelwise);
    burst_nro = median(burst_nro_channelwise);
    burst_duration = nanmedian(burst_duration_channelwise);
    ibi = nanmedian(ibi_channelwise);
    m_med=nanmedian(m_med_channelwise);
    rEEG_5=nanmedian(rEEG_5_channelwise);
    
    kurt = nanmedian(kurt_channelwise);
    skew = nanmedian(skew_channelwise);
    total_power = nanmedian(total_power_channelwise);
    band0_2 = nanmedian(band_channelwise(:,1));
    band1_3 = nanmedian(band_channelwise(:,2));
    band2_4 = nanmedian(band_channelwise(:,3));
    band3_5 = nanmedian(band_channelwise(:,4));
    band4_6 = nanmedian(band_channelwise(:,5));
    band5_7 = nanmedian(band_channelwise(:,6));
    band6_8 = nanmedian(band_channelwise(:,7));
    band7_9 = nanmedian(band_channelwise(:,8));
    band8_10 = nanmedian(band_channelwise(:,9));
    band9_11 = nanmedian(band_channelwise(:,10));
    band10_12 = nanmedian(band_channelwise(:,11));
    band12_30 = nanmedian(band_channelwise(:,12));
    band0_2norm = nanmedian(band_norm_channelwise(:,1));
    band1_3norm = nanmedian(band_norm_channelwise(:,2));
    band2_4norm = nanmedian(band_norm_channelwise(:,3));
    band3_5norm = nanmedian(band_norm_channelwise(:,4));
    band4_6norm = nanmedian(band_norm_channelwise(:,5));
    band5_7norm = nanmedian(band_norm_channelwise(:,6));
    band6_8norm = nanmedian(band_norm_channelwise(:,7));
    band7_9norm = nanmedian(band_norm_channelwise(:,8));
    band8_10norm = nanmedian(band_norm_channelwise(:,9));
    band9_11norm = nanmedian(band_norm_channelwise(:,10));
    band10_12norm = nanmedian(band_norm_channelwise(:,11));
    band12_30norm = nanmedian(band_norm_channelwise(:,12));
    wavelet_energy=nanmedian(wavelet_energy_channelwise);
    min_max=nanmedian(min_max_channelwise);
    RMS_amp = nanmedian(RMS_amp_channelwise);
    H_shannon = nanmedian(H_shannon_channelwise);
    activity=nanmedian(activity_channelwise);
    mobility=nanmedian(mobility_channelwise);
    complexity=nanmedian(complexity_channelwise);
    Nonlinear_energy=nanmedian(Nonlinear_energy_channelwise);
    Line_length=nanmedian(Line_length_channelwise);
    peak_freq=nanmedian(peak_freq_channelwise);
    H_spectral=nanmedian(H_spectral_channelwise);
    SEF90=nanmedian(SEF90_channelwise);
    SEF95=nanmedian(SEF95_channelwise);
    SEF80=nanmedian(SEF80_channelwise);
    Zero_crossings=nanmedian(Zero_crossings_channelwise);
    AR1=nanmedian(AR1_channelwise); AR2=nanmedian(AR2_channelwise);AR3=nanmedian(AR3_channelwise);
    AR4=nanmedian(AR4_channelwise); AR5=nanmedian(AR5_channelwise); AR6=nanmedian(AR6_channelwise);
    AR7=nanmedian(AR7_channelwise); AR8=nanmedian(AR8_channelwise); AR9=nanmedian(AR9_channelwise);
    svd_entropy=nanmedian(svd_entropy_channelwise);
    fisher=nanmedian(fisher_channelwise);
    ZC1d=median(ZC1d_channelwise);
    ZC2d=nanmedian(ZC2d_channelwise);
    V1d=nanmedian(V1d_channelwise);
    V2d=nanmedian(V2d_channelwise);
    
    Skewness_62_125 = nanmedian(fv1_channelwise(:,1)); %'Skewness (62.5-125ms)'
    Skewness_125_250 = nanmedian(fv1_channelwise(:,2)); %'Skewness (125-250ms)'
    Skewness_250_500 = nanmedian(fv1_channelwise(:,3)); %'Skewness (250-500ms)'
    Kurtosis_62_125 = nanmedian(fv1_channelwise(:,8)); %'Kurtosis (62.5-125ms)'
    Kurtosis_125_250 = nanmedian(fv1_channelwise(:,9)); %'Kurtosis (125-250ms)'
    Kurtosis_250_500 = nanmedian(fv1_channelwise(:,10)); %'Kurtosis (250-500ms)'
    Alpha_area = nanmedian(fv1_channelwise(:,22)); %'Alpha (PLT fit: area)'
    Lambda_area = nanmedian(fv1_channelwise(:,23)); %'Lambda (PLT fit: area)'
    xMin_area = nanmedian(fv1_channelwise(:,24)); %'x min (PLT fit: area)'
    LLR_area = nanmedian(fv1_channelwise(:,25)); %'LLR of fit (PLT fit: area)'
    Alpha_bursts = nanmedian(fv1_channelwise(:,26)); %'Alpha (PLT fit: bursts)'
    Lambda_bursts = nanmedian(fv1_channelwise(:,27)); %'Lambda (PLT fit: bursts)'
    xMin_bursts = nanmedian(fv1_channelwise(:,28)); %'x min (PLT fit: bursts)'
    LLR_bursts = nanmedian(fv1_channelwise(:,29)); %'LLR of fit (PLT fit: bursts)'
    slopeVsDuration = nanmedian(fv1_channelwise(:,30)); %'Slope area vs durations'
    interceptVsDuration = nanmedian(fv1_channelwise(:,31)); %'Intercept area vs durations'
    meanBurstDuration = nanmedian(fv1_channelwise(:,32)); %'Mean Burst Duration'
    COVBurstDuration = nanmedian(fv1_channelwise(:,33)); %'COV Burst Duration'
    SuppCurve = nanmedian(fv2_channelwise(:,1)); %'Suppression Curve'
    MSEmean = nanmedian(fv2_channelwise(:,2)); %'MSE mean'
    MSEmax = nanmedian(fv2_channelwise(:,3)); %'MSE max'
    MSEdelta = nanmedian(fv2_channelwise(:,4)); %'MSE (delta)'
    
    %% Combine features
    feats = [];
    for feat = 1:length(features)
        feats(feat) = eval(features{feat});
        %feat_vec(ii) = cat(1,feat_vec,eval(featurelist{ii})');
    end
    % feats = zeros(1,98);
else
    feats = NaN(1,98);
end

end