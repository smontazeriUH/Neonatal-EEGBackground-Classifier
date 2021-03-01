function out=extractavdata(bursts,measure,mindur)
%  out=extractavdata(bursts,measure,mindur)
% Extract areas and/or durations from cell array of bursts
% measure to return 'areas', 'durs', or 'both' (struct out.areas, out.durs)
% mindur in s (NOT yet written for raw bursts)

if nargin<3, mindur=0; end
if nargin<2, measure='both'; end

Fs=250;

disttype='interp'; % 'raw' or 'interp'

% % % % lifting from extractavstats % % % %

interpflag=1;
rawflag=0;

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
    
    % ADD: code to trim to mindur
    
    %raw=getstats(raw);
    
    %out.raw=raw;
end

% bursts with ends interpolated
if interpflag
    [t_interpends,bursts_interpends]=burstinterp(bursts,'ends');
    interpdurs=cellfun(@(x) x(end)-x(1),t_interpends)/Fs; % in s
    interpareas=cellfun(@trapz,t_interpends,bursts_interpends)/Fs; % in uV^2 s
    
    okdur=interpdurs>=mindur;
    interpdurs=interpdurs(okdur);
    interpareas=interpareas(okdur);
    
    %interp.durs.x=interpdurs;
    %interp.areas.x=interpareas;
    %interp.Fs=Fs;
    %interp.type='interp';
    
    %interp=getstats(interp);
    
    %out.interp=interp;
end

switch measure
    case 'areas'
        out=interpareas;
    case 'durs'
        out=interpdurs;
    case 'both'
        out.areas=interpareas;
        out.durs=interpdurs;
end