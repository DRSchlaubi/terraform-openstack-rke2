resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "100m" # because of autoscaler
    memory: "128Mi"
autoscaler:
  min: ${operator_replica}
# CCM itself needs DNS
tolerations:
      - key: "node.cloudprovider.kubernetes.io/uninitialized"
        operator: "Exists"
        effect: "NoSchedule"
