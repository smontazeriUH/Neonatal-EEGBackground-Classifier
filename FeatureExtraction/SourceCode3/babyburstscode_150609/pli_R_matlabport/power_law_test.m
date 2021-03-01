% Code for testing fits to power-law distributions against other heavy-tailed
% alternatives

% Code for ESTIMATING the heavy-tailed alternatives live in separate files,
% which you'll need to load.

% Tests are of two sorts, depending on whether or not the power law is embeded
% within a strictly larger class of distributions ("nested models"), or the two
% alternatives do not intersect ("non-nested").  In both cases, our procedures
% are based on those of Vuong (1989), neglecting his third case where the two
% hypothesis classes intersect at a point, which happens to be the best-fitting
% hypothesis.

% In the nested case, the null hypothesis is that the best-fitting distribution
% lies in the smaller class.  Then 2* the log of the likelihood ratio should
% (asymptotically) have a chi-squared distribution.  This is almost the
% classical Wilks (1938) situation, except that Vuong shows the same results
% hold even when all the distributions are "mis-specified" (hence we speak of
% best-fitting distribution, not true distribution).

% In the non-nested case, the null hypothesis is that both classes of
% distributions are equally far (in the Kullback-Leibler divergence/relative
% entropy sense) from the true distribution.  If this is true, the
% log-likelihood ratio should (asymptotically) have a Gaussian distribution
% with mean zero; our test statistic is the sample average of the log
% likelihood ratio, standardized by a consistent estiamte of its standard
% deviation.  If the null is false, and one class of distributions is closer to
% the truth, his test statistic goes to +-infinity with probability 1,
% indicating the better-fitting class of distributions.  (See, in particular,
% Theorem 5.1 on p. 318 of his paper.)

% Vuong, Quang H. (1989): "Likelihood Ratio Tests for Model Selection and
%	Non-Nested Hypotheses", _Econometrica_ 57: 307--333 (in JSTOR)
% Wilks, S. S. (1938): "The Large Sample Distribution of the Likelihood Ratio
%	for Testing Composite Hypotheses", _The Annals of Mathematical
%	Statistics_ 9: 60--62 (in JSTOR)

% All testing functions here are set up to work with the estimation functions
% in the accompanying files, which return some meta-data about the fitted
% distributions, including likelihoods, cut-offs, numbers of data points, etc.,
% much of which is USED by the testing routines.

%%% Function for nested hypothesis testing:
% power.powerexp.lrt		Test power-law distribution vs. power-law with
%				exponential cut-off
%%% Functions for non-nested hypothesis testing:
% vuong				Calculate mean, standard deviation, Vuong's
%				test statistic, and Gaussian p-values on
%				log-likelihood ratio vectors
% pareto.exp.llr		Makes vector of pointwise log-likelihood
%				ratio between fitted continuous power law
%				(Pareto) and exponential distributions
% pareto.lnorm.llr		Pointwise log-likelihood ratio, Pareto vs.
%				log-normal
% pareto.weibull.llr		Pointwise log-likelihood ratio, Pareto vs.
%				stretched exponential (Weibull)
% zeta.exp.llr 			Pointwise log-likelihood ratio, discrete power
%				law (zeta) vs. discrete exponential
% zeta.lnorm.llr		Pointwise log-likelihood ratio, zeta vs.
%				discretized log-normal
% zeta.poisson.llr		Pointwise log-likelihood ratio, zeta vs. Poisson
% zeta.weib.llr			Pointwise log-likelihood ratio, zeta vs. Weibull
% zeta.yule.llr			Pointwise log-likelihood ratio, zeta vs. Yule



