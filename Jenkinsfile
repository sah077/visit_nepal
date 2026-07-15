pipeline {
    agent any

    environment {
        IMAGE_NAME = 'visitnepal'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    options {
        timestamps()
        timeout(time: 20, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Files') {
            steps {
                sh '''
                    test -f Dockerfile
                    test -f visit_nepal2027.html
                    test -d images
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Smoke Test') {
            steps {
                sh """
                    docker run --rm -d --name ${IMAGE_NAME}-smoke -p 8081:80 ${IMAGE_NAME}:${IMAGE_TAG} >/dev/null
                    sleep 5
                    docker ps --filter \"name=${IMAGE_NAME}-smoke\" | grep -q ${IMAGE_NAME}-smoke
                    docker rm -f ${IMAGE_NAME}-smoke >/dev/null 2>&1 || true
                """
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'Dockerfile, visit_nepal2027.html, images/**', allowEmptyArchive: false
            }
        }
    }

    post {
        always {
            sh "docker image rm -f ${IMAGE_NAME}:${IMAGE_TAG} >/dev/null 2>&1 || true"
        }
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please inspect the logs.'
        }
    }
}
