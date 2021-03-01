function [delta1,delta2,theta,alpha,beta]=cal_EEGsubbands(psd,freq)

for i=1:size(psd,2)
    delta1(i) = EEG_subbands(psd,freq,[0.5,2]);
    delta2(i) = EEG_subbands(psd,freq,[2,4]);
    theta(i) = EEG_subbands(psd,freq,[4,7]);
    alpha(i) = EEG_subbands(psd,freq,[7,12]);
    beta(i) = EEG_subbands(psd,freq,[12,30]);
end
delta1 = mean(delta1);
delta2=mean(delta2);
theta=mean(theta);
alpha=mean(alpha);
beta=mean(beta);

end