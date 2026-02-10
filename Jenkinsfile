pipeline {
    agent any

    environment {
        IMAGE_NAME = "demo-app"
        CONTAINER_NAME = "demo-app-container"
        CONTAINER_PORT = "80"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'main', url: 'https://github.com/lokeshsomasundaram/demo-app.git'
            }
        }

        stage('Cleanup Old Containers') {
            steps {
                echo 'Stopping and removing old containers...'
                sh '''
                if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
                    docker stop $CONTAINER_NAME
                fi
                if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
                    docker rm $CONTAINER_NAME
                fi
                docker container prune -f
                '''
            }
        }

        stage('Find Free Port') {
            steps {
                script {
                    env.HOST_PORT = sh(
                        script: "comm -23 <(seq 8080 8100) <(docker ps --format '{{.Ports}}' | awk -F '->' '{print $1}' | sed 's/.*://') | head -n 1",
                        returnStdout: true
                    ).trim()
                    echo "Selected free port: ${env.HOST_PORT}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "Running Docker container on port ${env.HOST_PORT}..."
                sh '''
                docker run -d \
                    --name $CONTAINER_NAME \
                    -p $HOST_PORT:$CONTAINER_PORT \
                    $IMAGE_NAME:latest
                '''
            }
        }

        stage('Verify') {
            steps {
                echo "Docker container $CONTAINER_NAME is now running on port $HOST_PORT"
                sh 'docker ps'
            }
        }
    }

    post {
        success {
            echo '✅ CI/CD pipeline completed successfully!'
        }
        failure {
            echo '❌ CI/CD pipeline failed. Check console output for errors.'
        }
    }
}
