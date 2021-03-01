function fv = calculateSC_NS(dataEEG, fs, art)

A = size(dataEEG);
win = fs*1;
olap = floor(0.125*win);
block_no = floor(A(2)/olap)-7;

%calculate length every 1-second overlapping segment
ll = zeros(A(1), block_no); art1 = ll;
for c2=1:block_no
    r1 = (c2-1)*olap+1; r2 = r1+win-1;
    signal=dataEEG(r1:r2);
    ll(c2) = sum(abs(diff(signal)));
    art1(c2) = sum(art(r1:r2));
end

art1(art1>0) = 1;
ll(art1==1) = NaN;
%art1 = sum(art1);
%art1(art1>0) = 1;

%normalize by 2.5 min windows
Lwin=2.5*60*fs/olap/2; LL = ll;
for c2=1:length(ll)
        r1 = c2-Lwin; r2 = c2+Lwin;
        if r1<1; r1 = 1; end
        if r2>block_no; r2 = block_no; end
        if isnan(ll(c2))==0
            aa = art1(r1:r2); la = ll(r1:r2);
            LL(c2) = ll(c2)/(sum(la(aa==0))*2*Lwin/(r2-r1+1-length(find(aa==1))));   
        end
end

%LLm = median(LL);

SC = zeros(1, block_no);
for c2=1:length(LL)
    r1 = c2-Lwin; r2 = c2+Lwin;
    if r1<1; r1 = 1; end
    if r2>block_no; r2 = block_no; end
    lm = LL(r1:r2); aa = art1(r1:r2);
    SC(c2) = 1-median(lm(aa==0))/mean(lm(aa==0));    
end

fv = mean(SC(art1==0));


end