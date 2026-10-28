pipeline {
    agent any
    stages {
        stage('Check Tools') {
            steps {
                bat 'where kubectl'
                bat 'kubectl version --client'
            }
        }
        stage('Check Context') {
            steps {
                bat 'kubectl config current-context'
            }
        }
        stage('Connect to Cluster') {
            steps {
                bat 'kubectl cluster-info'
                bat 'kubectl get nodes -o wide'
            }
        }
    }
}
