% Log-log plot of the survival function (empirical upper CDF) of a data set
% Input: Data vector, lower limit, upper limit, graphics parameters
% Output: None (returns NULL invisibly)
function plot_eucdf_loglog(x,from,to)
% defaults: from=min(x), to=max(x)
if nargin<2, from=min(x); to=max(x); end

	% Exploit built-in R function to get ordinary (lower) ECDF, Pr(X<=x)
	x_ecdf = ecdf(x);
	% Now we want Pr(X>=x) = (1-Pr(X<=x)) + Pr(X==x)
        % If x is one of the "knots" of the step function, i.e., a point with
	% positive probability mass, should add that in to get Pr(X>=x)
	% rather than Pr(X>x)
	away_from_knot = @(y)  1 - x_ecdf(y); 
	
	loglog(x.eucdf,from,to)

end

function out = at_knot_prob_jump(y) 
		x_knots = knots(x_ecdf);
		% Either get the knot number, or give zero if this was called
		% away from a knot
		k = match(y,x_knots,nomatch=0)
		if ((k==0) || (k==1))  % Handle special cases
			if (k==0) 
				prob_jump = 0; % Not really a knot
			else 
				prob_jump = x_ecdf(y); % Special handling of first knot
            end
		 else 
			prob_jump = x_ecdf(y) - x_ecdf(x_knots(k-1)); % General case
        end
		out=prob_jump;
end

	% Use one function or the other
	x.eucdf = function(y) {
		baseline = away.from.knot(y)
		jumps = sapply(y,at.knot.prob.jump)
		ifelse (y %in% knots(x.ecdf), baseline+jumps, baseline)
	}