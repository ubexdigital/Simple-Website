// File: Jenkinsfile
pipeline {
    agent any  // Ensure Jenkins node has Docker installed

    environment {
        IMAGE_NAME = "my-nginx"
        CONTAINER_NAME = "nginx-server"
        DOCKER_PORT = "5000"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // If you want a custom Dockerfile in repo:
                    sh "docker build -t ${IMAGE_NAME} ."
                    // Or simply use official nginx image:
                    // sh "docker pull nginx:latest"
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    // Stop and remove container if exists
                    sh """
                    if [ \$(docker ps -aq -f name=${CONTAINER_NAME}) ]; then
                        docker rm -f ${CONTAINER_NAME}
                    fi
                    """

                    // Run nginx container
                    sh """
                    docker run -d --name ${CONTAINER_NAME} -p ${DOCKER_PORT}:80 ${IMAGE_NAME}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Nginx deployed successfully on Docker node"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}
