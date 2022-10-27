

%% Cac thong so dau vao
clear all
clear variable
F0 = 120; %50 120 250
Fs = 1000;
A = 10;
SNR = -40;
L = 1500;

%% Tao tin hieu sin

%Tin hieu goc
T = 1/Fs;             
t = (0:L-1)*T;
S0 = A*sin(2*pi*F0*t); 

%Tao nhieu
Psignal = A*A/2;
Pnoise = Psignal/(10.^(SNR/20));
z = sqrt(Pnoise)*randn(size(t)); 
S = S0 + z; 

% Frequency Bin
fbin = Fs/L;
fbin_odd = F0/fbin;



%% Ve do thi tin hieu sin 

subplot(2,1,1);
S1 = S/max(S);
plot(t(1:L),S1(1:L),'LineWidth',1);
ylim([-1 1]);
txt = sprintf('Signal waveform (with noise)F0 = %d, Fs = %d, SNR = %d', F0, Fs, SNR);

title(txt);
xlabel('Time (seconds)');
ylabel('Magnitude (normalized)');


%% Bien doi Fourier su dung FFT
% FFT voi tin hieu ban dau
Y = fft(S); 

% Tim F'0 
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
[maxP1, index] = max(P1);
fo = f(:,index);

% Ve bieu do tren mien tan so
subplot(2,1,2); 
plot(f,P1/maxP1,'LineWidth',1, 'HandleVisibility','off');
hold on;
plot(0,0,'Color', 'g');
hold on;
plot(0,0,'Color', 'r');
hold on;
txtF0 = sprintf('F0 = %f', F0);
txtf0 = sprintf('f0 = %f', fo);

legend(txtF0, txtf0);
xline = zeros(2,2);
yline = zeros(2,2);
yline(2,1) = 1;
yline(1,1) = 0;
xline(1,1) = F0;
xline(2,1) = F0;
line(xline, yline,  'Color', 'g', 'LineWidth',1, 'HandleVisibility','off');
xline(1,1) = fo;
xline(2,1) = fo;
line(xline, yline,  'Color', 'r', 'LineWidth',1, 'HandleVisibility','off');
title('Freq Domain');
xlabel('Frequencies (Hz)');
ylabel('Magnitude (normalized)');





