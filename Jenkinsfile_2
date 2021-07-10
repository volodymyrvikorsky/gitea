#!groovy
// Run docker build
properties([disableConcurrentBuilds()])

pipeline {
    agent { 
        label 'master'
        }
    triggers { pollSCM('* * * * *') }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps()
    }
    stages {
        stage("create docker image") {
            steps {
                echo " ============== start building image =================="
                sh 'make docker'
            }
        }
        stage("docker-COMPOSE UP") {
            steps {
                echo " ============== start docker-compose =================="
                sh 'docker-compose up -d'
            }
        }
        stage("docker push") {
            steps {
                echo " ============== start pushing image =================="                
            }
        }
    }
}