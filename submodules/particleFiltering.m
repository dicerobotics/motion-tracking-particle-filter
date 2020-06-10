function SOut = particleFiltering(imDiffMor, winParWeight, vidRes, nPar, TProp, XStdPos, XStdVel)
persistent S;
if isempty(S)
    S = create_particles(vidRes, nPar);
end

% Forecasting
W = calcWeightsParticles(S, imDiffMor, winParWeight);%imDiffMor);	% Calculate Weights (Perception Model)
[SUpdated, WUpdated] = resampleParticles(S, W);                     % Resample particles based upon their weights
SOut = propParticles(TProp, XStdPos, XStdVel, SUpdated, WUpdated);	% Propagate Particles (Motion Model)
S = SOut;
end