function ploteucdfwithfits(data,fitstruct,xmin)
%  ploteucdfwithfits(data,fitstruct,[xmin])
% plot empirical upper CDF with corresponding fits
%
% optional xmin, default is taken from fitstruct.pareto

if nargin<3,
    xmin=fitstruct.pareto.xmin;
end

% to plot points below xmin in gray
grayflag=0;

[xx,yy]=eucdf(data);

if grayflag
    belowxmin=xx<xmin;
    loglog(xx(~belowxmin),yy(~belowxmin),'k.')
    hold on
    loglog(xx(belowxmin),yy(belowxmin),'.','color',[0.5 0.5 0.5])
else
    loglog(xx,yy,'k.')
    hold on
end

origaxis=axis;
    
rescale=yy(find(xx>=xmin,1,'first'));

xplotmin=floor(log10(min(data)));
xplotmax=ceil(log10(2*max(data)));
x=logspace(xplotmin,xplotmax,100);

if isfield(fitstruct,'pareto')
    loglog(x,rescale*ppareto(x,fitstruct.pareto.xmin,fitstruct.pareto.exponent,0,0),'r')
end
if isfield(fitstruct,'powerexp')
    % ppowerexp can run into numerical difficulties, remove neg values first -
    % actually, after fixing bug in uigf, maybe superfluous
    ppowerexp_vals=ppowerexp(x,fitstruct.powerexp.xmin,fitstruct.powerexp.exponent,fitstruct.powerexp.rate,0,0);
    ppowerexp_vals(ppowerexp_vals<=0)=NaN;
    loglog(x,rescale*ppowerexp_vals,'g')
end
if isfield(fitstruct,'lnorm')
    loglog(x,rescale*plnorm_tail(x,fitstruct.lnorm.meanlog,fitstruct.lnorm.sdlog,xmin,0,0),'b')
end
if isfield(fitstruct,'exp')
    %loglog(x,rescale*(1-expcdf(x,1/fitstruct.exp.rate)),'c')
    %xn=x; xn(x<xmin)=NaN;
    %loglog(x,rescale*exp(-xn*fitstruct.exp.rate),'c')
    loglog(x,rescale*pexp_tail(x,fitstruct.exp.rate,xmin,0,0),'c') % use pexp_tail modeled on pweibull_tail
end
if isfield(fitstruct,'weibull')
    loglog(x,rescale*pweibull_tail(x,fitstruct.weibull.shape,fitstruct.weibull.scale,xmin,0,0),'m')
end
if isfield(fitstruct,'powerstrict')
    sxmin=fitstruct.powerstrict.xmin;
    sxmax=fitstruct.powerstrict.xmax;
    sx=logspace(log10(sxmin),log10(sxmax),100);
    sscale=fitstruct.powerstrict.N/length(data);
    soffset=yy(find(xx>=sxmax,1,'first'));
    if isempty(soffset), soffset=0; end
    loglog(sx,soffset+sscale*ppowerstrict(sx,sxmin,sxmax,fitstruct.powerstrict.exponent,0,0),'color',[255 153 0]/255)
end

% for fits with xmin=0
%xalt=logspace(log10(min(data)),xplotmax,100);
%loglog(x,plnorm_tail(x,fitstruct.lnorm_xmin0.meanlog,fitstruct.lnorm_xmin0.sdlog,0,0,0),'b--')
hold off

axis(origaxis)

xlabel(strrep(inputname(1),'_','\_'))
ylabel('1-cdf')