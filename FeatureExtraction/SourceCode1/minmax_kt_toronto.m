function num = minmax_kt_toronto(epoch)


num_max = length(findpeaks(epoch));
num_min = length(findpeaks(epoch.*(-1)));

num = num_max + num_min;
