#!/usr/bin/env bash

if [[ $# -lt 2 ]] ; then
    echo 'Run the script as $@ OPENSTACK_USERNAME RKE2_FLOATING_IP'
    echo 'e.g.: $@ CloudComp1 10.32.6.6'
    exit 0
fi

OPENSTACK_USERNAME="$1"
CLUSTER_NAME="$(echo $OPENSTACK_USERNAME | tr A-Z a-z)-k8s"

CLUSTER_IP="$2"

ssh ubuntu@$CLUSTER_IP sudo cat /etc/rancher/rke2/rke2.yaml > rke2.yaml

chmod go-r rke2.yaml \
      && yq eval --inplace '.clusters[0].name = "'${CLUSTER_NAME}'-cluster"' rke2.yaml \
      && yq eval --inplace '.clusters[0].cluster.server = "https://'${CLUSTER_IP}':6443"' rke2.yaml \
      && yq eval --inplace '.users[0].name = "'${CLUSTER_NAME}'-user"' rke2.yaml \
      && yq eval --inplace '.contexts[0].context.cluster = "'${CLUSTER_NAME}'-cluster"' rke2.yaml \
      && yq eval --inplace '.contexts[0].context.user = "'${CLUSTER_NAME}'-user"' rke2.yaml \
      && yq eval --inplace '.contexts[0].name = "'${CLUSTER_NAME}'"' rke2.yaml \
      && yq eval --inplace '.current-context = "'${CLUSTER_NAME}'"' rke2.yaml \
      && mv rke2.yaml ${CLUSTER_NAME}.rke2.yaml

echo "Cluster KUBECONFIG written to: ${CLUSTER_NAME}.rke2.yaml"
echo
echo "Use it with:"
echo "export KUBECONFIG=\"$(pwd)/${CLUSTER_NAME}.rke2.yaml\""
echo "or"
echo "cp ${CLUSTER_NAME}.rke2.yaml ~/.kube/config"
