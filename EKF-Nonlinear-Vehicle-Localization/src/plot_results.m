function plot_results(cfg, out)
%PLOT_RESULTS Generates core engineering visualization set.

t = out.time;

%% Trajectory overview.
fig1 = figure('Color', 'w', 'Name', 'Trajectory Overview');
plot(out.xTrue(1, :), out.xTrue(2, :), 'k-', 'LineWidth', 1.8); hold on;
scatter(out.zMeas(1, 1:5:end), out.zMeas(2, 1:5:end), 9, [0.75 0.75 0.75], 'filled');
plot(out.xEst(1, :), out.xEst(2, :), '-', 'Color', [0.1 0.42 0.82], 'LineWidth', 1.6);

idxEllipse = 1:30:numel(t);
for i = idxEllipse
    plot_covariance_ellipse(out.xEst(1:2, i), out.P(1:2, 1:2, i), 2, [0.2 0.55 0.2]);
end

xlabel('x [m]');
ylabel('y [m]');
axis equal;
grid on;
legend('True trajectory', 'Noisy GPS (subsampled)', 'EKF estimate', '2\sigma covariance', ...
    'Location', 'best');
title('Ground Vehicle Localization with EKF');
exportgraphics(fig1, fullfile(cfg.resultsDir, 'trajectory_overview.png'), 'Resolution', 180);

%% State error plots.
fig2 = figure('Color', 'w', 'Name', 'State Error');
tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
plot(t, out.posError, 'LineWidth', 1.3);
ylabel('Pos error [m]');
grid on;

nexttile;
plot(t, rad2deg(out.headingError), 'LineWidth', 1.3);
ylabel('Heading err [deg]');
grid on;

nexttile;
plot(t, out.velocityError, 'LineWidth', 1.3);
ylabel('Vel err [m/s]');
xlabel('Time [s]');
grid on;

exportgraphics(fig2, fullfile(cfg.resultsDir, 'state_error.png'), 'Resolution', 180);

%% Covariance evolution.
fig3 = figure('Color', 'w', 'Name', 'Covariance Evolution');
stdX = squeeze(sqrt(out.P(1, 1, :)));
stdY = squeeze(sqrt(out.P(2, 2, :)));
stdPsi = rad2deg(squeeze(sqrt(out.P(3, 3, :))));
stdV = squeeze(sqrt(out.P(4, 4, :)));

plot(t, stdX, 'LineWidth', 1.2); hold on;
plot(t, stdY, 'LineWidth', 1.2);
plot(t, stdPsi, 'LineWidth', 1.2);
plot(t, stdV, 'LineWidth', 1.2);
grid on;
xlabel('Time [s]');
ylabel('1\sigma');
legend('\sigma_x [m]', '\sigma_y [m]', '\sigma_\psi [deg]', '\sigma_v [m/s]', ...
    'Location', 'best');
title('Covariance Evolution');
exportgraphics(fig3, fullfile(cfg.resultsDir, 'covariance_evolution.png'), 'Resolution', 180);

%% Heading evolution.
fig4 = figure('Color', 'w', 'Name', 'Heading Evolution');
plot(t, rad2deg(out.xTrue(3, :)), 'k-', 'LineWidth', 1.6); hold on;
plot(t, rad2deg(out.xEst(3, :)), '-', 'Color', [0.1 0.42 0.82], 'LineWidth', 1.4);
grid on;
xlabel('Time [s]');
ylabel('Heading [deg]');
legend('True heading', 'EKF heading', 'Location', 'best');
title('Heading Tracking');
exportgraphics(fig4, fullfile(cfg.resultsDir, 'heading_evolution.png'), 'Resolution', 180);
end
