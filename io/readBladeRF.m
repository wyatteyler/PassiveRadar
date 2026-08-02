function iq = readBladeRF(filename)
%READBLADERF Read a bladeRF SC16 Q11 binary capture file
%
%   iq = readBladeRF(filename)
%
%   Input:
%       filename - path to the bladeRF binary capture file
%
%   Output:
%       iq - complex column vector or normalized IQ samples


    % open the file for binary reading in little endian format.
    fileID = fopen(filename, "rb", "ieee-le");

    % fopen returns -1 if MATLAB could not open the file.
    if fileID == -1
        error("readBladeRF:FileOpenFailed", ...
              "Could not open the file: %s", filename);
    end

    % automatically close the file when this function finishes, 
    % even if an error occurs later
    cleanupObject = onCleanup(@() fclose(fileID));

    % read every signed 16 bit value and convert it to double
    %
    % the file is arranged as:
    % I0, Q0, I1, Q1, I2, Q2, ...
    raw = fread(fileID, Inf, "int16=>double");

    % each complex sample must contain one I value and one Q value
    if mod(numel(raw), 2) ~= 0
        error("readBladeRF:IncompleteIQPair", ...
              "The file contains an odd number of int16 values.");
    end

    % extract alternating values
    iSamples = raw(1:2:end);
    qSamples = raw(2:2:end);

    % reconstruct the complex IQ samples
    %
    % SC16 Q11 uses a scale factor of 2048
    iq = complex(iSamples, qSamples) / 2048;
end