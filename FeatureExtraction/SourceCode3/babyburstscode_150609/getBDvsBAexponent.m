function out=getBDvsBAexponent(data,rangetype,range)
%  out = getBDvsBAexponent(areas,durs,rangetype,range)
% Calculate exponent for burst duration vs burst area
% Based on extractavstats.m


durs=data.durs;
areas=data.areas;

switch rangetype
    case 'arearange'
        ok=areas>=range(1) & areas<=range(2);
    case 'durrange'
        ok=durs>=range(1) & durs<=range(2);
    otherwise
        error('invalid rangetype')
end
areas=areas(ok);
durs=durs(ok);

% duration vs area
%fitmindur=0.1;

% scatter
[scatterfit,scatterfitCI]=fitwrapper(log(areas),log(durs));

% bin by dur
binbydur=getbinby(durs,areas,'dur');
% % OLD
% ndurbins=50; % number of bin edges is ndurbins+1
% durbins=exp(linspace(log(min(durs)),log(max(durs)+0.1),ndurbins+1)); % +0.1 so that the upper endpt definitely falls in a bin
% durbins(1)=min(durs); % when dur is small, exp(log(x)) might be > x, causing the min to fall outside the bins
% [durbincounts,durbini]=histc(durs,durbins);
% if durbincounts(end)>0, error('dur at right end pt, should not be there'), end
% binbydur=getbasicstats(areas,durbini'); % area stats by bin
% binbydur.ndurbins=ndurbins;
% binbydur.durbins=durbins;
% % bin location could be median or mean, calc both (error in the median is?)
% binbydur.durstats=getbasicstats(durs,durbini');
% binbydur.fits.meanlinear=polyfitfinite(log(binbydur.mean),log(binbydur.durstats.mean),1);
% binbydur.fits.medianlinear=polyfitfinite(log(binbydur.median),log(binbydur.durstats.median),1);

% bin by area
binbyarea=getbinby(areas,durs,'area');

out.scatterfit=scatterfit;
out.scatterfitCI=scatterfitCI;
out.binbydur=binbydur;
out.binbyarea=binbyarea;
out.scatterexp=scatterfit(1);
out.binbydurexp=binbydur.fits.medianlinear(1);
out.binbyareaexp=binbyarea.fits.medianlinear(1);
out.rangetype=rangetype;
out.arearange=[min(areas) max(areas)];
out.durrange=[min(durs) max(durs)];

diagplot=0;
if diagplot
    loglog(areas,durs,'.'), hold on %#ok<UNRCH>
    loglogrefline(scatterfit,'k',[min(areas) max(areas)])
    loglog(binbydur.median,binbydur.stats.median,'ro')
    loglogrefline(binbydur.fits.medianlinear,'g',[min(binbydur.median) max(binbydur.median)])
    loglog(binbyarea.stats.median,binbyarea.median,'mo')
    invline=@(fit) [1/fit(1) -fit(2)/fit(1)];
    loglogrefline(invline(binbyarea.fits.medianlinear),'c',[min(binbyarea.stats.median) max(binbyarea.stats.median)])
end
end

function out=getbinby(binvar,othervar,bintype)
nbins=50; % number of bin edges is nbins+1
bins=exp(linspace(log(min(binvar)),log(max(binvar)+0.1),nbins+1)); % +0.1 so that the upper endpt definitely falls in a bin
bins(1)=min(binvar); % when dur is small, exp(log(x)) might be > x, causing the min to fall outside the bins
[bincounts,bini]=histc(binvar,bins);
if bincounts(end)>0, error('data at right end pt, should not be there'), end
binby=getbasicstats(othervar,bini'); % othervar stats by bin
binby.nbins=nbins;
binby.bins=bins;
% bin location could be median or mean, calc both (error in the median is?)
binby.stats=getbasicstats(binvar,bini');
[fit,CI]=fitwrapper(log(binby.mean),log(binby.stats.mean));
binby.fits.meanlinear=fit; binby.fits.meanlinearCI=CI;
[fit,CI]=fitwrapper(log(binby.median),log(binby.stats.median));
binby.fits.medianlinear=fit; binby.fits.medianlinearCI=CI;
binby.type=bintype;
out=binby;
end

function out=getbasicstats(x,inds)
out.n=accumarray(inds,x,[],@numel);
out.mean=accumarray(inds,x,[],@mean,NaN);
out.sd=accumarray(inds,x,[],@std,NaN);
out.sem=out.sd./sqrt(out.n);
out.median=accumarray(inds,x,[],@median,NaN);
end

function varargout = polyfitfinite(x,y,n) %#ok<DEFNU>
% wrapper for polyfit to ignore NaNs and Infs
ok=isfinite(x) & isfinite(y);
[varargout{1:nargout}] = polyfit(x(ok),y(ok),n); 
end

function varargout = fitwrapper(x,y)
%[varargout{1:nargout}] = polyfitfinite(x,y,1);
[varargout{1:nargout}] = regress(y(:),[x(:) ones(size(x(:)))]);
end

