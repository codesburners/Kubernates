pipeline {
    agent any
    triggers {
        // Poll SCM every 5 minutes (for local labs without public webhook URLs)
        pollSCM('H/5 * * * *')
    }
    stages {
        stage('Checkout Code from Git') {
            steps {
                checkout scm
            }
        }
        stage('Deploy Manifests to Kubernetes') {
            steps {
                bat 'kubectl apply -f k8s/deployment.yaml'
                bat 'kubectl apply -f k8s/service.yaml'
            }
        }
        stage('Verify Automated Rollout') {
            steps {
                bat 'kubectl rollout status deployment/lab-web --timeout=120s'
                bat 'kubectl get pods -l app=lab-web'
                bat 'kubectl get svc lab-web-service'
            }
        }
    }
}
