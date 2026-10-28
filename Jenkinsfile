pipeline {
    agent any
    stages {
        stage('Scale Deployment to 3 Replicas') {
            steps {
                bat 'kubectl scale deployment lab-web --replicas=3'
            }
        }
        stage('Verify Scale Rollout') {
            steps {
                bat 'kubectl rollout status deployment/lab-web --timeout=120s'
                bat 'kubectl get deployment lab-web'
                bat 'kubectl get pods -l app=lab-web'
            }
        }
    }
}
