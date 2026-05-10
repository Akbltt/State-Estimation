# System Model

## Objective

Estimate 2D ground vehicle position and velocity from noisy position-only measurements.

## State Definition

State vector:

- `x_k = [x, y, vx, vy]^T`

## Motion Model (Filter)

Constant velocity (CV) discrete-time model:

- `x_{k+1} = F x_k + w_k`

with:

- `F = [1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1]`
- `w_k ~ N(0, Q)`

Process noise is modeled as equivalent white acceleration input mapped through `G`.

## Measurement Model

Position-only measurement:

- `z_k = H x_k + v_k`

with:

- `H = [1 0 0 0; 0 1 0 0]`
- `v_k ~ N(0, R)`

## Truth Simulation

The truth generator includes piecewise acceleration and turn-rate segments. This intentionally creates periods where the CV filter model is imperfect.

Practical purpose:

- test estimator behavior under model mismatch
- evaluate sensitivity to `Q` and `R`

## Kalman Filter Steps Implemented

At each time step:

1. Predict state: `x^-_k = F x^+_{k-1}`
2. Predict covariance: `P^-_k = F P^+_{k-1} F^T + Q`
3. Compute gain: `K_k = P^-_k H^T (H P^-_k H^T + R)^{-1}`
4. Update state: `x^+_k = x^-_k + K_k (z_k - H x^-_k)`
5. Update covariance (Joseph form for numerical robustness)

## Why This Structure

- simple state and measurement model
- direct mapping to EKF/UKF architecture later
- clear separation between simulation, filter core, and analysis
