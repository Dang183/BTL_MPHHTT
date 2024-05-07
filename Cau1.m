
clear all;
close all;
clc;

filename = 'AssigmentD20.wav';
[y,Fs] = audioread(filename);
%sound(y,Fs);

% Convert the audio data to a column vector of 16-bit integers
audio_int = int8(round(y*(2^8-1)));

% Reshape the audio data into a row vector
audio_int = reshape(audio_int, 1, []);

% Convert the audio data to binary data
binary = dec2bin(typecast(audio_int, 'uint8'), 8);

% Write the binary data to a file
fid = fopen('binary_data.bin', 'w');
fwrite(fid, binary.','char');
fclose(fid);

% ??c dãy nh? phân t? file
fileID = fopen('binary_data.bin','r');
binary2 = fread(fileID);
fclose(fileID);

% Chuy?n ??i dãy nh? phân thành tín hi?u âm thanh
binary2 = binary2-48;
binary2 = reshape(binary2, 8, [])';
audioData2 = bi2de(binary2, 'left-msb');
audioData2 = typecast(uint8(audioData2), 'int8');
audioData2 = reshape(audioData2, [],2);
audioData2 = double(audioData2) / (2^8-1);
% L?u tín hi?u âm thanh vào file WAV
audiowrite('output.wav', audioData2, Fs);

info = audioinfo(filename)