pipeline {
    agent any
    stages {
        stage('Ensure Base Deployment') {
            steps {
                bat '''
                if exist k8s\\deployment.yaml (
                    kubectl apply -f k8s\\deployment.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\deployment.yaml"
                )
                '''
                bat 'kubectl rollout status deployment/lab-web --timeout=120s'
            }
        }
        stage('Perform Rolling Update') {
            steps {
                bat 'kubectl set image deployment/lab-web web=nginx:alpine-slim'
            }
        }
        stage('Monitor Rollout Status & History') {
            steps {
                bat 'kubectl rollout status deployment/lab-web --timeout=180s'
                bat 'kubectl rollout history deployment/lab-web'
                bat 'kubectl get pods -l app=lab-web -o wide'
            }
        }
    }
}
