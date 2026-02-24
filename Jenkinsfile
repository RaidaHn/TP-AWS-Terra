pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
  }

  environment {
    AWS_DEFAULT_REGION = 'us-east-1'
    TF_IN_AUTOMATION   = 'true'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          terraform --version
          aws sts get-caller-identity || true
          terraform init -input=false
        '''
      }
    }

    stage('Terraform Validate') {
      steps { sh 'terraform validate' }
    }

    stage('Terraform Plan') {
      steps {
        sh '''
          terraform plan -input=false -out=tfplan
          terraform show -no-color tfplan > tfplan.txt
        '''
      }
      post {
        always {
          archiveArtifacts artifacts: 'tfplan,tfplan.txt', fingerprint: true
        }
      }
    }

    stage('Manual Approval') {
      steps { input message: 'Approve Terraform Apply?', ok: 'Deploy' }
    }

    stage('Terraform Apply') {
      steps { sh 'terraform apply -input=false -auto-approve tfplan' }
    }
  }
}