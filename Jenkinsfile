pipeline {
    agent any

    environment {
        APP_NAME = "demo-app"
        IMAGE_NAME = "demo-app-image"
        CONTAINER_NAME = "demo-app-container"
        PORT_RANGE_START = 3000
        PORT_RANGE_END = 3999
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/lokeshsomasundaram/demo-app.git', branch: 'main'
            }
        }

        stage('Cleanup Old Containers') {
            steps {
                sh """
                echo Removing old containers...
                docker ps -q -f name=${CONTAINER_NAME} | xargs -r docker stop
                docker ps -aq -f name=${CONTAINER_NAME} | xargs -r docker rm
                docker container prune -f
                """
            }
        }

        stage('Find Free Port') {
            steps {
                script {
                    def used_ports = sh(
                        script: "docker ps --format '{{.Ports}}' | cut -d':' -f2 | cut -d'-' -f1",
                        returnStdout: true
                    ).trim().split("\\s+")
                    
                    FREE_PORT = (PORT_RANGE_START..PORT_RANGE_END).find { !(it.toString() in used_ports) }
                    if(FREE_PORT == null) {
                        error "No free ports available in range ${PORT_RANGE_START}-${PORT_RANGE_END}"
                    }
                    echo "Free port found: ${FREE_PORT}"
                    writeFile file: "free_port.txt", text: "${FREE_PORT}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    FREE_PORT=\$(cat free_port.txt)
                    docker build -t ${IMAGE_NAME} .
                    """
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh """
                    FREE_PORT=\$(cat free_port.txt)
                    docker run -d --name ${CONTAINER_NAME} -p \${FREE_PORT}:80 ${IMAGE_NAME}
                    echo App running on port \${FREE_PORT}
                    """
                }
            }
        }

        stage('Verify') {
            steps {
                script {
                    sh """
                    FREE_PORT=\$(cat free_port.txt)
                    docker exec ${CONTAINER_NAME} curl -f http://localhost:80
                    echo Verification successful!
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Check Docker containers and logs."
        }
        success {
            echo "✅ CI/CD pipeline completed successfully!"
        }
        failure {
            echo "❌ CI/CD pipeline failed. Check console output for errors."
        }
    }
}
