pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-html-site"
        DOCKER_CONTAINER = "html_site_container"
        DOCKER_PORT = "8080"
    }

    stages {
        stage('Checkout from GitHub') {
            steps {
                git branch: 'main', url: 'https://github.com/ubexdigital/Simple-Website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    // Stop old container if running
                    sh """
                    if [ \$(docker ps -q -f name=${DOCKER_CONTAINER}) ]; then
                        docker stop ${DOCKER_CONTAINER}
                        docker rm ${DOCKER_CONTAINER}
                    fi
                    """

                    // Run new container
                    sh "docker run -d --name ${DOCKER_CONTAINER} -p ${DOCKER_PORT}:80 ${DOCKER_IMAGE}"
                }
            }
        }
    }
}
