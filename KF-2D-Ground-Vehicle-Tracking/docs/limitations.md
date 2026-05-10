# Limitations

## Model Assumptions

The implemented filter assumes:

- linear constant-velocity dynamics
- Gaussian process and measurement noise
- known and stationary covariance matrices (`Q`, `R`)
- direct position measurements with no bias or dropout

These assumptions are useful for a baseline study but not fully representative of production tracking systems.

## Known Gaps in Realism

- No heading, yaw-rate, or vehicle kinematic constraints
- No sensor biases, latency, or asynchronous fusion
- No outlier rejection for bad measurements
- No adaptive covariance tuning
- No missing-data handling

## Effects of Mismatch

When the true motion includes acceleration/turning:

- CV filter can show lag in both position and velocity estimates
- covariance can become optimistic if `Q` is too low
- large innovations can appear during maneuver transitions

## Numerical and Implementation Notes

- Covariance update uses Joseph form to improve numerical robustness
- Current implementation is offline and batch-run for analysis
- Performance is sufficient for simulation-scale studies; real-time deployment needs profiling and system integration

## Roadmap Compatibility

The current modular design is intended to be extended to:

- EKF for nonlinear vehicle and sensor models
- UKF for stronger nonlinearity handling
- Particle filter for non-Gaussian tracking cases

The existing structure (`simulation -> models -> estimator -> analysis`) is preserved to make these upgrades incremental.
