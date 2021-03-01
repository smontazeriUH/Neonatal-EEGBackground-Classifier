function [amps, r] = amplitude_scaling(dat, art);

%dat = dat3(kk,:); art =  nart1(kk,:);
scls = 128.*(2.^[0:7]);
amp = abs(hilbert(dat));
amps = zeros(1, length(scls));
for ii = 1:length(scls)
    block_no = floor(length(dat)/scls(ii));
    dum = zeros(1, block_no); aa = dum;
    for jj = 1:block_no
        r1 = (jj-1)*scls(ii)+1; r2 = r1+scls(ii)-1;
        dum(jj) = mean(amp(r1:r2));
        aa(jj) = sum(art(r1:r2));
    end
    amps(ii) = std(dum(aa==0));
end

x = 1:length(scls); r = polyfit(x, amps, 2);
