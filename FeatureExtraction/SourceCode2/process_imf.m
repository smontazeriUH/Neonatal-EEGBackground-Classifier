function [H,A,F]=process_imf(eeg_seg,Fs)
%Input:
%x - Input signal
%Fs - sampling frequency
%Output:
%H - Signal and Hilbert transform of input signal i.e H=x+jH(x)
%A - Instantaneous amplitude
%F - instantaneous frequency

%%% Edited By Saeed For one channel analysis

Y = hilbert(eeg_seg);
H = Y;
A = abs(Y); %Instantaneous amplitude
%Finding the instantaneous phase
Ang = atan(imag(Y)./real(Y));
Ang = Ang;
%Finding the instantaneous frequency
F = (Ang(2:end)-Ang(1:end-1))*(Fs/(2*pi));
F = [F 0];
[indx] = find(F(2:end) < 0);
F(indx+1) = F(indx);

% F = [F zeros(size(eeg_seg,1), 1)];
% [row, col] = find(F < 0);
% for i = 1 : size(row,1)
%     if (col(i) - 1 > 0)
%         F(row(i), col(i)) = F(row(i), col(i) - 1);
%     end
% end

