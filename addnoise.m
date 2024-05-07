function yNoise = addnoise(yClean,VarN)
% This function adds Gaussian noise into
% the input signal.
% yClean - the input signal
% VarN - the variance of noise
% yNoise - the noisy signal output
if (isreal(yClean))
yNoise = yClean + sqrt(VarN)*randn(size(yClean));
else
yNoise = yClean + sqrt(VarN/2) ...
*(randn(size(yClean))+j*randn(size(yClean)));
end