pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins').accessKeyId
        AWS_SECRET_ACCESS_KEY = credentials('jenkins').secretAccessKey
        AWS_DEFAULT_REGION    = 'us-east-1'  // change as per your region
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                   terraform init -input=false -migrate-state
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -input=false -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
