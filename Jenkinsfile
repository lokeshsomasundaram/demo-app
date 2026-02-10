pipeline {
    agent any

    environment {
        APP_NAME = "demo-app"
        IMAGE_NAME = "demo-app-image"
        CONTAINER_NAME = "demo-app-container"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Checkout your Git repository
                git branch: 'main', url: 'https://github.com/lokeshsomasundaram/demo-app.git'
            }
        }

        stage('Cleanup Old Containers') {
            steps {
                sh '''
                #!/bin/bash
                echo "Removing old containers..."
                docker ps -q -f name=$CONTAINER_NAME | xargs -r docker stop
                docker ps -aq -f name=$CONTAINER_NAME | xargs -r docker rm
                docker container prune -f
                '''
            }
        }

        stage('Find Free Port') {
            steps {
                sh '''
                #!/bin/bash
                # Find a free port between 3000-3999
                USED_PORTS=$(docker ps --format "{{.Ports}}" | cut -d ":" -f2)
                for PORT in $(seq 3000 3999); do
                    if ! echo "$USED_PORTS" | grep -q "$PORT"; then
                        export FREE_PORT=$PORT
                        break
                    fi
                done
                echo "Free port found: $FREE_PORT"
                echo $FREE_PORT > free_port.txt
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                #!/bin/bash
                FREE_PORT=$(cat free_port.txt)
                docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                #!/bin/bash
                FREE_PORT=$(cat free_port.txt)
                docker run -d --name $CONTAINER_NAME -p $FREE_PORT:80 $IMAGE_NAME
                echo "App running on port $FREE_PORT"
                '''
            }
        }

        stage('Verify') {
            steps {
                sh '''
                #!/bin/bash
                FREE_PORT=$(cat free_port.txt)
                curl -f http://localhost:$FREE_PORT || exit 1
                echo "App verification succeeded on port $FREE_PORT"
                '''
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
