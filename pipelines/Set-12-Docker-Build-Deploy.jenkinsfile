pipeline {
    agent any
    environment {
        APP_IMAGE = 'devops-lab'
    }
    stages {
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
        stage('Deploy to Kubernetes') {
            steps {
                bat '''
                if exist k8s\\image-deployment.yaml (
                    kubectl apply -f k8s\\image-deployment.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\image-deployment.yaml"
                )
                '''
                bat 'kubectl set image deployment/custom-web web=%APP_IMAGE%:%BUILD_NUMBER%'
                bat 'kubectl rollout status deployment/custom-web --timeout=180s'
            }
        }
        stage('Verify Deployment') {
            steps {
                bat 'kubectl get deployment custom-web -o wide'
                bat 'kubectl get pods -l app=custom-web'
            }
        }
    }
}
