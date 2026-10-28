pipeline {
    agent any
    stages {
        stage('Deploy Web Application') {
            steps {
                bat '''
                if exist k8s\\deployment.yaml (
                    kubectl apply -f k8s\\deployment.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\deployment.yaml"
                )
                '''
            }
        }
        stage('Verify Rollout') {
            steps {
                bat 'kubectl rollout status deployment/lab-web --timeout=120s'
                bat 'kubectl get deployment lab-web'
                bat 'kubectl get pods -l app=lab-web'
            }
        }
    }
}
