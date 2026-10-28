pipeline {
    agent any
    stages {
        stage('Deploy Sample Application') {
            steps {
                bat 'kubectl create deployment lab-sample --image=nginx:alpine --dry-run=client -o yaml > sample.yaml'
                bat 'kubectl apply -f sample.yaml'
            }
        }
        stage('Verify Rollout & Pods') {
            steps {
                bat 'kubectl rollout status deployment/lab-sample --timeout=120s'
                bat 'kubectl get deployments lab-sample'
                bat 'kubectl get pods -l app=lab-sample'
            }
        }
    }
}
