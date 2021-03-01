function out = allplfits_xminfrompowerexp(data,skipplpva)
%  outstruct = allplfits_xminfrompowerexp(data,[skipplpva])
% Fit pareto, powerexp, lnorm, and exp to data, and perform hypothesis
% tests between the possibilities. Uses pli_R_matlabport. Uses
% powerexp_fit_xmin to determine xmin, and uses this same xmin for all
% distributions. Also uses plpva to determine the p-value for the power law
% - TO DO: calculate p-values for the other distributions too.
%
% Currently assumes continuous data. For discrete, need to fit to zeta,
% discpowerexp, disclnorm, and discexp. In using plfit for discrete data,
% might need to specify a tighter range of exponents to test.

if nargin<2, skipplpva=0; end

% use powerexp_fit_xmin to get xmin, primarily
fprintf(1,'powerexp_fit_xmin...');
[alpha,lambda,xmin,L]=powerexp_fit_xmin(data);
out.powerexp_fit_xmin.alpha=alpha;
out.powerexp_fit_xmin.lambda=lambda;
out.powerexp_fit_xmin.xmin=xmin;
out.powerexp_fit_xmin.L=L;
fprintf(1,' alpha = %g  xmin = %g  L = %g ...done\n',alpha,xmin,L);

if skipplpva
    fprintf(1,'skipping plpva\n');
else
    % use plpva for the p-value of the fit - can be slow
    fprintf(1,'plpva...');
    %[pval gof]=plpva(data,xmin);
    [pval gof]=parplpva2(data,xmin); % parallel version
    out.plpva.pval=pval;
    out.plpva.gof=gof;
    fprintf(1,' pval = %g  gof = %g ...done\n',pval,gof);
end

% do the candidate fits
fprintf(1,'fits using xmin = %g, leaving %d points over threshold ...\n',xmin,length(find(data>=xmin)));
out.pareto=pareto_fit(data,xmin);
fprintf(1,' pareto:   exponent = %g  loglike = %g\n',out.pareto.exponent,out.pareto.loglike);
out.powerexp=powerexp_fit(data,xmin);
fprintf(1,' powerexp: exponent = %g  rate = %g  loglike = %g\n',out.powerexp.exponent,out.powerexp.rate,out.powerexp.loglike);
out.exp=exp_fit(data,xmin);
fprintf(1,' exp:      rate = %g  loglike = %g\n',out.exp.rate,out.exp.loglike);
out.lnorm=lnorm_fit(data,xmin);
fprintf(1,' lnorm:    meanlog = %g  sdlog = %g  loglike = %g\n',out.lnorm.meanlog,out.lnorm.sdlog,out.lnorm.loglike);
out.lnorm_xmin0=lnorm_fit(data,0);
fprintf(1,' lnorm (xmin=0): meanlog = %g  sdlog = %g  loglike = %g\n',out.lnorm_xmin0.meanlog,out.lnorm_xmin0.sdlog,out.lnorm_xmin0.loglike);
out.weibull=weibull_fit(data,xmin);
fprintf(1,' weibull: shape = %g  scale = %g  loglike = %g  ...done\n',out.weibull.shape,out.weibull.scale,out.weibull.loglike);

% hypothesis tests between pareto and the others
fprintf(1,'hypothesis tests ...\n');
out.pareto_powerexp_lrt=power_powerexp_lrt(out.pareto,out.powerexp);
fprintf(1,' pareto vs powerexp: LLR = %g  p_value = %g\n',out.pareto_powerexp_lrt.log_like_ratio,out.pareto_powerexp_lrt.p_value);
out.vuong_pareto_lnorm_llr=vuong(pareto_lnorm_llr(data,out.pareto,out.lnorm));
fprintf(1,' pareto vs lnorm:    LLR = %g  mean_LLR = %g  sd_LLR = %g\n',out.vuong_pareto_lnorm_llr.loglike_ratio,out.vuong_pareto_lnorm_llr.mean_LLR,out.vuong_pareto_lnorm_llr.sd_LLR);
fprintf(1,'                     Vuong = %g  p_one_sided = %g  p_two_sided = %g\n',out.vuong_pareto_lnorm_llr.Vuong,out.vuong_pareto_lnorm_llr.p_one_sided,out.vuong_pareto_lnorm_llr.p_two_sided);
out.vuong_pareto_lnorm_xmin0_llr=vuong(pareto_lnorm_llr(data,out.pareto,out.lnorm_xmin0));
fprintf(1,' pareto vs lnorm:    LLR = %g  mean_LLR = %g  sd_LLR = %g\n',out.vuong_pareto_lnorm_xmin0_llr.loglike_ratio,out.vuong_pareto_lnorm_xmin0_llr.mean_LLR,out.vuong_pareto_lnorm_xmin0_llr.sd_LLR);
fprintf(1,' (using xmin=0)      Vuong = %g  p_one_sided = %g  p_two_sided = %g\n',out.vuong_pareto_lnorm_xmin0_llr.Vuong,out.vuong_pareto_lnorm_xmin0_llr.p_one_sided,out.vuong_pareto_lnorm_xmin0_llr.p_two_sided);
out.vuong_pareto_exp_llr=vuong(pareto_exp_llr(data,out.pareto,out.exp));
fprintf(1,' pareto vs exp:      LLR = %g  mean_LLR = %g  sd_LLR = %g\n',out.vuong_pareto_exp_llr.loglike_ratio,out.vuong_pareto_exp_llr.mean_LLR,out.vuong_pareto_exp_llr.sd_LLR);
fprintf(1,'                     Vuong = %g  p_one_sided = %g  p_two_sided = %g\n',out.vuong_pareto_exp_llr.Vuong,out.vuong_pareto_exp_llr.p_one_sided,out.vuong_pareto_exp_llr.p_two_sided);
out.vuong_powerexp_lnorm_llr=vuong(powerexp_lnorm_llr(data,out.powerexp,out.lnorm));
fprintf(1,' powerexp vs lnorm:  LLR = %g  mean_LLR = %g  sd_LLR = %g\n',out.vuong_powerexp_lnorm_llr.loglike_ratio,out.vuong_powerexp_lnorm_llr.mean_LLR,out.vuong_powerexp_lnorm_llr.sd_LLR);
fprintf(1,'                     Vuong = %g  p_one_sided = %g  p_two_sided = %g\n',out.vuong_powerexp_lnorm_llr.Vuong,out.vuong_powerexp_lnorm_llr.p_one_sided,out.vuong_powerexp_lnorm_llr.p_two_sided);
fprintf(1,'...done\n');
