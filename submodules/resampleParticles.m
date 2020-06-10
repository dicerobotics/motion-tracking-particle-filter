function [SOut, WOut] = resampleParticles(SIn, WIn)

% Calculating Cumulative Distribution
if sum(WIn,2)==0
    SOut = SIn;
    WOut = WIn;
    return;
else
Q = WIn / sum(WIn, 2);
wIncNor = cumsum(Q, 2);

% Generating uniformly distributed Random Numbers
N = size(SIn, 2);
rUnif = rand(1, N);

% Resampling

[~, binNum] = histc(rUnif, wIncNor);
SOut = SIn(:, binNum + 1);
WOut = WIn(binNum + 1);
end
end
