function fv1 = estimate_mse(eeg, fs, art)

epl = 100*fs;

block_no = floor(length(eeg)/epl); feat1 = zeros(block_no, 3);
scale = 1:20; val = zeros(block_no, 1);
for ii = 1:block_no
    r1 = (ii-1)*epl+1; r2 = r1+epl-1;
    %r3  = (ii-1)*60*fs+1; r4=r3+60*fs-1;
    if sum(art(r1:r2))==0
        dat = eeg(r1:r2);
        se = zeros(1, length(scale));
        for z2 = 1:length(scale)
            dum = conv(dat, ones(1, scale(z2)))/scale(z2);
            dum = dum(ceil(scale/2):scale(z2):end);
            se(z2) = SampEn(2, 0.2*std(dum), dum);
        end
        val(ii) = 1;
        feat1(ii,:) = [sum(se) max(se) sum(diff(se(1:5)))];
    end
end

fv1 = median(feat1(val==1,:), 1);

