pipeline {
  agent any
  environment {
    AWS_REGION = 'ap-south-1'
    TF_IN_AUTOMATION = 'true'
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
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
              echo "[INFO] Running Terraform Plan..."
              terraform plan -out=tfplan
              echo "[INFO] Terraform Plan completed."
            '''
          }
        }
      }
    }
    stage('Terraform Apply') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform-creds']]) {
          sh 'terraform apply -auto-approve tfplan'
        }
      }
    }
    stage('Show Public IP') {
      steps { sh 'terraform output instance_public_ip' }
    }
  }
  post {
    success { echo '🟢 Pipeline completed successfully!' }
    failure { echo '🔴 Pipeline failed — check logs for details.' }
  }
}
