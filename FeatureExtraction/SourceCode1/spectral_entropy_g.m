% EEG Spectral entropy per epoch
function H = spectral_entropy_g(spectrum,w)

flag=0;     % flag=1, for loop version. flag=0 vectorized calculation

% psd = spectrum;
% H = -(sum(psd.*log2(psd+eps)));          % spectral entropy per epoch (poor performance)

psd = spectrum;
pdf = zeros(size(spectrum));
if(flag==1)
    for i = 1:1:w
        pdf(:,i) = psd(:,i)./(sum(psd(:,i))+eps);     % Sissy for loop version 
    end
elseif(flag==0)
    pdf = psd./(repmat(sum(psd,1),size(psd,1),1)+eps);     % Macho vectorized SE calculation
end

H = -(sum(pdf.*log2(pdf+eps)));          % spectral entropy per epoch