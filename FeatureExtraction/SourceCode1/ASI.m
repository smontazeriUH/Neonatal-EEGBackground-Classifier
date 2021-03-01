function [ASIval,ETDFval,tau] = ASI(filename,electrodes,segment)
% function [ASIval,ETDFval,tau] = ASI(filename,electrodes,segment)
% 
% Returns Activation Synchrony Index (ASI) between two given electrode channels in 
% the input .edf file.
%
%   ASI(filename) returns the ASI computed from the .edf file specified in
%   filename using 'F3-P3' and 'F4-P4' electrodes.
%
%   ASI(filename,electrodes) uses desired electrode channels in the ASI
%   computation, given in format: "electrodes = {'ele1';'ele2'}".
%
%   ASI(filename,electrodes,segment) computes ASI using only signal withing
%   temporal boundaries defined in segment, format: [starttime endtime] (in
%   seconds).
%
%   Note: main ASI computation is performed in getASI() function. ASI()
%   simply handles processing with biosig toolkit. 
%
%   Outputs:
%
%   ASIval      =   ASI-index. Higher means more synchrony. ASI=1 means random.
%   ETDFval        =   Energy-weighted temporal dependency function between the two
%                   signals (see Rasanen & Vanhatalo, 2013).
%   tau         =   timestamps for the ETDFval  
%
%   USE EXAMPLE:
%   
%   Syntax:
%
%   [ASIval,ETDFval] = ASI('myedffile.edf',{'F3-C3';'F4-C4'},[0 60])
%
%   will compute ASI from myedffile.edf between bipolar channels F3-C3 and
%   F4-C4 using only the first 60 seconds of the signal.
% 
%   Longer signals give more accurate ASI estimates.
%
%   (c) Okko Rasanen & Sampsa Vanhatalo, 2013, 2017
%
%   Update v0.11, 10/10/2017
%       - changed ASI.m to use Biosig edf.-reader to edfread.m by MathWorks

if (nargin <2 || isempty(electrodes))
    electrodes = {'F3-P3';'F4-P4'};    
end

curdir = fileparts(which('ASI.m'));
addpath([curdir '/edfread/']);

ASIval = [];
ETDFval = [];


[header,signal] = edfread(filename);
if(size(signal,1) < size(signal,2))
    signal = signal';
end

fs = header.frequency(1);
% If segment is defined, use only subset of the total data
if (nargin ==3 && ~isempty(segment))   
    signal = signal(max(segment(1)*fs+1,1):min(segment(2)*fs,size(signal,1)),:);
end       

% Find correct signal channels by comparing Label-field of the .edf file
% and the user provided channel labels
chans = zeros(2,1);
for e = 1:length(electrodes)
    for k = 1:length(header.label)
        a = strfind(header.label{k},electrodes{e});
        if(~isempty(a))
            chans(e) = k;
        end
    end
    if(chans(e) == 0)
        fprintf('Did not find channel %s.\n',electrodes{e});
    end
end

% Default channel F3-P3 is derived from F3-C3 and C3-P3 (same for the right
% hemisphere).
if(strcmp(electrodes{1},'F3-P3') || strcmp(electrodes{1},'F4-P4') && chans(1) == 0)
    fprintf('Deriving F3-P3 from F3, C3 and P3 (and same for F4-P4).\n');
    electrodes = {'F3-C3';'F4-C4';'C3-P3';'C4-P4'};
    
    chans = zeros(4,1);
    for e = 1:length(electrodes)
        for k = 1:length(header.label)
            a = strfind(header.label{k},electrodes{e});
            if(~isempty(a))
                chans(e) = k;
            end
        end
    end
    
    if(sum(chans == 0))
       error('Couldn''t find F3-C3, C3-P3, F4-C4, and C4-P4. Cannot use default channels.'); 
       fprintf('The given .edf file contains the following channels:\n');
       for j = 1:length(header.label)
           fprintf('%s\n',header.label{j});
       end
    end
        
    st = [];
    st(:,1) = signal(:,chans(1))+signal(:,chans(3));
    st(:,2) = signal(:,chans(2))+signal(:,chans(4));
    signals = st;        
else
    if(sum(chans == 0) == 0)
        signals = signal(:,chans);       
    else
        fprintf('Couldn''t find or derive channels %s and %s\n',electrodes{1},electrodes{2}); 
        fprintf('The given .edf file contains the following channels: ');
        for j = 1:length(header.label)-1
           fprintf('%s, ',header.label{j});
           if(mod(j,10) == 0)
               fprintf('\n');
           end
        end
        fprintf('%s.\n',header.label{end});
        
        return
    end
end

% Compute the actual ASI
[ASIval,ETDFval,tau] = getASI(signals,fs);






