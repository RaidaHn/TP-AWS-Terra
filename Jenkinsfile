pipeline {
    agent any

    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Manual Approval') {
            steps {
                script {
                    def userInputs = input message: 'Que voulez-vous faire ?', ok: 'Valider', parameters: [
                        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choisir l\'action Terraform'),
                        choice(name: 'ENVIRONMENT', choices: ['DEV', 'VALIDATION', 'PROD'], description: 'Choisir l\'environnement de déploiement')
                    ]
                    env.TERRAFORM_ACTION = userInputs.ACTION
                    env.TERRAFORM_ENV = userInputs.ENVIRONMENT
                }
            }
        }
        stage('Terraform Apply') {
            when {
                expression { env.TERRAFORM_ACTION == 'apply' }
            }
            steps {
                echo "Déploiement sur l'environnement: ${env.TERRAFORM_ENV}"
                sh 'terraform apply -auto-approve -var="environment=${TERRAFORM_ENV}"'
            }
        }
        stage('Terraform Destroy') {
            when {
                expression { env.TERRAFORM_ACTION == 'destroy' }
            }
            steps {
                echo "Destruction sur l'environnement: ${env.TERRAFORM_ENV}"
                sh 'terraform destroy -auto-approve -var="environment=${TERRAFORM_ENV}"'
            }
        }
    }
}
