function plotSpectrum(frequency, magnitudeDB)
%PLOTSPECTRUM Plots a frequency spectrum.
%   Detailed explanation goes here
%
%   plotSpectrum(frequnecy, magnitudeDB)
%
%   Input:
%       frequency - frequency offset vector in Hz
%       magnitude - spectrum magnitude in dB 


    % force both frequency and magnitude into column vectors
    frequency = frequency(:);
    magnitudeDB = magnitudeDB(:);

    % make sure frequency and magnitude have equal lengths
    if length(frequency) ~= length(magnitudeDB)
       error("plotSpectrum:LengthMismatch", ...
          "frequency and magnitudeDB must have the same length.");
    end

    % plot the frequency in MHz 
    plot(frequency / 1e6, magnitudeDB);

    grid on;

    xlabel('Frequency (MHz)');
    ylabel('Magnitude (dB)');
    title('Frequency Spectrum');

    end

