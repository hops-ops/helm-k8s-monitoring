import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# Unit tests for K8sMonitoring XRD
#
# Philosophy: Test YOUR API, not the provider's API.
# - render/validate already checks provider schema correctness
# - Tests should verify XRD spec fields produce expected behavior
# ==============================================================================

_items = [
    # ==========================================================================
    # Test 1: Minimal input renders Helm release with name defaulting to XR name
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "minimal-renders-helm-release"
        spec = {
            compositionPath = "apis/k8smonitorings/composition.yaml"
            xrdPath = "apis/k8smonitorings/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "K8sMonitoring"
                metadata.name = "test-k8s-monitoring"
                spec = {
                    clusterName = "test-cluster"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "test-k8s-monitoring"
                    spec.forProvider.values = {
                        cluster = {
                            name = "test-cluster"
                        }
                        destinations = [
                            {
                                name = "prometheus"
                                type = "prometheus"
                                url = "http://prometheus.monitoring:9090/api/v1/write"
                            }
                            {
                                name = "loki"
                                type = "loki"
                                url = "http://loki.monitoring:3100/loki/api/v1/push"
                            }
                            {
                                name = "tempo"
                                type = "otlp"
                                url = "http://tempo.monitoring:4317"
                                protocol = "grpc"
                            }
                        ]
                        clusterMetrics = {
                            enabled = True
                        }
                        "alloy-metrics" = {
                            enabled = True
                        }
                        clusterEvents = {
                            enabled = True
                        }
                        nodeLogs = {
                            enabled = True
                        }
                        podLogs = {
                            enabled = True
                        }
                        applicationObservability = {
                            enabled = True
                            receivers = {
                                otlp = {
                                    grpc = {
                                        enabled = True
                                        port = 4317
                                    }
                                    http = {
                                        enabled = True
                                        port = 4318
                                    }
                                }
                            }
                        }
                        prometheusOperatorObjects = {
                            enabled = True
                        }
                        "alloy-logs" = {
                            enabled = True
                        }
                        "alloy-singleton" = {
                            enabled = True
                        }
                        "alloy-receiver" = {
                            enabled = True
                        }
                        nodeExporter = {
                            enabled = False
                        }
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 2: Custom labels are applied and merged with defaults
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "custom-labels-merged-with-defaults"
        spec = {
            compositionPath = "apis/k8smonitorings/composition.yaml"
            xrdPath = "apis/k8smonitorings/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "K8sMonitoring"
                metadata.name = "labeled-k8s-monitoring"
                spec = {
                    clusterName = "test-cluster"
                    labels = {
                        team = "platform"
                        environment = "staging"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata = {
                        name = "labeled-k8s-monitoring"
                        labels = {
                            "hops.ops.com.ai/managed" = "true"
                            "hops.ops.com.ai/k8smonitoring" = "labeled-k8s-monitoring"
                            team = "platform"
                            environment = "staging"
                        }
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 3: overrideAllValues replaces defaults
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "override-all-values"
        spec = {
            compositionPath = "apis/k8smonitorings/composition.yaml"
            xrdPath = "apis/k8smonitorings/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "K8sMonitoring"
                metadata.name = "override-test"
                spec = {
                    clusterName = "my-cluster"
                    overrideAllValues = {
                        fullnameOverride = "custom-k8s-monitoring"
                        cluster = {
                            name = "my-cluster"
                        }
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "override-test"
                    spec.forProvider.values = {
                        fullnameOverride = "custom-k8s-monitoring"
                        cluster = {
                            name = "my-cluster"
                        }
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 4: Default namespace is monitoring
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "default-namespace-monitoring"
        spec = {
            compositionPath = "apis/k8smonitorings/composition.yaml"
            xrdPath = "apis/k8smonitorings/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "K8sMonitoring"
                metadata.name = "ns-test"
                spec = {
                    clusterName = "test-cluster"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "ns-test"
                    spec.forProvider.namespace = "monitoring"
                }
            ]
        }
    }

    # ==========================================================================
    # Test 5: Custom release name via spec.name
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "custom-release-name"
        spec = {
            compositionPath = "apis/k8smonitorings/composition.yaml"
            xrdPath = "apis/k8smonitorings/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "K8sMonitoring"
                metadata.name = "xr-name"
                spec = {
                    clusterName = "test-cluster"
                    name = "my-release"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "my-release"
                }
            ]
        }
    }

    # ==========================================================================
    # Test 6: Custom providerConfigRef
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "custom-provider-config"
        spec = {
            compositionPath = "apis/k8smonitorings/composition.yaml"
            xrdPath = "apis/k8smonitorings/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "K8sMonitoring"
                metadata.name = "provider-test"
                spec = {
                    clusterName = "test-cluster"
                    providerConfigRef = {
                        name = "shared-config"
                        kind = "ClusterProviderConfig"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "provider-test"
                    spec.providerConfigRef = {
                        name = "shared-config"
                        kind = "ClusterProviderConfig"
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 7: Status output from observed Helm release
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "status-from-observed-release"
        spec = {
            compositionPath = "apis/k8smonitorings/composition.yaml"
            xrdPath = "apis/k8smonitorings/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "K8sMonitoring"
                metadata.name = "status-test"
                spec = {
                    clusterName = "test-cluster"
                    namespace = "observability"
                }
            }
            observedResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata = {
                        name = "status-test"
                        annotations = {
                            "crossplane.io/composition-resource-name" = "helm-release-k8s-monitoring"
                        }
                    }
                    status = {
                        atProvider = {
                            state = "deployed"
                            revision = "1"
                        }
                        conditions = [
                            {
                                type = "Ready"
                                status = "True"
                                reason = "Available"
                                lastTransitionTime = "2024-01-01T00:00:00Z"
                            }
                        ]
                    }
                }
            ]
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "status-test"
                    spec.forProvider.namespace = "observability"
                }
            ]
        }
    }
]

items = _items
