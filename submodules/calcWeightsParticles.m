function W = calcWeightsParticles(S, imDiff, windowSize) % Xstd_rgb, Xrgb_trgt, X, Y

Npix_h = size(imDiff, 1);
Npix_w = size(imDiff, 2);
shift = floor(windowSize/2);
N = size(S,2);

L = zeros(1, N);
W = zeros(1, N);
imDiff = permute(imDiff, [3 1 2]);

% A = -log(sqrt(2 * pi) * Xstd_rgb);
% B = - 0.5 / (Xstd_rgb.^2);

S = round(S);

for k = 1:N
    
    m = S(1,k);
    n = S(2,k);
    
    I = (m >= (shift+1) & m <= (Npix_h-shift-1));
    J = (n >= (shift+1) & n <= (Npix_w-shift-1));
    
    if I && J
        
%         C = double(imDiff(:, m, n));
                        
        L(k) =  sum(sum(sum(imDiff(:, (m-shift:m+shift), (n-shift:n+shift)))));
        W(k) = L(k)/(windowSize^2);
    else
        
        W(k) = 0;%-Inf;
    end
end
