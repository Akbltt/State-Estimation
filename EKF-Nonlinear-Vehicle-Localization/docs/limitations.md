# Limitations

## EKF Approximation Limits
- EKF uses first-order linearization; accuracy degrades with strong nonlinearity and large uncertainty.
- During aggressive turns, local linearization may under-represent true trajectory curvature.

## Model Limits
- Current model is kinematic and does not capture tire slip or actuator dynamics.
- Velocity is constrained to stay positive; reverse motion is not represented.

## Measurement Limits
- GPS-like position-only measurement leaves heading and velocity weakly observable during low excitation.
- No explicit handling of outliers, dropouts, or delayed measurements.

## Numerical and Practical Limits
- Fixed-step discretization can be limiting at very high turn rates.
- No adaptive noise tuning or consistency checks (for example NIS/NEES gating) are implemented.

## Extension Paths
- Replace EKF with UKF under stronger nonlinearity.
- Add range-bearing, IMU, wheel-speed, or heading sensors for improved observability.
- Add innovation gating and fault handling for realistic sensor fusion pipelines.
