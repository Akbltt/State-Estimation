function study = run_sensitivity_study(cfg)
%RUN_SENSITIVITY_STUDY Compares EKF performance under tuning changes.

cases = {
    struct('name', 'Baseline', 'QScale', 1.0, 'RScale', 1.0, 'turnScale', cfg.modelMismatch.turnRateScale),
    struct('name', 'Low Q (overconfident model)', 'QScale', 0.25, 'RScale', 1.0, 'turnScale', cfg.modelMismatch.turnRateScale),
    struct('name', 'High Q (model uncertainty)', 'QScale', 4.0, 'RScale', 1.0, 'turnScale', cfg.modelMismatch.turnRateScale),
    struct('name', 'Low R (overtrust GPS)', 'QScale', 1.0, 'RScale', 0.4, 'turnScale', cfg.modelMismatch.turnRateScale),
    struct('name', 'High R (undertrust GPS)', 'QScale', 1.0, 'RScale', 2.5, 'turnScale', cfg.modelMismatch.turnRateScale),
    struct('name', 'Severe turn mismatch', 'QScale', 1.0, 'RScale', 1.0, 'turnScale', 0.7)
};

numCases = numel(cases);
rmsePos = zeros(numCases, 1);
rmseHeadingDeg = zeros(numCases, 1);
rmseVel = zeros(numCases, 1);

for i = 1:numCases
    cfgCase = cfg;
    cfgCase.QEst = cfg.QEst * cases{i}.QScale;
    cfgCase.R = cfg.R * cases{i}.RScale;
    cfgCase.modelMismatch.turnRateScale = cases{i}.turnScale;

    outCase = run_single_simulation(cfgCase);
    rmsePos(i) = outCase.rmsePos;
    rmseHeadingDeg(i) = outCase.rmseHeadingDeg;
    rmseVel(i) = outCase.rmseVelocity;
end

study.summaryTable = table( ...
    reshape(string(cellfun(@(c) c.name, cases, 'UniformOutput', false)), [], 1), ...
    rmsePos, rmseHeadingDeg, rmseVel, ...
    'VariableNames', {'Case', 'RMSE_Position_m', 'RMSE_Heading_deg', 'RMSE_Velocity_mps'});

figure('Color', 'w', 'Name', 'Sensitivity Study');
tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
bar(rmsePos);
ylabel('Position RMSE [m]');
grid on;

nexttile;
bar(rmseHeadingDeg);
ylabel('Heading RMSE [deg]');
grid on;

nexttile;
bar(rmseVel);
ylabel('Velocity RMSE [m/s]');
grid on;
xticks(1:numCases);
xticklabels(cellfun(@(c) c.name, cases, 'UniformOutput', false));
xtickangle(20);

exportgraphics(gcf, fullfile(cfg.resultsDir, 'sensitivity_study.png'), 'Resolution', 180);
end
