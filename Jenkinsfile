pipeline {
    agent any

    environment {
        helm_repo_creds = "local-helm-creds"
        helm_repo = "github.com/prasanth-jaganathan/local-helm-repo.git"
    }

    stages {
        stage("Pre build") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: helm_repo_creds, usernameVariable: 'GIT_USERNAME', passwordVariable: "GIT_PASSWORD")]) {
                        println("Cloning HELM Repos")
                        sh "git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@${helm_repo}"
                    }
                } //script
            } // steps
        } // pre-build stage
    } // stages 
} // pipeline
