function plot_covariance_evolution(t, PHist, resultsDir)
%PLOT_COVARIANCE_EVOLUTION Plot diagonal covariance terms over time.

Pxx = squeeze(PHist(1, 1, :));
Pyy = squeeze(PHist(2, 2, :));
Pvxvx = squeeze(PHist(3, 3, :));
Pvyvy = squeeze(PHist(4, 4, :));

fig = figure("Color", "w", "Name", "Covariance Evolution");
subplot(2, 1, 1);
plot(t, Pxx, "b-", "LineWidth", 1.4); hold on;
plot(t, Pyy, "r-", "LineWidth", 1.4);
ylabel("Position variance [m^2]");
legend("P_{xx}", "P_{yy}", "Location", "best");
grid on;

subplot(2, 1, 2);
plot(t, Pvxvx, "b-", "LineWidth", 1.4); hold on;
plot(t, Pvyvy, "r-", "LineWidth", 1.4);
xlabel("Time [s]");
ylabel("Velocity variance [(m/s)^2]");
legend("P_{v_xv_x}", "P_{v_yv_y}", "Location", "best");
grid on;

sgtitle("KF Covariance Evolution");
saveas(fig, fullfile(resultsDir, "covariance_evolution.png"));
end
