apiVersion: v1
kind: Secret
metadata:
  name: openstack-ca
  namespace: kube-system
type: Opaque
data:
  ca.crt: >-
    ${base64encode(ca_cert)}
