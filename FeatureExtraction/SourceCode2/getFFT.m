function O = getFFT(input,wl,ws,fs)

input = filter([1 -0.95],1,input);

wl = round(wl*fs);
ws = round(ws*fs);
ww = hamming(wl);

input = [zeros(round((wl-1)/2),1);input;zeros(round((wl-1)/2),1)];

O = zeros(round(length(input)/wl)-1,wl/2+1);
j = 1;
for wloc = 1:ws:length(input)-wl+1
    
    x = input(wloc:wloc+wl-1).*ww;
    
    y = (abs(fft(x)));
    
    y = y(1:round(wl/2)+1);    
    
    O(j,:) = y;
    j = j+1;   
end
