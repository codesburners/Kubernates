# Agile Development Process and DevOps Lab: Kubernetes Implemented Through Jenkins (15 Sets)

This repository contains the complete implementation for all 15 lab sets of the **Agile Development Process and DevOps Lab: Kubernetes Implemented Through Jenkins**.

---

## 🏗️ Architecture Overview

```
GitHub Repository (Source Code & Manifests)
            │
            ▼
    Jenkins Pipeline (Build, Test, Deploy Automation)
            │
            ▼
   Docker Engine (Image Packaging: devops-lab:latest)
            │
            ▼
Kubernetes Cluster (Pods, Deployments, Services, ConfigMaps, PVCs)
            │
            ▼
  Live Running Web Application (NodePort: 30008 / 30009 or Port Forward: 8081)
```

---

## 📁 Repository Structure

```
C:\Users\gowth\Desktop\Kubernates\
├── .gitignore
├── Jenkinsfile                          # Root Jenkinsfile for SCM (Set 15)
├── README.md                            # Comprehensive Lab Manual
├── start-jenkins.bat                    # One-click launcher for Jenkins (Java 21)
├── cleanup.bat                          # Reset/Clean all lab Kubernetes resources
├── setup-jenkins-jobs.ps1               # Automated script that creates all 15 jobs in Jenkins
├── run-job.ps1                          # Helper script to trigger and monitor any Jenkins job
├── app\
│   ├── Dockerfile                       # Multi-stage/Alpine Nginx Docker image
│   └── index.html                       # Responsive DevOps Lab web application
├── k8s\
│   ├── pod.yaml                         # Set 3: Pod manifest
│   ├── deployment.yaml                  # Set 4, 6, 7, 13, 14: Deployment manifest
│   ├── service.yaml                     # Set 5, 11: NodePort Service (Port 30008)
│   ├── configmap.yaml                   # Set 8: ConfigMap manifest
│   ├── config-deployment.yaml           # Set 8: Deployment with mounted ConfigMap
│   ├── pvc.yaml                         # Set 9: PersistentVolumeClaim (1Gi)
│   ├── pvc-pod.yaml                     # Set 9: Pod mounting PVC to /data
│   ├── readiness.yaml                   # Set 10: Deployment with HTTP readinessProbe
│   ├── image-deployment.yaml            # Set 12, 15: Custom Docker image Deployment
│   └── service-custom.yaml              # Set 15: NodePort Service (Port 30009)
└── pipelines\
    ├── Set-01-Kubernetes-Connection.jenkinsfile
    ├── Set-02-Sample-Deployment.jenkinsfile
    ├── Set-03-Pod-YAML.jenkinsfile
    ├── Set-04-Web-Deployment.jenkinsfile
    ├── Set-05-Expose-Service.jenkinsfile
    ├── Set-06-Scale-Deployment.jenkinsfile
    ├── Set-07-Update-Image.jenkinsfile
    ├── Set-08-ConfigMap.jenkinsfile
    ├── Set-09-Persistent-Storage.jenkinsfile
    ├── Set-10-Readiness-Probe.jenkinsfile
    ├── Set-11-GitHub-Integration.jenkinsfile
    ├── Set-12-Docker-Build-Deploy.jenkinsfile
    ├── Set-13-Rolling-Update.jenkinsfile
    ├── Set-14-Troubleshooting.jenkinsfile
    └── Set-15-Complete-CI-CD.jenkinsfile
```

---

## ⚡ Quick Start & Environment Verification

### 1. Launching Jenkins & Docker Desktop
- **Docker Desktop**: Open Docker Desktop from the Start Menu. Ensure Kubernetes is enabled in **Settings → Kubernetes**.
- **Jenkins**: Double-click `start-jenkins.bat` or run:
  ```powershell
  "C:\Program Files\Java\jdk-21\bin\java.exe" -jar "C:\Users\gowth\Downloads\jenkins.war" --httpPort=8080
  ```
- Jenkins dashboard will be live at: **`http://localhost:8080`**

### 2. Auto-Populating All 15 Jobs in Jenkins
To instantly create or update all 15 pipeline jobs in Jenkins:
```powershell
powershell -ExecutionPolicy Bypass -File .\setup-jenkins-jobs.ps1
```

### 3. Running Any Job from Terminal or Jenkins UI
- **In Jenkins UI**: Go to `http://localhost:8080`, click on the job (e.g. `Set-01-Kubernetes-Connection`), and click **Build Now**.
- **In PowerShell**:
  ```powershell
  .\run-job.ps1 -JobName "Set-01-Kubernetes-Connection"
  ```

---

## 📑 15 Lab Sets: Implementation Details & Verification

### Set 1: Configure Jenkins to connect to a Kubernetes cluster and verify connection
- **Aim**: Ensure Jenkins agent has access to `kubectl` and the local Kubernetes cluster.
- **Job Name**: `Set-01-Kubernetes-Connection`
- **Pipeline Script**: `pipelines/Set-01-Kubernetes-Connection.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl config current-context
  kubectl cluster-info
  kubectl get nodes
  ```
- **Expected Output**: Context is `docker-desktop` and the node `desktop-control-plane` is `Ready`.

---

### Set 2: Create a Jenkins Pipeline to deploy a sample application to Kubernetes
- **Aim**: Deploy a sample Nginx application imperatively or via generated YAML through Jenkins.
- **Job Name**: `Set-02-Sample-Deployment`
- **Pipeline Script**: `pipelines/Set-02-Sample-Deployment.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl get deployments lab-sample
  kubectl get pods -l app=lab-sample
  ```
- **Expected Output**: Deployment `lab-sample` with 1/1 replica `Running`.

---

### Set 3: Implement a Jenkins Pipeline to create a Kubernetes Pod using a YAML file
- **Aim**: Use a declarative manifest (`k8s/pod.yaml`) inside a pipeline to deploy an independent Pod.
- **Job Name**: `Set-03-Pod-YAML`
- **Pipeline Script**: `pipelines/Set-03-Pod-YAML.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl get pod lab-pod -o wide
  kubectl describe pod lab-pod
  ```
- **Expected Output**: Pod `lab-pod` reaches `Status: Running` and condition `Ready: True`.

---

### Set 4: Use Jenkins to deploy a web application to Kubernetes using a Deployment
- **Aim**: Deploy a scalable 2-replica Nginx web application using `k8s/deployment.yaml`.
- **Job Name**: `Set-04-Web-Deployment`
- **Pipeline Script**: `pipelines/Set-04-Web-Deployment.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl get deployment lab-web
  kubectl get pods -l app=lab-web
  ```
- **Expected Output**: `lab-web` shows `READY 2/2` with two active pods.

---

### Set 5: Configure Jenkins to expose a Kubernetes application using a Service
- **Aim**: Expose the `lab-web` application via a NodePort Service (`k8s/service.yaml`).
- **Job Name**: `Set-05-Expose-Service`
- **Pipeline Script**: `pipelines/Set-05-Expose-Service.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl get service lab-web-service
  kubectl get endpoints lab-web-service
  ```
- **Accessing the App**:
  ```powershell
  kubectl port-forward service/lab-web-service 8081:80
  ```
  Visit: `http://localhost:8081`

---

### Set 6: Implement a Jenkins Pipeline to scale a Kubernetes Deployment to three replicas
- **Aim**: Scale the `lab-web` deployment dynamically from 2 to 3 replicas.
- **Job Name**: `Set-06-Scale-Deployment`
- **Pipeline Script**: `pipelines/Set-06-Scale-Deployment.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl get deployment lab-web
  kubectl get pods -l app=lab-web
  ```
- **Expected Output**: `READY 3/3` replicas available.

---

### Set 7: Use Jenkins to update a Kubernetes Deployment with a new Docker image
- **Aim**: Update the container image to `nginx:alpine-slim` without downtime.
- **Job Name**: `Set-07-Update-Image`
- **Pipeline Script**: `pipelines/Set-07-Update-Image.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl get deployment lab-web -o wide
  ```
- **Expected Output**: The `IMAGES` column shows `nginx:alpine-slim`.

---

### Set 8: Configure a Jenkins Pipeline to deploy an application using a Kubernetes ConfigMap
- **Aim**: Decouple configuration from container code by mounting an HTML file via ConfigMap (`k8s/configmap.yaml` & `k8s/config-deployment.yaml`).
- **Job Name**: `Set-08-ConfigMap`
- **Pipeline Script**: `pipelines/Set-08-ConfigMap.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl get configmap web-config
  kubectl exec deployment/config-web -- cat /usr/share/nginx/html/index.html
  ```
- **Expected Output**: Prints `ConfigMap Deployment Successful`.

---

### Set 9: Use Jenkins to create a Kubernetes PersistentVolumeClaim and mount it inside a Pod
- **Aim**: Request dynamic storage via PVC (`k8s/pvc.yaml`) and mount it to `/data` in a busybox Pod (`k8s/pvc-pod.yaml`).
- **Job Name**: `Set-09-Persistent-Storage`
- **Pipeline Script**: `pipelines/Set-09-Persistent-Storage.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl get pvc lab-pvc
  kubectl exec storage-pod -- cat /data/test.txt
  ```
- **Expected Output**: PVC status is `Bound` and output prints `Persistent-data`.

---

### Set 10: Implement a Jenkins Pipeline to configure a readiness probe for a Kubernetes application
- **Aim**: Configure an HTTP GET readiness probe on port 80 to ensure traffic only reaches healthy containers (`k8s/readiness.yaml`).
- **Job Name**: `Set-10-Readiness-Probe`
- **Pipeline Script**: `pipelines/Set-10-Readiness-Probe.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl describe deployment ready-web
  kubectl get pods -l app=ready-web
  ```
- **Expected Output**: `Readiness: http-get http://:80/ delay=5s timeout=2s period=5s` and pods in `Running` (1/1 Ready).

---

### Set 11: Integrate GitHub with Jenkins to automatically deploy code changes to Kubernetes
- **Aim**: Connect Git SCM to Jenkins so changes trigger automated deployment.
- **Job Name**: `Set-11-GitHub-Integration`
- **Pipeline Script**: `pipelines/Set-11-GitHub-Integration.jenkinsfile`
- **Setup**:
  1. Push this repo to your GitHub account:
     ```powershell
     git remote add origin https://github.com/YOUR_USERNAME/kubernetes-jenkins-lab.git
     git push -u origin main
     ```
  2. In the Jenkins Job, set **Definition** to **Pipeline script from SCM**, choose **Git**, enter your repository URL.
  3. Under **Build Triggers**, enable **Poll SCM** (`H/5 * * * *`) or GitHub webhook.

---

### Set 12: Create a Jenkins CI/CD Pipeline to build a Docker image and deploy it to Kubernetes
- **Aim**: Build a custom Docker image (`devops-lab:%BUILD_NUMBER%`) from `app/Dockerfile` and deploy it to Kubernetes.
- **Job Name**: `Set-12-Docker-Build-Deploy`
- **Pipeline Script**: `pipelines/Set-12-Docker-Build-Deploy.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl get deployment custom-web -o wide
  kubectl get pods -l app=custom-web
  ```
- **Expected Output**: Deployment runs `devops-lab:1` with 2/2 ready pods.

---

### Set 13: Configure Jenkins to perform rolling updates and verify the rollout status of a Kubernetes Deployment
- **Aim**: Perform zero-downtime rolling update and inspect deployment rollout revision history.
- **Job Name**: `Set-13-Rolling-Update`
- **Pipeline Script**: `pipelines/Set-13-Rolling-Update.jenkinsfile`
- **Verification**:
  ```powershell
  kubectl rollout history deployment/lab-web
  kubectl rollout status deployment/lab-web
  ```
- **Expected Output**: Rollout history lists multiple revisions (e.g. revision 3, 4).

---

### Set 14: Implement a Jenkins Pipeline to detect and troubleshoot Kubernetes deployment failures
- **Aim**: Detect failed rollouts, catch error exit codes, and automatically print logs, events, and pod statuses for troubleshooting.
- **Job Name**: `Set-14-Troubleshooting`
- **Pipeline Script**: `pipelines/Set-14-Troubleshooting.jenkinsfile`
- **Diagnostic Commands Captured on Failure**:
  ```powershell
  kubectl get pods -l app=lab-web
  kubectl describe deployment lab-web
  kubectl get events --sort-by=.metadata.creationTimestamp
  kubectl logs deployment/lab-web --all-pods=true --tail=50
  ```

---

### Set 15: Complete CI/CD Pipeline using GitHub, Jenkins, Docker, and Kubernetes
- **Aim**: Full end-to-end CI/CD lifecycle: Checkout → Validate → Build Image → Test Image → Deploy → Verify.
- **Job Name**: `Set-15-Complete-CI-CD`
- **Pipeline Script**: `pipelines/Set-15-Complete-CI-CD.jenkinsfile` (also saved as root `Jenkinsfile`)
- **Verification**:
  ```powershell
  kubectl get deployment custom-web
  kubectl get svc custom-web-service
  kubectl port-forward service/custom-web-service 8082:80
  ```
  Open `http://localhost:8082` in Chrome to view the responsive live DevOps Lab web application.

---

## 🧹 Cleanup
When finished with the lab exercises, run:
```powershell
.\cleanup.bat
```
This safely deletes only the deployments, pods, services, configmaps, and PVCs created specifically for this lab.
