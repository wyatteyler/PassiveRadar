%% generate test files to verify proper functionality
%
% will eventually add wideband generation

clear;
clc;

% test signal settings
sampleRate = 1e6;       % 1 million complex samples per second
numSamples = 65536;     % number of complex IQ samples

tone1Frequency = 300e3;    % +300 kHz
tone2Frequency = -300e3;   % -300 kHz

tone1Amplitude = 0.55;
tone2Amplitude = 0.25;
noiseAmplitude = 0.02;

% sample number vector: 0, 1, 2, ..., numSamples - 1
n = (0:numSamples-1).';

% generate two complex sinusoidal signals
tone1 = tone1Amplitude * exp(1j * 2*pi * tone1Frequency * n / sampleRate);

tone2 = tone2Amplitude * exp(1j * 2*pi * tone2Frequency * n / sampleRate);

% make the random noise repeatable every time the script runs
rng(1);

% generate complex noise
noise = noiseAmplitude * (randn(numSamples, 1) + 1j*randn(numSamples, 1));

% combine both tones and the noise
iq = tone1 + tone2 + noise;

% convert normalized floating point IQ into SC16 Q11 integers
iSamples = round(real(iq) * 2048);
qSamples = round(imag(iq) * 2048);

% limit values to the valid bladeRF Q11 range
iSamples = max(-2048, min(2047, iSamples));
qSamples = max(-2048, min(2047, qSamples));

% convert to signed 16 bit integers
iSamples = int16(iSamples);
qSamples = int16(qSamples);

% intertwine the data
% I0, Q0, I1, Q1, I2, Q2, ...
raw = zeros(2*numSamples, 1, "int16");

raw(1:2:end) = iSamples;
raw(2:2:end) = qSamples;

% output filename
filename = "../captures/test_capture2.sc16";

% open the file for binary writing in little endian order
fileID = fopen(filename, "wb", "ieee-le");

if fileID == -1
    error("Could not create file: %s", filename);
end

% write the int16 values
fwrite(fileID, raw, "int16");

fclose(fileID);

fprintf("Created %s\n", filename);
fprintf("Complex samples: %d\n", numSamples);
fprintf("Sample rate: %.0f Hz\n", sampleRate);
fprintf("Expected peaks: %.0f Hz and %.0f Hz\n", ...
    tone1Frequency, tone2Frequency);