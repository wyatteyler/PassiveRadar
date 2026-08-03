%% phase 1 main.m

clear;
clc;
close all;

addpath("io");
addpath("dsp");
addpath("plotting");

sampleRate = 1e6;

filename = "captures/test_capture2.sc16";

iq = readBladeRF(filename);

[frequency, magnitudeDB] = computeSpectrum(iq, sampleRate);

plotSpectrum(frequency, magnitudeDB);
