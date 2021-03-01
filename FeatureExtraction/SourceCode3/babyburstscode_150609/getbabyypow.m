function out=getbabyypow(j,sgfk)
%  ypowfilt = getbabyypow(j,[sgfk])
% Read in time series for baby j, calculate instantaneous power, and apply
% the sgolay filter
%
% Optional input sgfk = [f k] for sgolay(...,k,f)
%
% To do: (?) output t
%         -  make options accessible

if nargin<2
    sgfk=[49 10]; % k,f = 10,49 = 18.55 Hz cutoff; 12,27=41 Hz
end

premieflag=0;
if ~premieflag
    % hypoxia data
    % (OLD)
    % addpath L:\Lab_MichaeBr\kartikI\MATLAB\aval2012\cohort' 2 mat'\
    % OR, with all data definitely exported at 250 Hz:
    % addpath L:\Lab_MichaeBr\kartikI\MATLAB\aval2012\cohort' 2 mat'\cohort_250\
    % NOW OLD PATH:
    % addpath L:\Lab_MichaeBr\kartikI\MATLAB\aval2012\working\data\cohort_250\
    % NEW PATH: ****NOTE**** rerun anything using 19_1, earlier I used
    %           \analysis\ not \analysis\cohort_250\, which differs there
    % addpath L:\Lab_MichaeBr\kartikI\MATLAB\Avalanche_cohort_1\working\analysis\cohort_250
    instrings={'1_1','1_2','2_1','3_1','3_2','3_3','3_4','3_5','3_6',...
        '4_1','4_2','4_3','4_4','5_1','5_2','6_1','6_2',...
        '7_1','7_2','7_3','8_1','8_2','8_3','9_1','9_2','9_3','9_4',...
        '10_1','10_2','10_3','11_1','11_2','11_3','11_4',...
        '12_1','12_2','12_3','13_1','13_2','14_1','14_2',...
        '15_1','15_2','16_1','16_2','17_1','17_2',...
        '18_1','18_2','18_3','18_4','19_1','19_2','19_3',...
        '20_1','20_2','20_3'};
else
    % premie data
    % addpath L:\Lab_MichaeBr\kartikI\MATLAB\eeglab9_0_4_6s\premie\
    instrings={'29_A','29_B','40_A','40_B','41_A','41_B','44_A','44_B','44_C'};
end

if sgfk(1)==0
    sgolayflag=0;
else
    sgolayflag=1;
end

% final 10 babies
%bs_set=[11 18 22 26 29 38 42 44 46 48];
%cts_set=[13 20 23 27 30 39 43 45 47 49];
%bs_dist_set=[9 11 15 18 22 26 29 32 38 42 44 46 48];
%runset=sort([bs_set cts_set]);
%runset=bs_dist_set;

if ~premieflag
    indata=load([instrings{j} '_ava']);
else
    indata=load([instrings{j} '_ava_p3_p4']);
end
y=indata.P3_P4;

%Fs=250; % NOT for all, check using spectra?

yamp = abs(hilbert(y));
ypow = yamp.^2;
if sgolayflag
    ypowfilt = sgolayfilt(ypow,sgfk(2),sgfk(1))'; 
else
    ypowfilt=ypow'; %#ok<*UNRCH>
end

out=ypowfilt;
