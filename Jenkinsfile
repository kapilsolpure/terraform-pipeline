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
                    timeout(time: 10, unit: 'MINUTES') {
                        sh '''
                            echo "📌 Running Terraform Plan..."
                            terraform plan -out=tfplan | tee plan-output.log
                            echo "✅ Plan completed."
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform-creds']]) {
                    timeout(time: 10, unit: 'MINUTES') {
                        sh '''
                            echo "🚀 Applying Terraform Plan..."
                            terraform apply -auto-approve tfplan
                            echo "✅ Apply complete."
                        '''
                    }
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
