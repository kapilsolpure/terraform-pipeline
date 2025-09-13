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
    sh '''
      terraform init -input=false -migrate-state || terraform init -input=false -reconfigure
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
