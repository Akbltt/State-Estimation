clear; clc; close all;

% Add source folder to MATLAB path.
projectRoot = fileparts(mfilename('fullpath'));
addpath(fullfile(projectRoot, 'src'));

cfg = default_config(projectRoot);

fprintf('Running baseline EKF localization simulation...\n');
results = run_single_simulation(cfg);
plot_results(cfg, results);
animate_tracking(cfg, results);

fprintf('Running sensitivity study (process noise, measurement noise, model mismatch)...\n');
study = run_sensitivity_study(cfg);
disp(study.summaryTable);

fprintf('Project run complete. Outputs saved under results/.\n');
