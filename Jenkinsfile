pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
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
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform-creds']]) {
                    sh 'terraform init -reconfigure'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform-creds']]) {
                    sh 'terraform plan -input=false'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform-creds']]) {
                    sh 'terraform apply -auto-approve -input=false'
                }
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
            echo '✅ Terraform Apply Completed Successfully!'
        }
        failure {
            echo '❌ Terraform Apply Failed.'
        }
    }
}


