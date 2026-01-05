# @able/dotco

## 0.0.3

### Patch Changes

- [`fa54edd`](https://github.com/mpotter/able/commit/fa54edd2c024beffa0b42d4f0c28198142011131) Thanks [@mpotter](https://github.com/mpotter)! - Switch to ALB health check instead of container health check for more reliable deployments

## 0.0.2

### Patch Changes

- [#16](https://github.com/mpotter/able/pull/16) [`4799d22`](https://github.com/mpotter/able/commit/4799d22a15a8eccd0fa59b9383e8017fd01ad9a5) Thanks [@mpotter](https://github.com/mpotter)! - Improve ECS deployment configuration: add 120s health check grace period for app startup and reduce target group deregistration delay from 300s to 30s for faster deployments.
