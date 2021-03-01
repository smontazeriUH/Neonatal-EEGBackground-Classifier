function val=wavelet_coeff_toronto(data,fs)
num_layers=7;
num_coeffs=8;
%[h,g,rh,rg]=daub(num_coeffs);
[h,g,rh,rg]=wfilters('db8');


%wav_res=wt(data,h,g,num_layers);
wav_res=wavedec(data,num_layers, h,g);
pos=sub_pos(length(data),num_layers);
bands=extract_subbands(wav_res,pos);

%MEAN OF COEFFICIENTS AND ABSOLUTE ENERGY
for j=1:length(bands)
    mean_coeffs(j)=mean(abs(bands{j}));
end
val = mean_coeffs(5);

