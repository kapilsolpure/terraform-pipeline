pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Show Public IP') {
            steps {
                sh 'terraform output instance_public_ip'
            }
        }
    }

    post {
        success {
            echo 'Terraform Apply Completed Successfully!'
        }
        failure {
            echo 'Terraform Apply Failed.'
        }
    }
}
