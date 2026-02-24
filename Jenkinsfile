pipeline {
  agent any

  parameters {
    choice(
      name: 'DEPLOY_ENV',
      choices: ['dev', 'val', 'prod'],
      description: 'Choisir l’environnement de déploiement'
    )

    string(
      name: 'CLIENT',
      defaultValue: '',
      description: 'Nom du client (texte libre, ex: clientA)'
    )

    choice(
      name: 'ACTION',
      choices: ['apply', 'destroy'],
      description: 'Choisir l’action Terraform'
    )
  }

  environment {
    ENVIRONMENT = "${params.DEPLOY_ENV}"
    CLIENT_NAME = "${params.CLIENT}"
    TF_IN_AUTOMATION = 'true'
  }

  // Optionnel (nécessite plugin AnsiColor)
  // options { ansiColor('xterm') }

  stages {

    stage('Afficher paramètres') {
      steps {
        echo "Environnement sélectionné : ${ENVIRONMENT}"
        echo "Client sélectionné : ${CLIENT_NAME}"
        echo "Action sélectionnée : ${params.ACTION}"
      }
    }

    stage('Validation saisie') {
      steps {
        script {
          if (!CLIENT_NAME?.trim()) {
            error("Le paramètre CLIENT est vide. Renseigne un nom de client.")
          }
        }
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init -input=false'
      }
    }

    stage('Terraform Validate') {
      steps {
        sh 'terraform validate'
      }
    }

    stage('Terraform Plan') {
      when { expression { params.ACTION == 'apply' } }
      steps {
        sh """
          terraform plan -input=false -out=tfplan \
            -var='environment=${ENVIRONMENT}' \
            -var='client=${CLIENT_NAME}'
        """
      }
    }

    stage('Manual Approval') {
      steps {
        script {
          def msg = (params.ACTION == 'destroy')
            ? "⚠️ Confirmer DESTROY pour ${ENVIRONMENT} / ${CLIENT_NAME} ?"
            : "Valider le déploiement APPLY ${ENVIRONMENT} pour ${CLIENT_NAME} ?"

          input message: msg, ok: (params.ACTION == 'destroy' ? 'Détruire' : 'Appliquer')
        }
      }
    }

    stage('Terraform Apply/Destroy') {
      steps {
        script {
          if (params.ACTION == 'destroy') {
            sh """
              terraform destroy -input=false -auto-approve \
                -var='environment=${ENVIRONMENT}' \
                -var='client=${CLIENT_NAME}'
            """
          } else {
            sh "terraform apply -input=false -auto-approve tfplan"
          }
        }
      }
    }
  }

  post {
    success {
      // Slack optionnel: nécessite config Jenkins + plugin slack
      // slackSend(channel: "#terraform", color: "good",
      //   message: "✅ ${params.ACTION.toUpperCase()} ${ENVIRONMENT} - ${CLIENT_NAME} réussi")
      echo "✅ ${params.ACTION.toUpperCase()} ${ENVIRONMENT} - ${CLIENT_NAME} réussi"
    }

    failure {
      // slackSend(channel: "#terraform", color: "danger",
      //   message: "❌ ${params.ACTION.toUpperCase()} ${ENVIRONMENT} - ${CLIENT_NAME} échoué")
      echo "❌ ${params.ACTION.toUpperCase()} ${ENVIRONMENT} - ${CLIENT_NAME} échoué"
    }
  }
}