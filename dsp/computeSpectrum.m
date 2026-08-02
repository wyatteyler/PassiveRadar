function [frequency, magnitudeDB] = computeSpectrum(iq, sampleRate)
%COMPUTESPECTRUM Compute the centered spectrum of complex IQ samples
%   
%   [frequency, magnitudeDB] = computeSpectrum(iq, sampleRate)
%
%   Inputs:
%       iq - complex IQ sample vector
%       sampleRate - sample rate in Hz
%
%   Outputs:
%       frequency - frequency offsets in Hz
%       magnitudeDB - spectrum magnitude in dB


    % force the iq data into a column vector
    iq = iq(:);

    % remove the average value to reduce the DC spike 
    iq = iq - mean(iq);

    % number of IQ samples
    numSamples = length(iq);

    % create a Hann window with the same number of samples
    window = hann(numSamples);
    
    % apply the window to the data
    iqWindowed = iq .* window;

    % compute the FFT and move 0 Hz to the center
    spectrum = fftshift(fft(iqWindowed));

    % convert the FFT mag to dB
    magnitudeDB = 20 * log10(abs(spectrum) + eps);

    % create the matching frequency offset axis
    frequency = (-floor(numSamples/2) : ceil(numSamples/2)-1).' ...
        * (sampleRate / numSamples);

    end

