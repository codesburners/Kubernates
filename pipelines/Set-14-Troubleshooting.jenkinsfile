pipeline {
    agent any
    stages {
        stage('Deploy Application') {
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
        stage('Health Check & Auto Troubleshooting') {
            steps {
                script {
                    echo "Checking deployment rollout health..."
                    def status = bat(
                        returnStatus: true,
                        script: 'kubectl rollout status deployment/lab-web --timeout=45s'
                    )
                    if (status != 0) {
                        echo "=== ROLLOUT FAILURE DETECTED! GATHERING DIAGNOSTICS ==="
                        bat 'kubectl get pods -l app=lab-web'
                        bat 'kubectl describe deployment lab-web'
                        bat 'kubectl get events --sort-by=.metadata.creationTimestamp'
                        bat 'kubectl logs deployment/lab-web --all-pods=true --tail=50'
                        error('Deployment failed health check. Detailed diagnostics captured above.')
                    } else {
                        echo "=== DEPLOYMENT HEALTHY ==="
                        bat 'kubectl get pods -l app=lab-web'
                    }
                }
            }
        }
    }
    post {
        failure {
            echo "Pipeline failed. Review the console diagnostics and Kubernetes events above."
        }
        success {
            echo "Deployment verified healthy with zero errors."
        }
    }
}
