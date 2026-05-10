function run_tuning_study(baseCfg)
%RUN_TUNING_STUDY Compare process/measurement tuning and model mismatch.

studyDir = fullfile(baseCfg.resultsDir, "tuning_study");
if ~exist(studyDir, "dir")
    mkdir(studyDir);
end

scenarios = {
    struct("name", "baseline", "q", [0.8 0.8], "rStd", 3.0, "maneuvers", true)
    struct("name", "low_process_noise", "q", [0.08 0.08], "rStd", 3.0, "maneuvers", true)
    struct("name", "high_process_noise", "q", [4.0 4.0], "rStd", 3.0, "maneuvers", true)
    struct("name", "low_measurement_noise", "q", [0.8 0.8], "rStd", 1.2, "maneuvers", true)
    struct("name", "high_measurement_noise", "q", [0.8 0.8], "rStd", 8.0, "maneuvers", true)
    struct("name", "no_model_mismatch", "q", [0.8 0.8], "rStd", 3.0, "maneuvers", false)
    };

numScen = numel(scenarios);
rmsePos = zeros(1, numScen);
rmseVel = zeros(1, numScen);
scenarioNames = strings(1, numScen);

fig = figure("Color", "w", "Name", "Tuning Comparison");
tiledlayout(2, 1);

nexttile;
hold on;
grid on;
ylabel("||position error|| [m]");
title("Tuning and Model Mismatch Comparison");

nexttile;
hold on;
grid on;
ylabel("Speed error norm [m/s]");
xlabel("Time [s]");

for i = 1:numScen
    cfg = baseCfg;
    cfg.qAccel = scenarios{i}.q;
    cfg.R_meas = diag([scenarios{i}.rStd^2, scenarios{i}.rStd^2]);
    cfg.truthModel.enableManeuvers = scenarios{i}.maneuvers;

    rng(baseCfg.randomSeed);
    [t, xTrue, ~] = simulate_ground_truth(cfg);
    zMeas = generate_measurements(xTrue, cfg.R_meas);
    kf = run_linear_kf(zMeas, cfg);

    m = compute_metrics(xTrue, kf.xHat);
    rmsePos(i) = m.positionRMSE;
    rmseVel(i) = m.velocityRMSE;

    posErrNorm = vecnorm(kf.xHat(1:2, :) - xTrue(1:2, :), 2, 1);
    velErrNorm = vecnorm(kf.xHat(3:4, :) - xTrue(3:4, :), 2, 1);

    nexttile(1);
    plot(t, posErrNorm, "LineWidth", 1.1, "DisplayName", scenarios{i}.name);

    nexttile(2);
    plot(t, velErrNorm, "LineWidth", 1.1, "DisplayName", scenarios{i}.name);

    scenarioNames(i) = scenarios{i}.name;
end

nexttile(1);
legend("Location", "eastoutside");

nexttile(2);
legend("Location", "eastoutside");

saveas(fig, fullfile(studyDir, "tuning_error_comparison.png"));

fig2 = figure("Color", "w", "Name", "RMSE Summary");
categories = string(cellfun(@(s) s.name, scenarios, "UniformOutput", false));
bar(categorical(categories), [rmsePos' rmseVel']);
legend("Position RMSE", "Velocity RMSE", "Location", "best");
ylabel("RMSE");
title("Scenario RMSE Comparison");
grid on;
xtickangle(25);
saveas(fig2, fullfile(studyDir, "tuning_rmse_summary.png"));

summaryPath = fullfile(studyDir, "tuning_metrics.csv");
scenarioNamesCol = cellstr(scenarioNames(:));
summaryTable = table(scenarioNamesCol, rmsePos(:), rmseVel(:), ...
    'VariableNames', {'scenario', 'position_rmse', 'velocity_rmse'});
writetable(summaryTable, summaryPath);

disp("--- Tuning Study Summary (RMSE) ---");
for i = 1:numScen
    fprintf("%-24s | pos RMSE = %.3f m | vel RMSE = %.3f m/s\n", ...
        scenarios{i}.name, rmsePos(i), rmseVel(i));
end
end
