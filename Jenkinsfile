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

    stage('Terraform Format') {
      steps {
        sh '''
          echo "[INFO] Checking Terraform formatting..."
          terraform fmt -check || terraform fmt
        '''
      }
    }

    stage('Terraform Init') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins']]) {
          retry(2) {
            timeout(time: 15, unit: 'MINUTES') {
              sh '''
                echo "[INFO] Running Terraform Init..."
                export AWS_REGION=${AWS_REGION}
                terraform init -input=false -reconfigure
                echo "[INFO] Terraform Init completed."
              '''
            }
          }
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins']]) {
          timeout(time: 15, unit: 'MINUTES') {
            sh '''
              echo "[INFO] Running Terraform Plan..."
              export AWS_REGION=${AWS_REGION}
              terraform plan -out=tfplan
              echo "[INFO] Terraform Plan completed."
            '''
          }
        }
      }
    }

    stage('Approve Terraform Apply') {
      steps {
        input message: 'Do you want to apply the Terraform plan?', ok: 'Apply'
      }
    }

    stage('Terraform Apply') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins']]) {
          sh '''
            echo "[INFO] Running Terraform Apply..."
            export AWS_REGION=${AWS_REGION}
            terraform apply -auto-approve tfplan
            echo "[INFO] Terraform Apply completed."
          '''
        }
      }
    }

    stage('Show Public IP') {
      steps {
        sh '''
          echo "[INFO] Fetching EC2 public IP..."
          terraform output instance_public_ip
        '''
      }
    }
  }

  post {
    success {
      echo '🟢 Pipeline completed successfully!'
    }
    failure {
      echo '🔴 Pipeline failed — check logs for details.'
    }
  }
}
