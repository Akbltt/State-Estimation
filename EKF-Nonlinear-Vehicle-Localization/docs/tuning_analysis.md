# Tuning Analysis

## What Is Evaluated
The sensitivity study compares EKF behavior across:

- low process noise Q
- high process noise Q
- low measurement noise R
- high measurement noise R
- severe turn-rate mismatch

Metrics reported:

- position RMSE [m]
- heading RMSE [deg]
- velocity RMSE [m/s]

## Typical Observations
- Low Q often yields overconfident prediction and lag during aggressive maneuvers.
- High Q tends to improve maneuver tracking but can increase estimate jitter.
- Low R over-trusts noisy GPS and injects measurement noise into state estimates.
- High R under-trusts measurements, relying more on model propagation and accumulating drift.
- Model mismatch is most visible in high-curvature segments where linearization and incorrect turn assumptions compound.

## Practical Tuning Strategy
1. Tune R first using sensor characterization data.
2. Increase Q components tied to uncertain model states (heading, speed) until innovation behavior is stable.
3. Validate on turn-heavy and speed-transient scenarios, not only mild trajectories.
4. Recheck covariance consistency and residual trends when changing dt or motion assumptions.
