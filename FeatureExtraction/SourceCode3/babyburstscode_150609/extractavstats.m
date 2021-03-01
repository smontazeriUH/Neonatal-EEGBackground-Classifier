function out=extractavstats(bursts,Fs,type)
%  avstats = extractavstats(bursts,[type])
% Calculate burst statistics for cell array of bursts (the output from
% extractbursts.m)
% Optional string type='raw' or 'interp' to use just one endpoint handling
% method

rawflag=1;
interpflag=1;

if nargin>2
    switch type
        case 'raw'
            interpflag=0;
        case 'interp'
            rawflag=0;
        otherwise
            error('invalid type - must be ''raw'' or ''interp'', or leave it off to do both')
    end
end

% raw bursts (integer-spaced points, 1st and last are negative)
if rawflag
    rawdurs=cellfun('length',bursts)/Fs; % in s
    rawareas=cellfun(@trapz,bursts)/Fs; % in uV^2 s

    % due to raw endpts being negative, for very small bursts area can be negative
    raw.durs.x=rawdurs(rawareas>0);
    raw.areas.x=rawareas(rawareas>0);
    raw.durs.xall=rawdurs;
    raw.areas.xall=rawareas;
    raw.Fs=Fs;
    raw.type='raw';

    raw=getstats(raw);

    out.raw=raw;
end

% bursts with ends interpolated
if interpflag
    [t_interpends,bursts_interpends]=burstinterp(bursts,'ends');
    interpdurs=cellfun(@(x) x(end)-x(1),t_interpends)/Fs; % in s
    interpareas=cellfun(@trapz,t_interpends,bursts_interpends)/Fs; % in uV^2 s

    interp.durs.x=interpdurs;
    interp.areas.x=interpareas;
    interp.Fs=Fs;
    interp.type='interp';

    interp=getstats(interp);

    out.interp=interp;
end


end

function data=getstats(data)
%  Calculate stats for data struct with fields durs and areas

durs=data.durs;
areas=data.areas;

[durs.cdf.x,durs.cdf.P]=eucdf(durs.x);
[areas.cdf.x,areas.cdf.P]=eucdf(areas.x);

durs.fits=allplfits(durs.x,1,1);   % skipplpva,quiet
areas.fits=allplfits(areas.x,1,1); %

% duration vs area
fitmindur=0.1;

% scatter
durs.vs.areas.scatter.fits.linear=polyfit(log(areas.x),log(durs.x),1);
whichdurs=durs.x>=fitmindur;
durs.vs.areas.scatter.fits.linearmindur=polyfit(log(areas.x(whichdurs)),log(durs.x(whichdurs)),1);
durs.vs.areas.scatter.fits.mindur=fitmindur;
durs.vs.areas.scatter.fits.mindurarearange=[min(areas.x(whichdurs)) max(areas.x(whichdurs))];

% by duration
if strcmp(data.type,'raw') % only makes sense for discrete durations
    [uniquedurs,~,uduri]=unique(durs.x);
    durs.vs.areas.bydur=getbasicstats(areas.x',uduri);
    durs.vs.areas.bydur.uniquedurs=uniquedurs';
    %durs.vs.areas.bydur.n=accumarray(uduri',areas.x,[],@numel);
    %durs.vs.areas.bydur.mean=accumarray(uduri',areas.x,[],@mean);
    %durs.vs.areas.bydur.sd=accumarray(uduri',areas.x,[],@std);
    %durs.vs.areas.bydur.sem=durs.vs.areas.bydur.sd./sqrt(durs.vs.areas.bydur.n);
    %durs.vs.areas.bydur.median=accumarray(uduri',areas.x,[],@median);
    % currently trimming neg-area bursts, but maybe leave in since their avgs are prob ok
    %posi_meanbydur=rawareas_meanbydur>0;
    %posi_medianbydur=rawareas_meanbydur>0;
    durs.vs.areas.bydur.fits.meanlinear=polyfitfinite(log(durs.vs.areas.bydur.mean),log(uniquedurs'),1);
    durs.vs.areas.bydur.fits.medianlinear=polyfitfinite(log(durs.vs.areas.bydur.median),log(uniquedurs'),1);

    whichdurs=uniquedurs'>=fitmindur;
    durs.vs.areas.bydur.fits.meanlinearmindur=polyfitfinite(log(durs.vs.areas.bydur.mean(whichdurs)),log(uniquedurs(whichdurs)'),1);
    durs.vs.areas.bydur.fits.medianlinearmindur=polyfitfinite(log(durs.vs.areas.bydur.median(whichdurs)),log(uniquedurs(whichdurs)'),1);
    durs.vs.areas.bydur.fits.mindur=fitmindur;
    durs.vs.areas.bydur.fits.mindurarearange=[min(durs.vs.areas.bydur.mean(whichdurs)) max(durs.vs.areas.bydur.mean(whichdurs))]; % or do mean-and-median specific ranges?
else
    durs.vs.areas.bydur.n=NaN;
    durs.vs.areas.bydur.mean=NaN;
    durs.vs.areas.bydur.sd=NaN;
    durs.vs.areas.bydur.sem=NaN;
    durs.vs.areas.bydur.median=NaN;
    durs.vs.areas.bydur.fits=struct('meanlinear',[NaN NaN],'medianlinear',[NaN NaN],'meanlinearmindur',[NaN NaN],'medianlinearmindur',[NaN NaN],'mindur',NaN,'mindurarearange',[NaN NaN]);
end

% by bin
ndurbins=64; % number of bin edges is ndurbins+1
durbins=exp(linspace(log(min(durs.x)),log(max(durs.x)+1/data.Fs),ndurbins+1)); % +1/Fs so that the upper endpt definitely falls in a bin
durbins(1)=min(durs.x); % when dur is small, exp(log(x)) might be > x, causing the min to fall outside the bins
[durbincounts,durbini]=histc(durs.x,durbins);
if durbincounts(end)>0, error('dur at right end pt, should not be there'), end
durs.vs.areas.bybin=getbasicstats(areas.x,durbini');
durs.vs.areas.bybin.ndurbins=ndurbins;
durs.vs.areas.bybin.durbins=durbins;
%durs.vs.areas.bybin.n=accumarray(durbini',areas.x,[],@numel);
%durs.vs.areas.bybin.mean=accumarray(durbini',areas.x,[],@mean);
%durs.vs.areas.bybin.sd=accumarray(durbini',areas.x,[],@std);
%durs.vs.areas.bybin.sem=durs.vs.areas.bybin.sd./sqrt(durs.vs.areas.bybin.n);
%durs.vs.areas.bybin.median=accumarray(durbini',areas.x,[],@median);
% currently trimming neg-area bursts, but maybe leave in since their avgs are prob ok
%posi_meanbybin=rawareas_meanbybin>0;
%posi_medianbybin=rawareas_meanbybin>0;

% bin location could be median or mean (error in the median is?)
durs.vs.areas.bybin.durs=getbasicstats(durs.x,durbini');
%durs.vs.areas.bybin.dursn=durbincounts(1:end-1)'; % end count is for the right endpt, should be empty
%durs.vs.areas.bybin.dursmean=accumarray(durbini',durs.x,[],@mean);
%durs.vs.areas.bybin.dursmedian=accumarray(durbini',durs.x,[],@median);
%durs.vs.areas.bybin.durssd=accumarray(durbini',durs.x,[],@std);
%durs.vs.areas.bybin.durssem=durs.vs.areas.bybin.durssd./sqrt(durs.vs.areas.bybin.dursn);

durs.vs.areas.bybin.fits.meanlinear=polyfitfinite(log(durs.vs.areas.bybin.mean),log(durs.vs.areas.bybin.durs.mean),1);
durs.vs.areas.bybin.fits.medianlinear=polyfitfinite(log(durs.vs.areas.bybin.median),log(durs.vs.areas.bybin.durs.median),1);

%posi_mindur_meanbybin=posi_meanbybin & rawdurs_meanbybin>=fitmindur;
%posi_mindur_medianbybin=posi_medianbybin & rawdurs_meanbybin>=fitmindur;
whichdurs=durs.vs.areas.bybin.durs.mean>=fitmindur;
durs.vs.areas.bybin.fits.meanlinearmindur=polyfitfinite(log(durs.vs.areas.bybin.mean(whichdurs)),log(durs.vs.areas.bybin.durs.mean(whichdurs)),1);
whichdurs=durs.vs.areas.bybin.durs.median>=fitmindur;
durs.vs.areas.bybin.fits.medianlinearmindur=polyfitfinite(log(durs.vs.areas.bybin.median(whichdurs)),log(durs.vs.areas.bybin.durs.median(whichdurs)),1);

% using median durs for mindurarearange, ok to use for mean plots too?
durs.vs.areas.bybin.fits.mindurarearange=[min(durs.vs.areas.bybin.median(whichdurs)) max(durs.vs.areas.bybin.median(whichdurs))];

% bent 'bilinear' fit joining two asymptotically linear regimes
% from van Albada et al. (2010)
% p=[a b c d e], left asymptote is y=ax+b, right asymptote is y=cx+d
bilinfitflag=1;
if bilinfitflag
bilin=@(x,p) p(3).*x+(p(3)-p(1)).*p(5).*log(1+exp(-(x-(p(2)-p(4))./(p(3)-p(1)))./p(5)))+p(4);
%bilinfitfun=@(p) sum(abs(log(rawdurs_meanbybin(posi_meanbybin)) - bilin(log(rawareas_meanbybin(posi_meanbybin)),p)));
%genbilinfitfun=@(x,y,p) sum(abs(log(x) - bilin(log(y),p)));
%bilinfitfun=@(p) genbilinfitfun(durs.vs.areas.bybin.median,durs.vs.areas.bybin.durs.median,p);
%p0=[0.4,-3,0.5,-4,1]; % initial guess
%[est,~,exitflag]=fminsearch(bilinfitfun,p0);

[est,exitflag]=bilinfit(log(durs.vs.areas.bybin.median),log(durs.vs.areas.bybin.durs.median));
durs.vs.areas.bybin.fits.bilin=bilin;
durs.vs.areas.bybin.fits.medianbilin=est;
durs.vs.areas.bybin.fits.medianbilinexitflag=exitflag;
end

data.durs=durs;
data.areas=areas;

end

function out=getbasicstats(x,inds)
out.n=accumarray(inds,x,[],@numel);
out.mean=accumarray(inds,x,[],@mean,NaN);
out.sd=accumarray(inds,x,[],@std,NaN);
out.sem=out.sd./sqrt(out.n);
out.median=accumarray(inds,x,[],@median,NaN);
end

function varargout=bilinfit(x,y)
%  fit = bilinfit(x,y)
% bent 'bilinear' fit joining two asymptotically linear regimes
% from van Albada et al. (2010)
% p=[a b c d e], left asymptote is y=ax+b, right asymptote is y=cx+d
ok=isfinite(x) & isfinite(y); % only take finite vals
x=x(ok); y=y(ok);
bilin=@(x,p) p(3).*x+(p(3)-p(1)).*p(5).*log(1+exp(-(x-(p(2)-p(4))./(p(3)-p(1)))./p(5)))+p(4);
bilinfitfun=@(p) sum(abs(y - bilin(x,p)));
%p0=[0.4,-3,0.5,-4,1]; % initial guess
leftguess=polyfit(x(x<median(x)),y(x<median(x)),1);
rightguess=polyfit(x(x>median(x)),y(x>median(x)),1);
p0=[leftguess,rightguess,1]; % initial guess
[est,~,exitflag]=fminsearch(bilinfitfun,p0,optimset('maxFunEvals',2000,'maxIter',2000,'Display','off'));
%[est,~,exitflag]=fminsearch(bilinfitfun,p0);

varargout{1}=est;
varargout{2}=exitflag;

end

function varargout = polyfitfinite(x,y,n)
% wrapper for polyfit to ignore NaNs and Infs
ok=isfinite(x) & isfinite(y);
ws = warning('off','all');
[varargout{1:nargout}] = polyfit(x(ok),y(ok),n); 
warning(ws)  % Turn it back on.
end

