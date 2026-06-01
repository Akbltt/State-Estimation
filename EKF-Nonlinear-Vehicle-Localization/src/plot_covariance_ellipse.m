function plot_covariance_ellipse(mu, Pxy, nSigma, colorSpec)
%PLOT_COVARIANCE_ELLIPSE Draws covariance ellipse for 2D position uncertainty.

if nargin < 3
    nSigma = 2;
end
if nargin < 4
    colorSpec = [0.1, 0.4, 0.8];
end

% Symmetrize to avoid numerical issues.
Pxy = 0.5 * (Pxy + Pxy');

[V, D] = eig(Pxy);
lambda = max(diag(D), 1e-12);

theta = linspace(0, 2 * pi, 60);
unitCircle = [cos(theta); sin(theta)];
ellipse = V * diag(sqrt(lambda)) * unitCircle;
ellipse = nSigma * ellipse + mu(:);

plot(ellipse(1, :), ellipse(2, :), '-', 'Color', colorSpec, 'LineWidth', 1.0);
end
