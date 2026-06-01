# EKF-Nonlinear-Vehicle-Localization

Engineering-oriented MATLAB project for nonlinear 2D ground-vehicle localization using an Extended Kalman Filter (EKF).

## Problem Definition
A vehicle follows a curved trajectory with changing heading and velocity in a 2D plane. The estimator receives noisy GPS-like position measurements and must recover the full nonlinear state:

- `x` position [m]
- `y` position [m]
- `heading` (yaw) [rad]
- `velocity` [m/s]

## EKF Approach (Concise)
- Nonlinear unicycle-style process model for prediction
- Jacobian-based linearization at each time step
- Covariance propagation through linearized dynamics
- Position measurement update with Kalman gain
- Joseph-form covariance update for numerical robustness

## Key Features
- Modular MATLAB implementation under `src/`
- Baseline run + sensitivity study for:
  - process noise tuning
  - measurement noise tuning
  - model mismatch impact
- Engineering plots:
  - true vs noisy vs EKF trajectories
  - state error over time
  - covariance evolution
  - heading tracking
  - uncertainty ellipses
- Animation export:
  - GIF
  - optional MP4

## Project Structure
- `run_main.m` : single entry point
- `src/` : simulation + EKF modules
- `docs/` : focused technical notes
- `results/` : generated figures, GIF, optional MP4

## Run Instructions
1. Open MATLAB in this project folder.
2. Run:
   ```matlab
   run_main
   ```
3. Inspect generated outputs in `results/`.

## Visualization Examples
The run generates artifacts such as:
- `trajectory_overview.png`
- `state_error.png`
- `covariance_evolution.png`
- `heading_evolution.png`
- `ekf_tracking.gif`
- `sensitivity_study.png`

## Notes
This project is designed as a practical simulation study for state-estimation portfolios and is structured for easy extension toward UKF, particle filters, and multi-sensor fusion.
