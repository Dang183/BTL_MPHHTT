clear all;
close all;
clc;

R = 4e6; % toc do bit = toc do ky hieu = 4Mb/s 
Tsym = 1/R; % chu ky ky hieu 
fs = 32*R;          % T?n s? l?y m?u
Ts = 1/fs;          % Chu k? l?y m?u
%SNR_db = 2;         % SNR = 10 dB
Es = 1;           % N?ng l??ng m?i symbol
phi0 = 0;        % Pha c?a tín hi?u phát
fc = 2*R;

x = randi([0 1],1,5000); % tao tin hieu dau vao

xdc = dpskmod(x,2);  % dieu che 2-DPSK

t = 0:Ts:Tsym;
pt = sqrt(2*Es/Tsym)*(1-cos(2*pi*t/Tsym));
st = [];
tc = [];
for k=1:length(x)
    st1 = xdc(k)*pt*exp(j*phi0);
    st = [st st1];
    tc = [tc t+(k-1)*Tsym];
end

% add awgn 

SNRdB = 10; % dB
SNR = 10^(SNRdB/10);
%varn = var(st)/SNR; % computing variance of noise
%xnoise = addnoise(st,varn);
%plot(tc,real(xnoise));grid;

%ynoise = awgn(st,SNR,'measured');

% 3. Do thi bang goc
plot(tc,st);
xlabel('Time');
ylabel('Amplitude');
title('Signal Waveform');

signal = st.*exp(1i*2*pi*fc*tc);
% 5. Do thi va pho tin hieu sau dieu che 
eyediagram(real(signal), 20);
title('Eye Diagram of Signal');

% 6. Scatterplot
scatterplot(xdc,1,0,'or');
title('Scatterplot of Signal');

% 7. Do thi va pho tin hieu sau khi qua AWGN
figure;
signal_noise = awgn(signal, SNR, 'measured');
subplot(211);
plot(tc, real(signal_noise));
xlabel('Time'); ylabel('Amplitude');
title('Signal Waveform with AWGN');
subplot(212);
% Draw spectrum of signal with awgn
N = length(signal_noise);
xdft = fft(signal_noise);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/N:fs/2;
plot(freq,10*log10(psdx));
grid on;
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Spectrum of Signal with AWGN');

% 8. Eye diagram of signal with AWGN
eyediagram(real(signal_noise), 20);
title('Eye Diagram of Signal with AWGN');

% 9. Scatterplot of signal with AWGN
d_noise = awgn(xdc, 10, 'measured');
h = scatterplot(d_noise,1,0,'x');
%hold on;
%scatterplot(xdc,1,0,'or',h); 
title('bieu do chom sao');

% 10. Xu ly va khoi phuc 
sr1 = signal_noise.*exp(-i*2*pi*fc*tc).*exp(-i*phi0);
sr = raisedcosflt(sr1,R,Ts,2);
%sr = dpskdemod(sr1,2);
figure;
plot(tc, real(sr));
xlabel('Time'); ylabel('Amplitude');
title('Signal Waveform after Raised Cosine Filter');

% 11. Scatterplot of signal after Raised Cosine Filter
scatterplot(sr,1,0,'or');
title('Scatterplot of Signal after Raised Cosine Filter');

% 12. Eye diagram of signal after Raised Cosine Filter
eyediagram(real(sr), 20);
title('Eye Diagram of Signal after Raised Cosine Filter');

