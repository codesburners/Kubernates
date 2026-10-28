@echo off
echo Cleaning up Kubernetes lab resources...
kubectl delete deployment lab-sample --ignore-not-found
kubectl delete deployment lab-web --ignore-not-found
kubectl delete deployment config-web --ignore-not-found
kubectl delete deployment ready-web --ignore-not-found
kubectl delete deployment custom-web --ignore-not-found
kubectl delete pod lab-pod storage-pod --ignore-not-found
kubectl delete service lab-web-service custom-web-service --ignore-not-found
kubectl delete configmap web-config --ignore-not-found
kubectl delete pvc lab-pvc --ignore-not-found
echo Cleanup complete!
