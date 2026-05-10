function main()
%MAIN Entry point for KF-2D ground vehicle tracking simulation.

cfg = default_config();
rng(cfg.randomSeed);

[t, xTrue, uTrue] = simulate_ground_truth(cfg);
zMeas = generate_measurements(xTrue, cfg.R_meas);

kfResult = run_linear_kf(zMeas, cfg);

if ~exist(cfg.resultsDir, "dir")
    mkdir(cfg.resultsDir);
end

plot_tracking_results(t, xTrue, zMeas, kfResult.xHat, cfg.resultsDir);
plot_estimation_errors(t, xTrue, kfResult.xHat, kfResult.PHist, cfg.resultsDir);
plot_covariance_evolution(t, kfResult.PHist, cfg.resultsDir);
plot_uncertainty_ellipses(t, xTrue, zMeas, kfResult.xHat, kfResult.PHist, cfg.resultsDir, cfg);

if cfg.enableAnimation
    animate_tracking(t, xTrue, zMeas, kfResult.xHat, cfg.resultsDir, cfg);
end

metrics = compute_metrics(xTrue, kfResult.xHat);
disp("--- Baseline Performance ---");
disp(metrics);

if cfg.runTuningStudy
    run_tuning_study(cfg);
end

% Keep variables visible for quick inspection when called as script.
assignin("base", "t", t);
assignin("base", "xTrue", xTrue);
assignin("base", "uTrue", uTrue);
assignin("base", "zMeas", zMeas);
assignin("base", "kfResult", kfResult);
assignin("base", "metrics", metrics);
end
