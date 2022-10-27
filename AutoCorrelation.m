clear all
F0 = 120;  
Fs = 1000; % Sampling frequency
A = 1;
SNR = -20;
Psignal = A*A/2;
Pnoise = Psignal/(10^(SNR/20));  

T = 1/Fs; % Sampling period       
L = 1000; % Length of signal
t = (0 : L - 1)*T;

S = A*sin(2*pi*F0*t); % Sin signal

X = S + sqrt(Pnoise)*randn(size(t)); % Sin signal with noise
subplot(3, 1, 1)
plot(X);
xlabel('n');
ylabel('Amplitude');
title('Input signal with noise');
legend('singal with noise');

% RX: auto correlation of X
[RX, lags] = MyXcorr(X);

% Half_RX: half of RX
Half_RX = zeros(1, L - 1);
for i = 1 : L - 1
    Half_RX(i) = RX(i + L);
end

%normalize Half_RX
Half_RX = Half_RX/max(abs(Half_RX));
subplot(3, 1, 2);
plot(Half_RX);
%plot(RX);
xlabel('n');
ylabel('Amplitude (nomalized)');
title('Half of auto correlation of X');
legend('auto correlation');

if Fs >= 2000
    Half_RX_Smooth = smooth(Half_RX, 15);
 
    %normalize Half_RX_Smooth
    Half_RX_Smooth = Half_RX_Smooth/max(abs(Half_RX_Smooth));
    subplot(3, 1, 3);
    plot(Half_RX_Smooth);
    xlabel('n');
    ylabel('Amplitude (nomalized)');
    title('Half of auto correlation of X after smoothing');
    legend('auto correlation');
    
    %find peaks of Half_RX
    [pks, locs] = findpeaks(Half_RX_Smooth);
else
    [pks, locs] = findpeaks(Half_RX);
end

N0 = locs(1);
N1 = locs(2);
N2 = locs(3);
N = (N0 + (N1 - N0) + (N2 - N1))/3;
F_result = Fs/N;

disp(['F0 (Hz) xac dinh duoc: ' num2str(F_result)]);

function [Rxx, lags]= MyXcorr(X)
x=X';
Lx=length(x);
xCopy1 = zeros(3*Lx-2,1);
for i = Lx:2*Lx-1
    xCopy1(i,1)=x(i-Lx+1,1);
end
Rxx = zeros(2*Lx-1,1);
lags=zeros(2*Lx-1,1);
for i = -(Lx-1):Lx-1
    lags(i+Lx)=i;
    xCopy2 = circshift(xCopy1, i);
    for j = 1 : 3*Lx-2
        Rxx(i+Lx,1) = Rxx(i+Lx,1)+ xCopy1(j,1)*xCopy2(j,1);
    end
end
lags=lags';
Rxx = Rxx';
end



    

