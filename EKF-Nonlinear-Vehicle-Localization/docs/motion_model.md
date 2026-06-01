# Motion Model

## State and Inputs
State vector:

- x position [m]
- y position [m]
- heading psi [rad]
- speed v [m/s]

Input vector:

- longitudinal acceleration a [m/s^2]
- yaw rate omega [rad/s]

## Discrete Nonlinear Model
The simulator and EKF predictor use a unicycle-style kinematic model:

- x_{k+1} = x_k + v_k cos(psi_k) dt
- y_{k+1} = y_k + v_k sin(psi_k) dt
- psi_{k+1} = psi_k + omega_k dt
- v_{k+1} = v_k + a_k dt

This model is nonlinear due to trigonometric coupling between heading and translational motion.

## Why This Model
- Captures curved trajectories without requiring full dynamic tire modeling
- Keeps estimation problem focused on nonlinear state propagation and Jacobian linearization
- Suitable baseline for extension toward bicycle dynamics or slip-aware models

## Motion Mismatch Setup
The truth model uses commanded controls directly, while the estimator intentionally applies:

- yaw-rate scaling mismatch
- acceleration bias

This introduces realistic model-plant mismatch to stress EKF behavior during aggressive maneuvers.
