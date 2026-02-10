pipeline {
    agent any

    environment {
        IMAGE_NAME = 'demo-app-image'
        CONTAINER_NAME = 'demo-app-container'
        FREE_PORT = '8083'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/lokeshsomasundaram/demo-app.git', branch: 'main'
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

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Run Docker Container') {
            steps {
                sh "docker run -d --name $CONTAINER_NAME -p $FREE_PORT:80 $IMAGE_NAME"
                sh "echo App running on port $FREE_PORT"
            }
        }

        stage('Verify') {
            steps {
                sh "curl -f http://localhost:$FREE_PORT"
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
