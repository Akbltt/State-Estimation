# Animation Pipeline

## Approach

The tracking animation is implemented in `src/animate_tracking.m` using standard MATLAB graphics updates:

- `animatedline` for progressive trajectory history
- handle updates (`set`) for current true/measurement/KF points
- `drawnow limitrate` for efficient rendering

This keeps the animation logic separate from Kalman core estimation logic.

## Covariance Ellipse Interpretation

When enabled, an uncertainty ellipse is drawn around the current KF estimated position using the 2x2 position covariance block `P(1:2,1:2)`.

- Ellipse center: current estimate `[x_hat, y_hat]`
- Ellipse shape/orientation: eigenvectors/eigenvalues of position covariance
- Ellipse scale: configurable `nSigma` (default `2.4477`, approximately 95% confidence in 2D Gaussian sense)

The ellipse is a probabilistic confidence contour, not a deterministic error bound.

## Export Pipeline

GIF export is handled during animation playback:

1. Render current frame with `getframe`
2. Convert frame to indexed image with `rgb2ind`
3. Write first frame with looping enabled (`imwrite`)
4. Append subsequent frames in GIF write mode

Export path is configured by `cfg.animation.gifFileName` and saved under `results/`.

## Configuration Knobs

Main controls in `src/default_config.m`:

- `cfg.enableAnimation`
- `cfg.animation.frameSkip`
- `cfg.animation.realTimePlayback`
- `cfg.animation.playbackSpeed`
- `cfg.animation.exportGif`
- `cfg.animation.gifDelay`
- `cfg.animation.showCovarianceEllipse`
- `cfg.animation.ellipseNSigma`
