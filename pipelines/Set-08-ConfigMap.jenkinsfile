pipeline {
    agent any
    stages {
        stage('Apply ConfigMap') {
            steps {
                bat '''
                if exist k8s\\configmap.yaml (
                    kubectl apply -f k8s\\configmap.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\configmap.yaml"
                )
                '''
            }
        }
        stage('Deploy Application with ConfigMap') {
            steps {
                bat '''
                if exist k8s\\config-deployment.yaml (
                    kubectl apply -f k8s\\config-deployment.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\config-deployment.yaml"
                )
                '''
                bat 'kubectl rollout status deployment/config-web --timeout=120s'
            }
        }
        stage('Verify Injected Config') {
            steps {
                bat 'kubectl get configmap web-config'
                bat 'kubectl exec deployment/config-web -- cat /usr/share/nginx/html/index.html'
            }
        }
    }
}
