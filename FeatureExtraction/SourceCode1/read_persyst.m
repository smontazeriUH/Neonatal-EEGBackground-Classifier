function [dat, HDR] = read_persyst(fname1, fname2)
%
%
%
%
%
%
%

%fname1 = 'Xxxxxxx_parc.lay';
%fname2 = 'Xxxxxxx_parc.dat';
fid1 = fopen(fname1);
A = textscan(fid1, '%s');
fclose(fid1);

% BARE MINIMUM FOR NOW
str = cell(1,10);
str{1} = '[FileInfo]';
str{2} = '[ChannelMap]';
str{3} = '[Sheets]';
str{4} = '[VPlotGroups]';
str{5} = '[Comments]';
str{6} = '[Patient]';
str{7} = 'TestDate';
str{8} = 'TestTime';
str{9} = 'Calibration';
str{10} = 'SamplingRate';
str{11} = 'WaveformCount';

ref1 = zeros(1,length(str)); 
for ii = 1:length(A{1})
 tstr = A{1}{ii};
 for jj = 1:length(str)
    val1 = strfind(tstr, str{jj});
    if isempty(val1)==0; ref1(jj) = ii; end
  end    
end

flag = 0; inc = ref1(2)+1;
while flag == 0;
    tstr = A{1}{inc};
    val1 = strfind(tstr, '[');
    if isempty(val1)==0; flag = 1; end
    inc = inc+1;
end

HDR = [];
dum = A{1}{ref1(7)};
HDR.TestDate = dum(strfind(dum, '=')+1:end);
dum = A{1}{ref1(8)};
ndum = dum(strfind(dum, '=')+1:end);
dur = str2num(ndum(1:2))*3600+str2num(ndum(4:5))*60+str2num(ndum(7:8));
HDR.TestTime = dur;
dum = A{1}{ref1(9)};
HDR.Calibration = str2num(dum(findstr(dum, '=')+1:end));
dum = A{1}{ref1(10)};
HDR.SamplingFrequency = str2num(dum(findstr(dum, '=')+1:end));
len_s = dur.*HDR.SamplingFrequency;
dum = A{1}{ref1(11)};
HDR.ChannelNumber = str2num(dum(findstr(dum, '=')+1:end));
cn = HDR.ChannelNumber;
HDR.Labels = A{1}(ref1(2)+1:inc-2);

fid2 = fopen(fname2);
dat = zeros(len_s,cn, 'int16');
for ii = 1:len_s;
        dat(ii,:) = fread(fid2, cn, 'short', 0, 'ieee-le')';        
end
fclose(fid2);
