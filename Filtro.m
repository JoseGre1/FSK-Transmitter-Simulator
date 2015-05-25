function Hd = FC
%FC Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.1 and the Signal Processing Toolbox 6.19.
% Generated on: 19-May-2015 18:07:07

% Butterworth Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
Fs = 24000;  % Sampling Frequency

Fstop1 = 500;         % First Stopband Frequency
Fpass1 = 2000;        % First Passband Frequency
Fpass2 = 10000;       % Second Passband Frequency
Fstop2 = 11500;       % Second Stopband Frequency
Astop1 = 10;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 10;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);

% [EOF]