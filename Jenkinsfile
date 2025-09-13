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
        sh 'terraform init -input=false -reconfigure'
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
  }

  post {
    always {
      cleanWs()
    }
  }
}
