function out=powerstrict_fit_onewithpval(data,a,b)
%  out=powerstrict_fit_onewithpval(data,a,b)
% Fit powerstrict with given xmin and xmax a,b and calculate the p-value

nsurrs=100;

x = data(data>=a & data<=b);
% do fit
fits=powerstrict_fit(data,a,b);
if ~isnan(fits.exponent) % if fitted ok
    % calculate KS statistic
    [xsorted,ucdf_data]=eucdf(x);
    ucdf_model=ppowerstrict(xsorted,a,b,fits.exponent,0,0); % 0,0=uppercdf,nolog
    ksde=max(abs(ucdf_model-ucdf_data));
    % calculate p-value using KS statistic of surrogates
    ksds_all=zeros(1,nsurrs);
    for m=1:nsurrs
        xsurr=rpowerstrict(length(x),a,b,fits.exponent);
        fitsurr=powerstrict_fit(xsurr,a,b);
        [xsurrsorted,ucdf_surr]=eucdf(xsurr);
        ucdf_surrmodel=ppowerstrict(xsurrsorted,a,b,fitsurr.exponent,0,0); % 0,0=uppercdf,nolog
        ksds_all(m)=max(abs(ucdf_surrmodel-ucdf_surr));
    end
    pval=sum(ksds_all>=ksde)/nsurrs;
end

out.fit=fits;
out.pval=pval;
