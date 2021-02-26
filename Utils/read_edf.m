function [dat, hdr, label, fs, scle, offs, len_s, DateTime] = read_edf(filename)
% [data, hdr, label] = read_edf(filename);
%
% This functions reads in a EDF file as per the format outlined in
%  http://www.edfplus.info/specs/edf.html
%
% INPUT: filename - EDF file name
%
% OUTPUT: dat - a cell array containing the data in the file (int16 format)
%                   hdr - a cell array the header file information in ASCII format
%                   label - a cell array containing the labels for each
%                   channel in dat (ASCII format)
%                   DateTime - Starting date and time for the recording
%                   len_s - duration of the recording    
%                   
%
% Nathan Stevenson, modified by Minna Kauppila 10.2.2018

fid = fopen(filename, 'r'); %opens the file for binary read access and returns an integer file
hdr = cell(1);
hdr{1} = fread(fid, 256, 'char');         % CONTAINS PATIENT INFORMATION, RECORDING INFORMATION, taking first 256 bytes of the header record
stdt = char(hdr{1}(169:176)); %TestDate
t = datevec(datetime(stdt','InputFormat','dd.MM.yy'));
stt = char(hdr{1}(177:184)); %TestTime
startTime=([(stt(1:2)') ':' (stt(4:5)') ':' (stt(7:8)')]);
startTime=datevec(startTime,'HH:MM:SS');
startTime(1)=0;startTime(2)=0;startTime(3)=0;
DateTime=t+startTime;
%start_time = month_test(str2num(stdt(4:5)'))*24*60*60 + str2num(stdt(1:2)')*24*60*60 + str2num(stt(1:2)')*60*60 + str2num(stt(4:5)')*60+str2num(stt(7:8)');
len_s = str2num(char(hdr{1}(235:243))'); % number of data records      % START DATE AND TIME and a RESERVED 
%len_s = str2num(len_s)*
rec_dur = str2num(char(hdr{1}(244:252))'); %Duration of data records (8 ascii)
ns = char(hdr{1}(253:256))'; %Number of channels
ns = str2num(ns); %Number of signals (ns) in data record (4 ascii)
hdr{2} = fread(fid, ns*16, 'char');    % LABEL channel label, temp or HR
hdr{3} = fread(fid, ns*80,'char');     % TRANSDUCER TYPE
hdr{4} = fread(fid, ns*8,'char');       % PHYSICAL DIMENSION, voltage - temperature
hdr{5} = fread(fid, ns*8,'char');       % PHYSICAL MIN (corresponds to digital extremes and is expressed by the specified physical dimension of the signal)
hdr{6} = fread(fid, ns*8,'char');       % PHYSICAL MAX
hdr{7} = fread(fid, ns*8,'char');       % DIGITAL MIN (specify the extreme values that can occur in the data records)
hdr{8} = fread(fid, ns*8,'char');       % DIGITAL MAX (specify the extreme values that can occur in the data records)
label = cell(1);
for jj=1:ns; %going through every signal
rf2 = jj*8; rf1 = rf2-7; %length of the name of the electrode is 8
label{jj}=(char(hdr{2}(16*(jj-1)+1:16*(jj-1)+16)));
% % % a = ((char(hdr{2}(16*(jj-1)+1:16*(jj-1)+16))));
% % % b=string(a);
% % % label{jj}=strjoin(b);
phy_lo(jj) = str2num(char(hdr{5}(rf1:rf2))');
phy_hi(jj) = str2num(char(hdr{6}(rf1:rf2))');  
dig_lo(jj) = str2num(char(hdr{7}(rf1:rf2))');
dig_hi(jj) = str2num(char(hdr{8}(rf1:rf2))');
end
%offs = (phy_hi./dig_hi+phy_hi./dig_lo)./2; % Offset if required
scle = (phy_hi-phy_lo)./(dig_hi-dig_lo);
offs = (phy_hi+phy_lo)/2; %Mean

hdr{9} = fread(fid, ns*80,'char');  %Prefiltering                  % PRE FILTERING
hdr{10} = fread(fid, ns*8, 'char'); %Number of samples of each data record                % SAMPLING NO rec
nsamp = str2num(char(hdr{10})'); %Number of samples in each data record
hdr{11} = fread(fid, ns*32,'char');     % RESERVED    
fs = nsamp/rec_dur; %Sampling frequency

% Build the empty data matrix of size INT16 not double
dat = cell(1, ns);
for jj = 1:length(nsamp); %Going through every sample
 %   len_s.*nsamp(jj)
       dat{jj} = int16(zeros(1,len_s*nsamp(jj)));        
end

% Load data into dat array from EDF file: there are length(nsamp) channels
% and the size of each channel will be len_s * nsamp(ii)
for ii = 1:len_s; %Going through number of data records
    for jj = 1:length(nsamp); %Going through every sample
        r1 = nsamp(jj)*(ii-1)+1; r2 = ii*nsamp(jj);
        dat{jj}(r1:r2) = fread(fid, nsamp(jj), 'short')';    
    end
end

% TRY while (~feof(fid)) ii =ii+1 end
% for ii = 1:ns;
% dat{ii} = dat{ii}.*scle(ii);
% end
