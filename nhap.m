%% cach 2
clear all;
close all;
clc;
filename = 'AssigmentD20.wav';

% Read the audio file
[audio, Fs] = audioread(filename);

% Convert the audio data to a column vector of 16-bit integers
audio_int = int16(round(audio*32767));

% Reshape the audio data into a row vector
audio_int = reshape(audio_int.', 1, []);

% Convert the audio data to binary data
binary = dec2bin(typecast(audio_int, 'uint16'), 16);

% Write the binary data to a file
fid = fopen('cach2.bin', 'w');
fwrite(fid, binary.', 'char');
fclose(fid);

%%
% ??c tín hi?u âm thanh t? file
[audioData, fs] = audioread('AssigmentD20.wav');

% Chuy?n ??i tín hi?u âm thanh thành dãy nh? phân
binaryData = int16(audioData * 32767);

% Write the binary to a file
fid = fopen('binary_Data.bin', 'w');
fwrite(fid, binaryData, 'int16');
fclose(fid);

% ??c dãy nh? phân t? file
fileID = fopen('binary_Data.bin','r');
binaryData2 = fread(fileID, 'int16');
fclose(fileID);

% Chuy?n ??i dãy nh? phân thành tín hi?u âm thanh
audioData2 = double(binaryData2) / 32767;

% L?u tín hi?u âm thanh vào file WAV
audiowrite('output.wav', audioData, fs, 'BitsPerSample', 16);

%%
% Mô ph?ng h? th?ng truy?n d?n s? t?i t?c ?? d? li?u 8 Mb/s. Ngu?n tin
% c?a h? th?ng ???c l?y t? file nh?c th?c hi?n trong nhi?m v? 1, trong tr??ng h?p không
% th?c hi?n l?y ngu?n tin t? nhi?m v? 1 ???c hãy thay th? b?ng m?t chu?i tín hi?u nh?
% phân ng?u nhiên t??ng ???ng. S? d?ng ?i?u ch? 2-DPSK cho h? th?ng truy?n d?n s?.
% S? d?ng mô hình mô ph?ng t??ng ???ng b?ng g?c, tín hi?u phát có th? ???c bi?u di?n nh? sau:
% s(t) = ? dk * p(t-kTsym) * e^(j*theta0) 
% trong ?ó 
    % dk là các kí hi?u (symbol) ph?c ???c xác ??nh t? chu?i b?n tin ??u vào và k? thu?t ?i?u ch?; 
    % Tsym là chu k? c?a symbol; 
    % theta0 là pha c?a tín hi?u phát;
    % p(t) xác ??nh d?ng xung ???c phát, v?i:
    % p(t) = sqrt(2*Es/Tsym) * (1-cos(2*pi*t/Tsym)) 
    % v?i Es là n?ng l??ng m?i symbol

% Ngu?n tin l?y t? file binaryString.txt
% ??c d? li?u t? file binaryString.txt
fid = fopen('binaryString.txt', 'r');
binaryString = fread(fid, '*char')';
fclose(fid);

% Chuy?n ??i chu?i d? li?u thành chu?i tín hi?u nh? phân
binarySignal = reshape(dec2bin(binaryString, 8).'-'0', 1, []);

% Th?c hi?n ?i?u ch? 2-DPSK cho chu?i tín hi?u nh? phân
modulatedSignal = dpskmod(binarySignal, 2, pi);

N = length(binaryString);  % S? bit c?a ngu?n tin

R = 8e6;            % T?c ?? d? li?u 8 Mb/s
Tsym = 1/R;         % Chu k? c?a symbol
fs = 16*R;          % T?n s? l?y m?u
Ts = 1/fs;          % Chu k? l?y m?u
SNR_db = 10;        % SNR = 10 dB
Es = 1;             % N?ng l??ng m?i symbol
theta0 = 0;         % Pha c?a tín hi?u phát
t = linspace(0, length(binaryString)*Tsym, length(modulatedSignal));
p = sqrt(2*Es/Tsym) * (1-cos(2*pi*t/Tsym)); % Xác ??nh d?ng xung ???c phát
transmittedSignal = zeros(1, length(t));
for i = 1:length(modulatedSignal)
    dk = modulatedSignal(i);
    transmittedSignal = transmittedSignal + dk*p.*exp(1j*theta0);
end

% T?o nhi?u Gauss
NO = Es / (10^(SNR_db/10));
noise = sqrt(N0/2) * (randn(size(transmittedSignal)) + 1i*randn(size(transmittedSignal)));

% Tín hi?u nh?n ???c
receivedSignal = transmittedSignal + noise;

demodulatedSignal = zeros(size(modulatedSignal));
for k = 1:length(modulatedSignal)
    x = receivedSignal((k-1)*length(p)+1:k*length(p));
    y = x .* conj(p);
    demodulatedSignal(k) = angle(sum(y));
end

demodulBinSignal = dpskdemod(demodulatedSignal, 2, pi);
SlashBitErrors = sum(xor(binaryString, demodulBinSignal));
BER = sum(xor(binaryString, demodulBinSignal))/length(binaryString);
disp("SlashBitErrors = " + SlashBitErrors);
disp("BER = " + BER);