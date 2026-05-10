function plot_uncertainty_ellipses(~, xTrue, zMeas, xHat, PHist, resultsDir, cfg)
%PLOT_UNCERTAINTY_ELLIPSES Draw selected 2D confidence ellipses.

fig = figure("Color", "w", "Name", "Uncertainty Ellipses");
plot(xTrue(1, :), xTrue(2, :), "k-", "LineWidth", 1.7); hold on;
plot(zMeas(1, :), zMeas(2, :), ".", "Color", [0.8 0.8 0.8], "MarkerSize", 6);
plot(xHat(1, :), xHat(2, :), "b-", "LineWidth", 1.3);

N = size(xHat, 2);
step = max(1, floor(N / 15));

for k = 1:step:N
    Pxy = PHist(1:2, 1:2, k);
    mu = xHat(1:2, k);
    draw_cov_ellipse(mu, Pxy, 2.4477, [0.15 0.45 0.95]);
end

xlabel("x [m]");
ylabel("y [m]");
title(sprintf("KF Trajectory with ~95%% Position Ellipses (q=[%.2f, %.2f])", cfg.qAccel(1), cfg.qAccel(2)));
legend("True", "Measurements", "KF", "Location", "best");
axis equal;
grid on;

saveas(fig, fullfile(resultsDir, "uncertainty_ellipses.png"));
end

function draw_cov_ellipse(mu, P, nSigma, colorSpec)
%DRAW_COV_ELLIPSE Draw 2D covariance ellipse from mean and covariance.

[V, D] = eig(P);
theta = linspace(0, 2*pi, 100);
unitCircle = [cos(theta); sin(theta)];
shape = V * sqrt(max(D, 0)) * unitCircle;
ellipse = mu + nSigma * shape;
plot(ellipse(1, :), ellipse(2, :), "-", "Color", colorSpec, "LineWidth", 0.9);
end
