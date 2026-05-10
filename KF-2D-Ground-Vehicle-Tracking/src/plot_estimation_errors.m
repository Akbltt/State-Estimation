function plot_estimation_errors(t, xTrue, xHat, PHist, resultsDir)
%PLOT_ESTIMATION_ERRORS Plot errors with +/-3 sigma envelopes.

err = xHat - xTrue;

sigmaX = squeeze(sqrt(PHist(1, 1, :)))';
sigmaY = squeeze(sqrt(PHist(2, 2, :)))';
sigmaVx = squeeze(sqrt(PHist(3, 3, :)))';
sigmaVy = squeeze(sqrt(PHist(4, 4, :)))';

fig = figure("Color", "w", "Name", "Estimation Errors");

subplot(2, 2, 1);
plot(t, err(1, :), "b-", "LineWidth", 1.2); hold on;
plot(t, 3 * sigmaX, "r--", t, -3 * sigmaX, "r--", "LineWidth", 1);
ylabel("x error [m]");
grid on;

subplot(2, 2, 2);
plot(t, err(2, :), "b-", "LineWidth", 1.2); hold on;
plot(t, 3 * sigmaY, "r--", t, -3 * sigmaY, "r--", "LineWidth", 1);
ylabel("y error [m]");
grid on;

subplot(2, 2, 3);
plot(t, err(3, :), "b-", "LineWidth", 1.2); hold on;
plot(t, 3 * sigmaVx, "r--", t, -3 * sigmaVx, "r--", "LineWidth", 1);
xlabel("Time [s]");
ylabel("v_x error [m/s]");
grid on;

subplot(2, 2, 4);
plot(t, err(4, :), "b-", "LineWidth", 1.2); hold on;
plot(t, 3 * sigmaVy, "r--", t, -3 * sigmaVy, "r--", "LineWidth", 1);
xlabel("Time [s]");
ylabel("v_y error [m/s]");
grid on;

sgtitle("State Estimation Errors with 3-Sigma Bounds");
saveas(fig, fullfile(resultsDir, "estimation_errors.png"));

fig2 = figure("Color", "w", "Name", "Position Error Norm");
posErrNorm = vecnorm(err(1:2, :), 2, 1);
plot(t, posErrNorm, "k-", "LineWidth", 1.5);
xlabel("Time [s]");
ylabel("||position error|| [m]");
title("Position Error Norm");
grid on;
saveas(fig2, fullfile(resultsDir, "position_error_norm.png"));
end
