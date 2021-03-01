function out = allplfits(data,skipplpva,quietflag,forcexmin)
%  outstruct = allplfits(data,[skipplpva],[quietflag],[forcexmin])
% Fit pareto, powerexp, lnorm, and exp to data, and perform hypothesis
% tests between the possibilities. Uses pli_R_matlabport. Uses plfit to
% determine xmin, and uses this same xmin for all distributions UNLESS
% optional argument forcexmin is given, in which case that xmin is used for
% everything. 
% Also uses plpva to determine the p-value for the power law 
% - TO DO: calculate p-values for the other distributions too.
%
% Currently assumes continuous data. For discrete, need to fit to zeta,
% discpowerexp, disclnorm, and discexp. In using plfit for discrete data,
% might need to specify a tighter range of exponents to test.

if nargin<2, skipplpva=0; end
if nargin<3, quietflag=0; end
if nargin<4, forcexmin=NaN; end

if quietflag
    if isunix
        fid=fopen('/dev/null','w');
    else
        fid=fopen('NUL:','w');
    end
else
    fid=1;
end

% use plfit to get xmin, primarily
fprintf(fid,'plfit...');
[alpha,xmin,L]=plfit(data,'finite');
out.plfit.alpha=alpha;
out.plfit.xmin=xmin;
out.plfit.L=L;
out.plfit.N=sum(data>=xmin);
fprintf(fid,' alpha = %g  xmin = %g  L = %g ...done\n',alpha,xmin,L);

if skipplpva
    fprintf(fid,'skipping plpva\n');
else
    % use plpva for the p-value of the fit - can be slow
    fprintf(fid,'plpva...');
    %[pval gof]=plpva(data,xmin);
    [pval,gof]=parplpva2(data,xmin); % parallel version
    out.plpva.pval=pval;
    out.plpva.gof=gof;
    fprintf(fid,' pval = %g  gof = %g ...done\n',pval,gof);
end

if ~isnan(forcexmin)
    % forcing fixed xmin
    % NOTE plfit will still be run and will still find its own xmin
    fprintf(fid,'using given xmin rather than the plfit-derived value\n');
    xmin=forcexmin;
end

% do the candidate fits
fprintf(fid,'fits using xmin = %g, leaving %d points over threshold ...\n',xmin,out.plfit.N);
out.pareto=pareto_fit(data,xmin);
fprintf(fid,' pareto:   exponent = %g  loglike = %g\n',out.pareto.exponent,out.pareto.loglike);
out.powerexp=powerexp_fit(data,xmin);
fprintf(fid,' powerexp: exponent = %g  rate = %g  loglike = %g\n',out.powerexp.exponent,out.powerexp.rate,out.powerexp.loglike);
out.exp=exp_fit(data,xmin);
fprintf(fid,' exp:      rate = %g  loglike = %g\n',out.exp.rate,out.exp.loglike);
out.lnorm=lnorm_fit(data,xmin);
fprintf(fid,' lnorm:    meanlog = %g  sdlog = %g  loglike = %g\n',out.lnorm.meanlog,out.lnorm.sdlog,out.lnorm.loglike);
out.lnorm_xmin0=lnorm_fit(data,0);
fprintf(fid,' lnorm (xmin=0): meanlog = %g  sdlog = %g  loglike = %g\n',out.lnorm_xmin0.meanlog,out.lnorm_xmin0.sdlog,out.lnorm_xmin0.loglike);
out.weibull=weibull_fit(data,xmin);
fprintf(fid,' weibull: shape = %g  scale = %g  loglike = %g  ...done\n',out.weibull.shape,out.weibull.scale,out.weibull.loglike);

% hypothesis tests between pareto and the others
fprintf(fid,'hypothesis tests ...\n');
out.pareto_powerexp_lrt=power_powerexp_lrt(out.pareto,out.powerexp);
fprintf(fid,' pareto vs powerexp: LLR = %g  p_value = %g\n',out.pareto_powerexp_lrt.log_like_ratio,out.pareto_powerexp_lrt.p_value);
out.vuong_pareto_lnorm_llr=vuong(pareto_lnorm_llr(data,out.pareto,out.lnorm));
fprintf(fid,' pareto vs lnorm:    LLR = %g  mean_LLR = %g  sd_LLR = %g\n',out.vuong_pareto_lnorm_llr.loglike_ratio,out.vuong_pareto_lnorm_llr.mean_LLR,out.vuong_pareto_lnorm_llr.sd_LLR);
fprintf(fid,'                     Vuong = %g  p_one_sided = %g  p_two_sided = %g\n',out.vuong_pareto_lnorm_llr.Vuong,out.vuong_pareto_lnorm_llr.p_one_sided,out.vuong_pareto_lnorm_llr.p_two_sided);
out.vuong_pareto_lnorm_xmin0_llr=vuong(pareto_lnorm_llr(data,out.pareto,out.lnorm_xmin0));
fprintf(fid,' pareto vs lnorm:    LLR = %g  mean_LLR = %g  sd_LLR = %g\n',out.vuong_pareto_lnorm_xmin0_llr.loglike_ratio,out.vuong_pareto_lnorm_xmin0_llr.mean_LLR,out.vuong_pareto_lnorm_xmin0_llr.sd_LLR);
fprintf(fid,' (using xmin=0)      Vuong = %g  p_one_sided = %g  p_two_sided = %g\n',out.vuong_pareto_lnorm_xmin0_llr.Vuong,out.vuong_pareto_lnorm_xmin0_llr.p_one_sided,out.vuong_pareto_lnorm_xmin0_llr.p_two_sided);
out.vuong_pareto_exp_llr=vuong(pareto_exp_llr(data,out.pareto,out.exp));
fprintf(fid,' pareto vs exp:      LLR = %g  mean_LLR = %g  sd_LLR = %g\n',out.vuong_pareto_exp_llr.loglike_ratio,out.vuong_pareto_exp_llr.mean_LLR,out.vuong_pareto_exp_llr.sd_LLR);
fprintf(fid,'                     Vuong = %g  p_one_sided = %g  p_two_sided = %g\n',out.vuong_pareto_exp_llr.Vuong,out.vuong_pareto_exp_llr.p_one_sided,out.vuong_pareto_exp_llr.p_two_sided);
out.vuong_pareto_weibull_llr=vuong(pareto_weibull_llr(data,out.pareto,out.weibull));
fprintf(fid,' pareto vs weibull:  LLR = %g  mean_LLR = %g  sd_LLR = %g\n',out.vuong_pareto_weibull_llr.loglike_ratio,out.vuong_pareto_weibull_llr.mean_LLR,out.vuong_pareto_weibull_llr.sd_LLR);
fprintf(fid,'                     Vuong = %g  p_one_sided = %g  p_two_sided = %g\n',out.vuong_pareto_weibull_llr.Vuong,out.vuong_pareto_weibull_llr.p_one_sided,out.vuong_pareto_weibull_llr.p_two_sided);
out.vuong_powerexp_lnorm_llr=vuong(powerexp_lnorm_llr(data,out.powerexp,out.lnorm));
fprintf(fid,' powerexp vs lnorm:  LLR = %g  mean_LLR = %g  sd_LLR = %g\n',out.vuong_powerexp_lnorm_llr.loglike_ratio,out.vuong_powerexp_lnorm_llr.mean_LLR,out.vuong_powerexp_lnorm_llr.sd_LLR);
fprintf(fid,'                     Vuong = %g  p_one_sided = %g  p_two_sided = %g\n',out.vuong_powerexp_lnorm_llr.Vuong,out.vuong_powerexp_lnorm_llr.p_one_sided,out.vuong_powerexp_lnorm_llr.p_two_sided);
out.vuong_powerexp_weibull_llr=vuong(powerexp_weibull_llr(data,out.powerexp,out.weibull));
fprintf(fid,' powerexp vs weibull:LLR = %g  mean_LLR = %g  sd_LLR = %g\n',out.vuong_powerexp_weibull_llr.loglike_ratio,out.vuong_powerexp_weibull_llr.mean_LLR,out.vuong_powerexp_weibull_llr.sd_LLR);
fprintf(fid,'                     Vuong = %g  p_one_sided = %g  p_two_sided = %g\n',out.vuong_powerexp_weibull_llr.Vuong,out.vuong_powerexp_weibull_llr.p_one_sided,out.vuong_powerexp_weibull_llr.p_two_sided);
fprintf(fid,'...done\n');

if quietflag, fclose(fid); end