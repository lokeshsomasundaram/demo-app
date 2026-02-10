pipeline {
    agent any

    environment {
        IMAGE_NAME = 'demo-app-image'
        CONTAINER_NAME = 'demo-app-container'
        PORT_RANGE_START = 3000
        PORT_RANGE_END = 3999
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/lokeshsomasundaram/demo-app.git'
            }
        }

        stage('Cleanup Old Containers') {
            steps {
                sh '''
                echo "Removing old containers..."
                docker ps -q -f name=$CONTAINER_NAME | xargs -r docker stop
                docker ps -aq -f name=$CONTAINER_NAME | xargs -r docker rm
                docker container prune -f
                '''
            }
        }

        stage('Find Free Port') {
            steps {
                script {
                    def usedPorts = sh(
                        script: "docker ps --format '{{.Ports}}' | grep -oP '\\d+(?=->)'",
                        returnStdout: true
                    ).trim().split("\n").collect { it as int }

                    def freePort = (PORT_RANGE_START..PORT_RANGE_END).find { !(it in usedPorts) }
                    if (freePort == null) error "No free port available in range ${PORT_RANGE_START}-${PORT_RANGE_END}"
                    env.FREE_PORT = freePort.toString()
                    echo "Free port found: ${env.FREE_PORT}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Run Docker Container') {
            steps {
                sh "docker run -d --name $CONTAINER_NAME -p ${env.FREE_PORT}:80 $IMAGE_NAME"
                echo "App running on port ${env.FREE_PORT}"
            }
        }

        stage('Verify') {
            steps {
                sh "curl -f http://localhost:${env.FREE_PORT}"
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Check Docker containers and logs."
        }
        failure {
            echo "❌ CI/CD pipeline failed. Check console output for errors."
        }
    }
}
