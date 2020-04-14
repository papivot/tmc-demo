#!/bin/sh

# Assume one cluster is already attached to astroids clustergroup. 
# Assume that cluster's operations NS is already added to the argon workspace
# List all cluster
tmc cluster list

# List clusters in astroids
tmc cluster list --group astroids

# Make sure the context points to the new cluster that need to be added. 
kubectl config get-contexts
kubectl config use-context ............
tmc cluster attach -k ~/.kube/config -n tkg-workload-cluster -g astroids

# Add the operations NS to the argon WS.
tmc cluster namespace attach -c tkg-workload-cluster -k argon -n operations

# Create Policy for registry access (gcr.io & *.gcr.io)
tmc workspace image-policy create -f allowonly-gcr.yaml

# Run the application 
kubectl apply -f k8s-operations.yaml

# Swith context to the already existing cluster and run the app. 
kubectl config use-context ............
kubectl apply -f k8s-operations.yaml

# The app will not be running. 

# Delete tha policy and show app is running
tmc workspace image-policy delete allow-gcr-only argon

curl API_EP1
curl API_EP2

# Create Policy to deny network access.
tmc workspace network-policy create -f denyall-networkpolicy.yaml

curl API_EP1
curl API_EP2

# Delete tha policy and show app is running
tmc workspace network-policy delete deny-all-traffic argon
