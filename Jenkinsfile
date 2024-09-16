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
        
        stage("Mvn build") {
            steps {
                script {
                    """
                    docker run -it --rm -v ${WORKSPACE}:/workspace -w /workspace -e MAVEN_OPTS=-DskipTests -e myCustomProperty=simple-svc maven /bin/bash -c \
                    "mvn clean install -DmyCustomProperty=${myCustomProperty} -f /workspace/pom.xml"
                    """
                } // script
            } //steps
        } // mvn build
        
    } // stages 
} // pipeline
