pipeline {
    agent any
    stages {
        stage('Deploy with Readiness Probe') {
            steps {
                bat '''
                if exist k8s\\readiness.yaml (
                    kubectl apply -f k8s\\readiness.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\readiness.yaml"
                )
                '''
            }
        }
        stage('Verify Readiness Status') {
            steps {
                bat 'kubectl rollout status deployment/ready-web --timeout=120s'
                bat 'kubectl get pods -l app=ready-web'
                bat 'kubectl describe deployment ready-web'
            }
        }
    }
}
