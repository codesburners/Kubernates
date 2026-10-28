pipeline {
    agent any
    stages {
        stage('Create Pod from YAML') {
            steps {
                bat '''
                if exist k8s\\pod.yaml (
                    kubectl apply -f k8s\\pod.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\pod.yaml"
                )
                '''
            }
        }
        stage('Verify Pod') {
            steps {
                bat 'kubectl wait --for=condition=Ready pod/lab-pod --timeout=120s'
                bat 'kubectl get pod lab-pod -o wide'
                bat 'kubectl describe pod lab-pod'
            }
        }
    }
}
