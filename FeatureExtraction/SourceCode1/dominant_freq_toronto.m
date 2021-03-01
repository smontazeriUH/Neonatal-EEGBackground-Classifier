function peak_freq = dominant_freq_toronto(pxx)


peak_freq = find(pxx==max(pxx));
if max(pxx)==0
    peak_freq=0;
end
