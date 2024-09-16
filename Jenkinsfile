pipeline {
    agent any

    environment {
        helm_repo_creds = "local-helm-creds"
        helm_repo = "github.com/prasanth-jaganathan/local-helm-repo.git"
        service_name = "test-svc"
        sonar_creds= "sonar_creds"
        DOCKER_CREDS = "DOCKER_CREDS"
    }
    stages {
        stage("Pre build") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: helm_repo_creds, usernameVariable: 'GIT_USERNAME', passwordVariable: "GIT_PASSWORD")]) {
                        println("Cloning HELM Repos")
                        sh "rm -r ${WORKSPACE}/local-helm-repo"
                        sh "git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@${helm_repo}"
                    }
                } //script
            } // steps
        } // pre-build stage
        
        stage("Mvn build") {
            steps {
                script {
                    """
                        echo "Maven build"
                        /usr/bin/docker run -i --platform=linux/amd64 --rm -v ${WORKSPACE}:/workspace -w /workspace -e MAVEN_OPTS=-DskipTests -e myCustomProperty=simple-svc maven /bin/bash -c \
                        "mvn clean install -f /workspace/pom.xml"
                    """
                } // script
            } //steps
        } // mvn build

        
        stage("Mvn Test") {
            steps {
                script {
                    """
                        echo "Maven build"
                        docker run -i --platform=linux/amd64 --rm -v ${WORKSPACE}:/workspace -w /workspace -e MAVEN_OPTS=-DskipTests -e myCustomProperty=simple-svc maven /bin/bash -c \
                        "mvn test -f /workspace/pom.xml"
                    """
                } // script
            } //steps
        } // mvn build

        stage("Docker build") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDS, usernameVariable: 'DOCKER_USERNAME', passwordVariable: "DOCKER_PASSWORD")]) {
                        sh """
                            /usr/local/bin/docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                            echo "docker.io/prasanth98/${service_name}:${BUILD_NUMBER}"

                            /usr/local/bin/docker build . -t docker.io/prasanth98/${service_name}:${BUILD_NUMBER}
                            /usr/local/bin/docker push docker.io/prasanth98/${service_name}:${BUILD_NUMBER}
                        """
                    }
                } // script
            } //steps
        } // Docker build
        
        stage("Helm upgrade") {
            steps {
                script {
                        sh """
                            /opt/homebrew/bin/helm upgrade --install ${service_name} ${WORKSPACE}/local-helm-repo/test-svc/ --set job.image.tag=${BUILD_NUMBER}
                        """
                } // script
            } //steps
        } // Helm upgrade


    } // stages

    post {
        always {
            sh "env"
        }
    }
} // pipeline
