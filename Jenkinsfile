pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('jenkins')
    AWS_SECRET_ACCESS_KEY = credentials('jenkins')
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/kapilsolpure/terraform-pipeline.git'
      }
    }

    stage('Terraform Init') {
      steps {
        // Try to init with reconfigure, fallback to normal init
        sh '''
        terraform init -input=false -reconfigure || terraform init -input=false
        '''
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -input=false -out=tfplan'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply -input=false -auto-approve tfplan'
      }
    }

    stage('Show URL') {
      steps {
        script {
          def ip = sh(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
          echo "Your EC2 welcome page is at: http://${ip}"
        }
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}
