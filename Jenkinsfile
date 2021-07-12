#!groovy
// Run docker build
properties([disableConcurrentBuilds()])

pipeline {
    agent { 
        label 'master'
        }
    triggers { pollSCM('H * * * *') }
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
        stage("make test") {
            steps {
                echo " ============== start test =================="
                sh 'make test'
            }
        }
        stage("docker image result") {
            steps {
                echo " ============== The Gitea image is built by Docker =================="                
            }
        }
    }
}