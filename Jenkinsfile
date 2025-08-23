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

        stage('Build') {
            steps {
                bat 'npm install'
                bat 'npm run build'
                bat 'npm install -g @railway/cli'
                    
            }
        }


        stage('Unit Test') {
            steps {
                bat 'npm test'
            }
            // post {
            //     always {
            //         junit 'reports/junit/**/*.xml'  // if you export test reports
            //     }
            // }
        }

        stage('Deploy to Test Environment') {
            steps {
                bat '''
                    echo "Deploying to Railway..."
                    npx railway up --service datadrip --detach
                '''
            }
        }

        stage('Integration Test') {
            steps {
                bat 'echo "Running integration tests..." '
                bat 'npm run test:integration' 
            }
        }

        stage('Build Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    bat '''
                        docker build -t %DOCKER_REGISTRY%/%APP_NAME%:%BUILD_NUMBER% .
                        echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin
                        docker push %DOCKER_REGISTRY%/%APP_NAME%:%BUILD_NUMBER%
                    '''
                }
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
