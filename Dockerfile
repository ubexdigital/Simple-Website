pipeline {
    agent any

    environment {
        // Change these for your setup
        DOCKER_HOST = "tcp://192.168.1.11:2375"   // Remote Docker daemon
        IMAGE_NAME = "my-html-site"
        IMAGE_TAG  = "latest"
        GIT_REPO   = "https://github.com/ubexdigital/Simple-Website.git"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${env.GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker -H ${DOCKER_HOST} build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    sh """
                        # Stop old container if running
                        docker -H ${DOCKER_HOST} rm -f ${IMAGE_NAME} || true
                        
                        # Run new container
                        docker -H ${DOCKER_HOST} run -d --name ${IMAGE_NAME} -p 80:80 ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }
}
