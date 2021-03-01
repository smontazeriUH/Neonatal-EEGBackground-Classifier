function out = extractshapes_singledur(bursts,dur,indices,prescaleavgs,onlyshapes)
% out = extractshapes_singledur(bursts,dur,indices)
% Extract avshape across all given bursts and rescaled onto the given
% duration
% For use in extractshapes2
%
% *** REWRITE OF ORIGINAL EXTRACTSHAPES:
%
% EXTRACTSHAPES implements analysis via resampling and interpolating using ratios of
% fixed durations to array size
%
%   Inputs:
%   avalanches  = cell array of all avalanche type fluctuations extracted
%   ithr = ideal threshold
%   durs = bin edges for duration binning into intervals [...)
%
% Modified by JR on 16/08/12 to change durs
% Modified by JR on 21/09/12 to accept indices as an argument, to select a
%     subset of avalanches
% Modified by JR on 25/09/12 to no longer expect avs as a cell in a cell,
%     and to take durs as an argument, and drop ibis as an argument,
%     renamed num_avs to dur_avs, rewrote calculation of fdur, tidied the
%     cell indexing in the q loop, changed posvect padding to deal with
%     both end points correctly, fixed all cell array preallocations,
%     protected against empty bins, commented out unused bits, cleaned up
%     discarding of out-of-range flucts
% Modified by JR on 09/10/12 to fix skewness denominator exponent
% Modified by JR on 22/01/12 to no longer shift each av to have thr=0 since
%     this is now done in fluctuations.m (now no use for thr as an argument
%     apart from storing the threshold with the shapes?)
% Merged by JR on 13/02/13 with KI version 11/02/13 - distinguishing
%     between raw fluctuations and fluctuations_trimmed (the ones
%     restricted to the range of durs), outputting untrimmed areas and
%     durations
% Renamed by JR on 13/02/13 to extractshapes.m (was shapes_int_JR.m).

if exist('indices','var')
    bursts=bursts(indices);
end
if nargin<4
    prescaleavgs=0;
end
if nargin<5
    onlyshapes=0; % don't calculate durs, areas, amps
end

if isempty(bursts)
    out=emptyoutput(dur);
    return
end

Fs=250; % sampling frequency

% basic stats on raw bursts as given
nbursts=length(bursts);
if ~onlyshapes
    rawdurs=cellfun('length',bursts)/Fs; % in s
    rawdursi=cellfun('length',bursts); % in time steps
    rawareas=cellfun(@trapz,bursts)/Fs; % in uV^2 s
    rawamps=cellfun(@max,bursts); % in uV
else
    rawdurs=NaN; rawdursi=NaN; rawareas=NaN; rawamps=NaN;
end

% interpolate onto a grid of dur+1 pts from 0 to dur
[t_int,bursts_int]=burstinterp(bursts,'uniform',dur,0);

% basic stats on interpolated bursts
if ~onlyshapes
    interpdurs=cellfun(@(x) x(end)-x(1),t_int)/Fs; % in s
    interpareas=cellfun(@trapz,t_int,bursts_int)/Fs; % in uV^2 s
    interpamps=cellfun(@max,bursts_int); % in uV
else
    interpdurs=NaN; interpareas=NaN; interpamps=NaN;
end

% option to rescale all bursts to have unit area before averaging
%prescaleavgs=0;
if prescaleavgs
    bursts_int_preavg=cellfun(@(t,y) y/trapz(t,y),t_int,bursts_int,'UniformOutput',false);  %#ok<*UNRCH>
else
    bursts_int_preavg=bursts_int;
end

bursts_int_matrix=cell2mat(bursts_int_preavg'); % stack each shape as a row of a matrix

% average shape before final normalization
tt_unscaled=t_int{1};
avshape_unscaled=mean(bursts_int_matrix,1);
avshape_unscaled_sd=std(bursts_int_matrix);
avshape_unscaled_sem=avshape_unscaled_sd/sqrt(size(bursts_int_matrix,1));
avshape_unscaled_area=trapz(tt_unscaled,avshape_unscaled);
% normalized average shape
tt=tt_unscaled/tt_unscaled(end);
sc=avshape_unscaled_area/tt_unscaled(end); % rescale to unit area
avshape=avshape_unscaled/sc;
avshape_sd=avshape_unscaled_sd/sc;
avshape_sem=avshape_unscaled_sem/sc;

% calculate statistics (skewness, kurtosis) on the normalized avshape
% continuous 'pdf' form
tbar=trapz(tt,avshape.*tt);
skewc=trapz(tt,avshape.*(tt-tbar).^3)/(trapz(tt,avshape.*(tt-tbar).^2)).^(3/2);
kurc=trapz(tt,avshape.*(tt-tbar).^4)/(trapz(tt,avshape.*(tt-tbar).^2)).^2 - 3; % -3 for excess kurtosis
% discrete 'pdf' form
avshaped=avshape/sum(avshape); % avshape normalized as though it were a discrete pdf
tbard=sum(tt.*avshaped);
skewd=sum((tt-tbard).^3.*avshaped)/(sum((tt-tbard).^2.*avshaped)).^(3/2);
kurd=sum((tt-tbard).^4.*avshaped)/(sum((tt-tbard).^2.*avshaped)).^2 - 3;

% outputs
out.dur = dur;
out.nbursts=nbursts;
out.rawdurs = rawdurs;
out.rawdursi = rawdursi;
out.rawareas = rawareas;
out.rawamps = rawamps;
out.interpdurs=interpdurs;
out.interpareas=interpareas;
out.interpamps=interpamps;
out.tt_unscaled=tt_unscaled;
out.tt=tt;
out.avshape_unscaled=avshape_unscaled;
out.avshape_unscaled_sd=avshape_unscaled_sd;
out.avshape_unscaled_sem=avshape_unscaled_sem;
out.avshape_unscaled_area=avshape_unscaled_area;
out.avshape = avshape;
out.avshape_sd=avshape_sd;
out.avshape_sem=avshape_sem;
out.tbar=tbar;
out.kurc = kurc; 
out.skewc = skewc;
out.avshaped=avshaped;
out.tbard=tbard;
out.kurd = kurd; 
out.skewd = skewd;
out.prescaleavgs=prescaleavgs;



end

function out=emptyoutput(dur)
% outputs
out.dur = dur;
out.nbursts=NaN;
out.rawdurs = NaN;
out.rawdursi = NaN;
out.rawareas = NaN;
out.rawamps = NaN;
out.interpdurs=NaN;
out.interpareas=NaN;
out.interpamps=NaN;
out.tt_unscaled=NaN;
out.tt=NaN;
out.avshape_unscaled=NaN;
out.avshape_unscaled_sd=NaN;
out.avshape_unscaled_sem=NaN;
out.avshape_unscaled_area=NaN;
out.avshape = NaN;
out.avshape_sd=NaN;
out.avshape_sem=NaN;
out.tbar=NaN;
out.kurc = NaN; 
out.skewc = NaN;
out.avshaped=NaN;
out.tbard=NaN;
out.kurd = NaN; 
out.skewd = NaN;
out.prescaleavgs=NaN;
end


% don't really need this anymore, but in case it needs to be worked back in
% here's the orig code for inv parabola and semicircle and alternative
% skewness methods:
%
%         avshape{t} = totshape{t};
%     %     avshape_i{t} = totshape2{t};
%         %semicircle
%         se{t} = sqrt(tsc{t}.*(1-tsc{t}))./0.5;
%         ua{t} = trapz(tsc{t},se{t}); %trapz(se{t})/length(se{t});
%         sea{t} = se{t}/ua{t};
%         %parabola
%         qe{t} = -tsc{t}.^2+tsc{t};
%         upa{t}= trapz(tsc{t},qe{t});
%         qea{t}= qe{t}/upa{t};
% 
%         invshape{t}= (avshape{t}'-sea{t})';
%         parab{t}=(avshape{t}'-qea{t});
%         %if t ==length(tsc) %?!
%         %    break
%         %end
% 
% skewsub=cell(1,lendur);
% areadiff=zeros(1,lendur);
% for f = 1:lendur
%     if ~isempty(shape{f})
%         V = out.avshape{f};
%         Vlen = length(V);
% 
%         skewsub{f} = V(1:floor(Vlen/2))-V(ceil(Vlen/2)+1:Vlen);
%         area1 = trapz(1:length(V(1:floor(Vlen/2))),V(1:floor(Vlen/2)));
%         area2 = trapz(1:length(V(ceil(Vlen/2)+1:Vlen)),V(ceil(Vlen/2)+1:Vlen));
% 
%         areadiff(f) = area1 - area2;
%     else
%         %skewsub{f}=NaN; % just leave empty
%         areadiff(f)=NaN;
%     end
% end
% out.minus_skew = {skewsub};
% out.areadiffs = areadiff;
% out.fdur = fdur;
% ar_quad_diff=zeros(1,lendur);
% for k = 1:lendur
%     if ~isempty(tscale{f})
%         %T= length(out.tscale{k});
%         %tsc = out.tscale{k};
%         %t=T*tsc;
% 
%         %tt{k}=t;
% 
%         %sig_invshape = out.invshape{k};
%         %sig_invshape(sig_invshape>=0)=0;
%         %sig_invshape = abs(sig_invshape);
%         %sig_invshape(sig_invshape==0)=[];
% 
%         sig_parab = out.parab{k};
%         sig_parab(sig_parab>=0)=0;
%         sig_parab = abs(sig_parab);
%         sig_parab(sig_parab==0)=[];
% 
%         %diff_semi=sig_invshape;
%         diff_quad=sig_parab;
%         %
%     %     ar_semi_diff(k)=trapz(tt{k},diff_semi{k});
%         %ar_semi_diff(k)=trapz(1:length(sig_invshape),diff_semi)/length(sig_invshape);
%     %     ar_quad_diff(k)=trapz(tt{k},diff_quad{k});
%         ar_quad_diff(k)=trapz(1:length(sig_parab),diff_quad)/length(sig_parab);
%     else
%         ar_quad_diff(k)=NaN;
%     end
% end
% % out.kura = kur_area; 
% out.kura=ar_quad_diff;