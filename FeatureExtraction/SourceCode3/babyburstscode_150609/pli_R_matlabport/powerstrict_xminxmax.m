function out=powerstrict_xminxmax(data,na,minr)
% Estimate xmin and xmax for strictly-truncated power laws.
% Input: Data vector, number of xmin (and xmax) to test, min allowed ratio
%        xmax/xmin
% Output: fit
%
% Following Deluca and Corral (2013)

datamin=min(data);
datamax=max(data); % may need to extend this for b
aa=logspace(log10(datamin),log10(datamax),na);
bb=aa;

fits=repmat(struct('type','powerstrict','exponent',nan,'xmin',nan,'xmax',nan,'loglike',nan,'N',nan,'exitflag',nan,'exitoutput',struct()),na,na);

ksde=zeros(na);
pval=zeros(na);
Ns=zeros(na);

nsurrs=50;

minN=10; % if there's not this many points in the bin, don't bother fitting

fprintf(1,'j=1:%d @ %s\n',na,datestr(now));
for j=1:na,
    fprintf(1,'%d ',j);
    if ~mod(j,20), fprintf(1,'\n'); end
    parfor k=j+1:na,
    %for k=1:na, % for outer parfor
        if bb(k)/aa(j)>=minr,
            x = data(data>=aa(j) & data<=bb(k));
            Ns(j,k)=length(x);
            if Ns(j,k)>=minN
                % do fit
                fits(j,k)=powerstrict_fit(data,aa(j),bb(k));
                if ~isnan(fits(j,k).exponent) % if fitted ok
                    % calculate KS statistic
                    [xsorted,ucdf_data]=eucdf(x);
                    ucdf_model=ppowerstrict(xsorted,aa(j),bb(k),fits(j,k).exponent,0,0); % 0,0=uppercdf,nolog
                    ksde(j,k)=max(abs(ucdf_model-ucdf_data));
                    % calculate p-value using KS statistic of surrogates
                    ksds_all=zeros(1,nsurrs);
                    for m=1:nsurrs
                        xsurr=rpowerstrict(length(x),aa(j),bb(k),fits(j,k).exponent);
                        fitsurr=powerstrict_fit(xsurr,aa(j),bb(k));
                        [xsurrsorted,ucdf_surr]=eucdf(xsurr);
                        ucdf_surrmodel=ppowerstrict(xsurrsorted,aa(j),bb(k),fitsurr.exponent,0,0); % 0,0=uppercdf,nolog
                        ksds_all(m)=max(abs(ucdf_surrmodel-ucdf_surr));
                    end
                    pval(j,k)=sum(ksds_all>=ksde(j,k))/nsurrs;
                end
            end
        end
    end
end
fprintf(1,'\n');

alphas=reshape([fits.exponent],na,na);
xmins=reshape([fits.xmin],na,na);
xmaxs=reshape([fits.xmax],na,na);
rs=xmaxs./xmins;

pth=0.2; % pval threshold - fits with pval>pth are plausible
okfits=pval>pth;
[okfitj,okfitk]=find(okfits);
% fit maximizing r=b/a
[maxr,maxri]=max(xmaxs(okfits)./xmins(okfits));
fitbyr.max=maxr;
fitbyr.a=aa(okfitj(maxri));
fitbyr.b=bb(okfitk(maxri));
fitbyr.j=okfitj(maxri);
fitbyr.k=okfitk(maxri);
fitbyr.pval=pval(okfitj(maxri),okfitk(maxri));
fitbyr.fit=fits(okfitj(maxri),okfitk(maxri));
% fit maximizing N=number of points in range
[maxN,maxNi]=max(Ns(okfits));
fitbyN.max=maxN;
fitbyN.a=aa(okfitj(maxNi));
fitbyN.b=bb(okfitk(maxNi));
fitbyN.j=okfitj(maxNi);
fitbyN.k=okfitk(maxNi);
fitbyN.pval=pval(okfitj(maxNi),okfitk(maxNi));
fitbyN.fit=fits(okfitj(maxNi),okfitk(maxNi));

out.fits=fits;
out.alphas=alphas;
out.xmins=xmins;
out.xmaxs=xmaxs;
out.rs=rs;
out.Ns=Ns;
out.ksde=ksde;
out.pval=pval;
out.nsurrs=nsurrs;
out.pth=pth;
out.fitbyr=fitbyr;
out.fitbyN=fitbyN;
out.aa=aa;
out.bb=bb;
out.na=na;
out.minr=minr;
out.minN=minN;


