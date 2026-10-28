pipeline {
    agent any
    stages {
        stage('Update Container Image') {
            steps {
                bat 'kubectl set image deployment/lab-web web=nginx:alpine-slim'
            }
        }
        stage('Verify Rolling Update') {
            steps {
                bat 'kubectl rollout status deployment/lab-web --timeout=180s'
                bat 'kubectl get deployment lab-web -o wide'
            }
        }
    }
}
