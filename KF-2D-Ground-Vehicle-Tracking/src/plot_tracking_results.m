function plot_tracking_results(t, xTrue, zMeas, xHat, resultsDir)
%PLOT_TRACKING_RESULTS Plot true path, noisy measurements, and KF estimate.

fig = figure("Color", "w", "Name", "Tracking Overview");
plot(xTrue(1, :), xTrue(2, :), "k-", "LineWidth", 2); hold on;
plot(zMeas(1, :), zMeas(2, :), ".", "Color", [0.65 0.65 0.65], "MarkerSize", 8);
plot(xHat(1, :), xHat(2, :), "b-", "LineWidth", 1.5);

xlabel("x [m]");
ylabel("y [m]");
title("2D Ground Vehicle Tracking");
legend("True trajectory", "Noisy measurements", "KF estimate", "Location", "best");
grid on;
axis equal;

saveas(fig, fullfile(resultsDir, "tracking_overview.png"));

fig2 = figure("Color", "w", "Name", "Position Time Series");
subplot(2, 1, 1);
plot(t, xTrue(1, :), "k-", "LineWidth", 1.7); hold on;
plot(t, zMeas(1, :), ".", "Color", [0.65 0.65 0.65], "MarkerSize", 7);
plot(t, xHat(1, :), "b-", "LineWidth", 1.3);
ylabel("x [m]");
grid on;
legend("True", "Measured", "KF", "Location", "best");

subplot(2, 1, 2);
plot(t, xTrue(2, :), "k-", "LineWidth", 1.7); hold on;
plot(t, zMeas(2, :), ".", "Color", [0.65 0.65 0.65], "MarkerSize", 7);
plot(t, xHat(2, :), "b-", "LineWidth", 1.3);
xlabel("Time [s]");
ylabel("y [m]");
grid on;

saveas(fig2, fullfile(resultsDir, "position_timeseries.png"));
end
