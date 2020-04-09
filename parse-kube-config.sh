#!/usr/bin/env bash

mkdir -p ~/.kube

if [ ! -z "$KUBE_CONFIG" ]; then
	echo -n "$KUBE_CONFIG" > ~/.kube/config
  chmod 600 ~/.kube/config
else
	echo "Missing KUBE_CONFIG variable."
	exit 1
fi
