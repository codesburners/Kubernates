pipeline {
    agent any
    stages {
        stage('Create PersistentVolumeClaim') {
            steps {
                bat '''
                if exist k8s\\pvc.yaml (
                    kubectl apply -f k8s\\pvc.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\pvc.yaml"
                )
                '''
            }
        }
        stage('Deploy Pod with PVC Mount') {
            steps {
                bat '''
                if exist k8s\\pvc-pod.yaml (
                    kubectl apply -f k8s\\pvc-pod.yaml
                ) else (
                    kubectl apply -f "C:\\Users\\gowth\\Desktop\\Kubernates\\k8s\\pvc-pod.yaml"
                )
                '''
            }
        }
        stage('Verify Persistent Storage Data') {
            steps {
                bat 'kubectl wait --for=condition=Ready pod/storage-pod --timeout=180s'
                bat 'kubectl get pvc lab-pvc'
                bat 'kubectl exec storage-pod -- cat /data/test.txt'
            }
        }
    }
}
