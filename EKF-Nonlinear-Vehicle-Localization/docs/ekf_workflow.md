# EKF Workflow

## Prediction Step
At each sample:

1. Propagate state with nonlinear motion model.
2. Compute process Jacobian F = df/dx at current estimate.
3. Propagate covariance:
   P_{k|k-1} = F P_{k-1|k-1} F^T + Q

The Jacobian terms linking heading/speed to position are key to capturing local nonlinear sensitivity.

## Measurement Update
Measurement model is GPS-like position:

- z_k = [x_k, y_k]^T + noise

Update sequence:

1. Compute innovation y_k = z_k - h(x_{k|k-1}).
2. Build innovation covariance S_k = H P_{k|k-1} H^T + R.
3. Compute gain K_k = P_{k|k-1} H^T S_k^{-1}.
4. Correct state x_{k|k} = x_{k|k-1} + K_k y_k.
5. Correct covariance using Joseph form for numerical robustness.

## Engineering Notes
- Heading is wrapped to [-pi, pi] after propagation and update.
- Joseph covariance update reduces numerical asymmetry and negative-variance artifacts.
- The implementation is modular to support swapping H/h for range-bearing or multi-sensor cases.
