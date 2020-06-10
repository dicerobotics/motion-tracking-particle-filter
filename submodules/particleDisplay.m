function [imParticle] = particleDisplay(X, Y_k)

figure(4)
% image(Y_k)
imshow(Y_k)
title('+++ Showing Particles +++')
hold on
plot(X(2,:), X(1,:), '+r')
hold off
F = getframe;
imParticle = F.cdata;
return %drawnow
end

