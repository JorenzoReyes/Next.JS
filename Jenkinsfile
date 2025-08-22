pipeline {
    agent any

    environment {
        RAILWAY_TOKEN = credentials('railway_api_token')  // Store in Jenkins Credentials
        DOCKER_REGISTRY = "docker.io/jorenzo"
        APP_NAME = "datadrip"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'CICD-act',
                    url: 'https://github.com/JorenzoReyes/datadrip'
            }
        }

        stage('Install & Build') {
            steps {
                sh '''
                    npm install
                    npm run build
                '''
            }
        }

        stage('Unit Test') {
            steps {
                sh 'npm test'
            }
            // post {
            //     always {
            //         junit 'reports/junit/**/*.xml'  // if you export test reports
            //     }
            // }
        }

        stage('Deploy to Test Environment') {
            steps {
                sh '''
                    echo "Deploying to Railway..."
                    railway up --service $APP_NAME --detach --token=$RAILWAY_TOKEN
                '''
            }
        }

        stage('Integration Test') {
            steps {
                sh '''
                    echo "Running integration tests..."
                    # Example: wait for test env to be live
                    sleep 30
                    npm run test:integration
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $DOCKER_REGISTRY/$APP_NAME:$BUILD_NUMBER .
                    echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                    docker push $DOCKER_REGISTRY/$APP_NAME:$BUILD_NUMBER
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline finished successfully!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
