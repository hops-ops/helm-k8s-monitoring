### What's changed in v0.1.0

* feat: initial k8s-monitoring helm xrd configuration (by @patrickleet)

* feat: helm chart xrd (by @patrickleet)

* feat(deps): update crossplane-contrib/provider-helm docker tag to v1.0.6 (#1) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* chore(deps): update unbounded-tech/workflow-vnext-tag action to v1.21.0 (#3) (by @renovate[bot])

  Co-authored-by: renovate[bot] <29139614+renovate[bot]@users.noreply.github.com>

* fix: add ClusterRoleBinding to e2e test for RBAC permissions (by @patrickleet)

  The Helm provider with InjectedIdentity needs cluster-admin permissions
  to create namespaces and install charts. Without the ClusterRoleBinding,
  the e2e test fails with namespace creation forbidden error.

  Also standardized e2e test to match helm-xrd-pattern:
  - Added unique test name with timestamp
  - Added labels for test tracking
  - Increased timeouts to 30 minutes

  Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>

* fix: update applicationObservability receivers for chart v3.x (by @patrickleet)

  The k8s-monitoring chart v3.x expects receivers under `otlp:` key,
  not directly as `grpc:` and `http:`. Updated to correct schema.

  Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>

* fix: enable alloy-singleton for clusterEvents feature (by @patrickleet)

  The k8s-monitoring chart requires alloy-singleton to be enabled when
  using clusterEvents. Added it to the Alloy collectors configuration.

  Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>

* fix: name (by @patrickleet)

  Signed-off-by: Patrick Lee Scott <pat@patscott.io>


