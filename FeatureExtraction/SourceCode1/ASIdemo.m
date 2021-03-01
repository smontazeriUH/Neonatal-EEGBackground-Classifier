clear all

%%%%%%%%%%%%%%%%%%%%%%%%
% Brief instructions:
%
% 1) Use getASI(x,fs) to compute ASI between two equal length signal
% waveforms stored into an array x at a sampling rate fs (example 1)
% 2) Use ASI() to compute ASI from an .edf file (example 2)
% 
% see getASI() and ASI() for syntax and parameters.
%


%%%%%%%%%%%%%%%%%%%%%%%%
% Example 1: Generate a random noise signal with sinusoid-pulses at varying
% intervals and compare it against itself at different time shifts

fs = 50;
t = 0:1/fs:0.5; % Create 1 sec bursts
burst = sin(2.*pi*1*t);

x = [];
for k = 1:30    
    noise = randn(1,randi(length(t)*15));
    x = [x noise burst];
end

% Compute ASI between the signal and a temporally shifted versions of the
% same signal

ASIval = zeros(101,1);
ETDFval = cell(101,1);
for k = -50:50
   signal = [x' circshift(x',k)];   % <-- signal time shift by k samples (-1 sec to +1 sec at 50 Hz ).
   [ASIval(k+51),ETDFval{k+51},tau] = getASI(signal,fs);
end


% Plot results
figure;
subplot(3,1,1);
t_plot = 0:1/fs:length(x)/fs-1/fs;
plot(t_plot,x);
xlabel('time (sec)');
ylabel('amplitude');
title('Original signal');


t = -1:1/50:1;
subplot(3,1,2);plot(t,ASIval,'LineWidth',1);
xlabel('relative delay (seconds)');
ylabel('ASI');
grid;
title('ASI as a function of time shift between channels');


subplot(3,1,3);plot(tau,ETDFval{51},'DisplayName','non-shifted');
hold on;
plot(tau,ETDFval{end},'Color','red','DisplayName','1 sec shift');
xlabel('delay (sec)');
ylabel('ETDFval');
title('Distribution of synchronized energy at zero and 1 sec delays');
grid;
legend('Location','NorthEast');

%%%%%%%%%%%%%%%%%%%%%%%%
% Example 2: Compute ASI from a custom .edf file 

filename = INSERT_YOUR_FILE_PATH_HERE;

 % choose a pair of electrodes that exist in your .edf file
electrodes = {'F3-P3';'F4-P4'};

% Compute ASI from the entire signal so segment param can be neglected.
segment = [];

[ASIval,ETDFval] = ASI(filename,electrodes,segment);


