pipeline {
    agent any
    environment {
        USER_VAR_1 = "Test-var"
        USER_VAR_2 = "Test-var2"
        mvnImg = "maven:3.6.1-jdk-8"
    }
    
    stages {
        stage("Pre-build") {
            steps {
                script {
                    println "This is a pre-build"
                }               
            }
        }
        stage("maven-build") {
            steps {
                script {
                    docker.image(mvnImg).inside("-v ${WORKSPACE}:/workspace") {
                        sh '''
                        mvn clean install -f /workspace/pom.xml -Dmaven.test.skip=false -DmyCustomProperty=${BUILD_NUMBER}
                        chmod -R 777 /workspace/*
                        '''
                    }
                }     
            }
        }
    }
}
