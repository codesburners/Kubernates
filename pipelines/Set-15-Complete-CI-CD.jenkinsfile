pipeline {
    agent any
    environment {
        APP_IMAGE = 'devops-lab'
    }
    stages {
        stage('Checkout Source Code') {
            steps {
                script {
                    try {
                        checkout scm
                    } catch (Exception e) {
                        echo "Standalone Pipeline mode: using local workspace files."
                    }
                }
            }
        }
        stage('Validate Manifests & Tools') {
            steps {
                bat 'kubectl version --client'
                bat 'docker --version'
                bat '''
                if exist k8s\\image-deployment.yaml (
                    kubectl apply --dry-run=client -f k8s\\image-deployment.yaml
                    kubectl apply --dry-run=client -f k8s\\service-custom.yaml
                ) else (
                    kubectl apply --dry-run=client -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\image-deployment.yaml"
                    kubectl apply --dry-run=client -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\service-custom.yaml"
                )
                '''
            }
        }
        stage('Build Docker Image') {
            steps {
                bat '''
                if exist app\\Dockerfile (
                    docker build -t %APP_IMAGE%:%BUILD_NUMBER% -t %APP_IMAGE%:latest app
                ) else (
                    docker build -t %APP_IMAGE%:%BUILD_NUMBER% -t %APP_IMAGE%:latest "C:\\Users\\gowth\\Desktop\\Kubernates\\app"
                )
                '''
            }
        }
        stage('Test Docker Image') {
            steps {
                echo "Testing built container image metadata..."
                bat 'docker image inspect %APP_IMAGE%:%BUILD_NUMBER%'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                bat '''
                if exist k8s\\image-deployment.yaml (
                    kubectl apply -f k8s\\image-deployment.yaml
                    kubectl apply -f k8s\\service-custom.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\image-deployment.yaml"
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\service-custom.yaml"
                )
                '''
                bat 'kubectl set image deployment/custom-web web=%APP_IMAGE%:%BUILD_NUMBER%'
                bat 'kubectl rollout status deployment/custom-web --timeout=180s'
            }
        }
        stage('Verify Application Live') {
            steps {
                bat 'kubectl get deployment custom-web'
                bat 'kubectl get pods -l app=custom-web'
                bat 'kubectl get svc custom-web-service'
            }
        }
    }
    post {
        success {
            echo "=========================================================="
            echo "SUCCESS: Complete CI/CD Pipeline Executed Successfully!"
            echo "Web app is running on NodePort 30009: http://localhost:30009"
            echo "=========================================================="
        }
        failure {
            echo "ERROR: Pipeline failed. Inspect console logs above."
        }
    }
}
