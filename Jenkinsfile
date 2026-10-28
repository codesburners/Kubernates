pipeline {
    agent any
    stages {
        stage('Expose Application with Service') {
            steps {
                bat '''
                if exist k8s\\service.yaml (
                    kubectl apply -f k8s\\service.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\service.yaml"
                )
                '''
            }
        }
        stage('Verify Service') {
            steps {
                bat 'kubectl get service lab-web-service'
                bat 'kubectl get endpoints lab-web-service'
            }
        }
    }
}
