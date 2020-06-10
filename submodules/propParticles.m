function XOut = propParticles(F_update, Xstd_pos, Xstd_vec, XIn, W)
N = size(XIn, 2);
mW = max(W) + 0.000001; %Addition made to avoid division by zero
WScaled = W/(mW);
WScaled = WScaled + 1-0.5;
XOut = F_update * XIn;

% XOut(1:2,:) = XOut(1:2,:) + Xstd_pos * randn(2, N);
% XOut(3:4,:) = XOut(3:4,:) + Xstd_vec * randn(2, N);
XOut(1:2,:) = XOut(1:2,:) + Xstd_pos * (randn(2, N)./ [WScaled;WScaled]);
XOut(3:4,:) = XOut(3:4,:) + Xstd_vec * (randn(2, N)./[WScaled;WScaled]);

end
