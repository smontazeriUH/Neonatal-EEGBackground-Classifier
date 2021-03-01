%% non-linear enery
function snleo = nlin_energy(dat, win)
% dat is the eeg data
xm3 = [dat 0 0 0];
xm2 = [0 dat 0 0];
xm1= [0 0 dat 0];
xm0= [0 0 0 dat];
 
nleo = xm1.*xm2 - xm0.*xm3;
nleo = nleo(4:end) ;
dum1 = conv(abs(nleo), ones(1,win))./win; % or shape – hamming or hanning instead of ones
snleo = dum1(ceil(win/2):end-floor(win/2));
%snleo = snleo-min(snleo);
end