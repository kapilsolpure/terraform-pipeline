pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins') // your AWS credentials ID
        AWS_SECRET_ACCESS_KEY = credentials('jenkins')
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/kapilsolpure/terraform-pipeline.git', branch: 'main'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'jenkins'
                ]]) {
                    sh 'terraform init -input=false -reconfigure'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'jenkins'
                ]]) {
                    sh 'terraform plan -input=false -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'jenkins'
                ]]) {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Terraform applied successfully.'
        }
        failure {
            echo 'Terraform pipeline failed.'
        }
    }
}
