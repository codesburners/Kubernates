pipeline {
    agent any
    environment {
        APP_IMAGE = 'java-addition-app'
    }
    stages {
        stage('1. Test Java Logic') {
            steps {
                echo 'Testing Java Addition logic...'
                bat '''
                if exist Addition.java (
                    java -cp . Addition.java 25 35
                ) else (
                    java -cp "C:\\Users\\gowth\\Desktop\\Kubernates" "C:\\Users\\gowth\\Desktop\\Kubernates\\Addition.java" 25 35
                )
                '''
            }
        }
        stage('2. Build Docker Container') {
            steps {
                echo 'Building Java Docker image...'
                bat '''
                if exist Dockerfile.java (
                    docker build -f Dockerfile.java -t %APP_IMAGE%:%BUILD_NUMBER% -t %APP_IMAGE%:latest .
                ) else (
                    docker build -f "C:\\Users\\gowth\\Desktop\\Kubernates\\Dockerfile.java" -t %APP_IMAGE%:%BUILD_NUMBER% -t %APP_IMAGE%:latest "C:\\Users\\gowth\\Desktop\\Kubernates"
                )
                '''
            }
        }
        stage('3. Deploy to Kubernetes') {
            steps {
                echo 'Deploying Java Microservice to Kubernetes...'
                bat '''
                if exist k8s\\java-addition-deployment.yaml (
                    kubectl apply -f k8s\\java-addition-deployment.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\java-addition-deployment.yaml"
                )
                '''
                bat 'kubectl set image deployment/java-addition java-app=%APP_IMAGE%:%BUILD_NUMBER%'
                bat 'kubectl rollout status deployment/java-addition --timeout=180s'
            }
        }
        stage('4. Verify Pods & Service') {
            steps {
                bat 'kubectl get deployment java-addition -o wide'
                bat 'kubectl get pods -l app=java-addition'
                bat 'kubectl get svc java-addition-service'
            }
        }
        stage('5. Test Live Java Microservice') {
            steps {
                echo 'Testing calculation endpoint inside Kubernetes cluster...'
                bat 'kubectl exec deployment/java-addition -- wget -qO- "http://localhost:8080/?a=45&b=55"'
            }
        }
    }
    post {
        success {
            echo "=========================================================================="
            echo "SUCCESS: Java Addition Microservice Built & Deployed to Kubernetes!"
            echo "Access via NodePort: 30010 or port-forward: 8083 -> 8080"
            echo "=========================================================================="
        }
    }
}
