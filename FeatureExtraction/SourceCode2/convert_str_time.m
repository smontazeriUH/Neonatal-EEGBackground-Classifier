function tref  = convert_str_time(str);

dy = str2num(str(1:2));
mnh = str2num(str(4:5)); 
yr = str2num(str(7:10));
hr = str2num(str(12:13)); 
mn = str2num(str(15:16));
sc = str2num(str(18:19));
dref = month_test(mnh, yr)+dy+floor((yr-2000)*365.25);
tref = dref*86400+hr*3600+mn*60+sc;