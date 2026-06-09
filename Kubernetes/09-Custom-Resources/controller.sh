#!/bin/bash

while true
do
    IMAGE=$(kubectl get website my-site -o jsonpath='{.spec.image}' 2>/dev/null)

    POD_EXISTS=$(kubectl get pod website-pod --no-headers 2>/dev/null | wc -l)

    if [ ! -z "$IMAGE" ] && [ "$POD_EXISTS" -eq 0 ]; then

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: website-pod
spec:
  containers:
  - name: web
    image: $IMAGE
EOF

        echo "Pod created from Website resource"

    fi

    sleep 5
done