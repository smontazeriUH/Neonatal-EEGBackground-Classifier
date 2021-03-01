function bs = bsi(dat_left, dat_right, fs, frange);
% This function estimates the brain symmetry index
% 
% INPUTS:- data - a single channel of EEG data
%                   fs - the sampling frequency
%                   frange - the frequency band of interest (typically [0.5, 30]Hz)
%
% OUTPUTS:- bsi - brain symmetry index
%
% Nathan Stevenson
% Neonatal Brain Research Group
% April 2009

N = length(dat_left);
if mod(N,2) == 1 
    dat_left = dat_left(1:N-1);
    dat_right = dat_right(1:N-1);
end
N = length(dat_left);
Xleft = fft(dat_left, 4*N);
Pxxleft = abs(Xleft.*conj(Xleft));
Pxxleft = Pxxleft(1:N/2);
Xright = fft(dat_right, 4*N);
Pxxright = Xright.*conj(Xright);
Pxxright = Pxxright(1:N/2);

fres = fs/length(Xleft);
f = 0:fres:fs-fres;
f = f(1:length(Pxxleft));
r1 = find(f>=frange(1), 1);
if isempty(r1)==1
    r1 = 1;
end
r2 = find(f>=frange(2), 1);
if isempty(r2)==1
    r2 = N/2;
end

Pnewl = Pxxleft(r1:r2);
Pnewr = Pxxright(r1:r2);
bs = mean(abs((Pnewr-Pnewl)./((Pnewr+Pnewl))));
