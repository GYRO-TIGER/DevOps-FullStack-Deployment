pipeline {
    agent any 
    
    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub__login_credentials'
        IMAGE_NAME = 'dhruvsharma004/devops-fullstack-deployment'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        CI = 'true'
    }

    tools {
        nodejs 'NodeJS'
    }

    stages {
        stage ('Checkout Source Code') {
            steps {
                echo 'Checking out the master branch...'
                git branch: 'master', url: 'https://github.com/GYRO-TIGER/DevOps-FullStack-Deployment.git'
            }
        }

        // stage ('Build application') {
        //     steps {
        //         echo 'Building the application from the master branch...'
        //         sh 'npm install'
        //         sh 'npm run build'
        //     }
        // }

        stage ('Run Tests') {
            steps {
                echo 'Running tests on the source code...'
                sh 'npm test'
            }
            post {
                always {
                    echo 'Tests completed successfully.'
                }
            }
        }

        stage ('Build Docker Image') {
            steps {
                echo 'Building the Docker image...'
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage ('Push to DockerHub') {
            steps {
                echo 'Authenticating and pushing the image to the DockerHub...'
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up local Docker images to free up Jenkins disk space...'
            sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
            sh "docker rmi ${IMAGE_NAME}:latest || true"
        }
        success {
            echo 'React/TS Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Please check the logs.'
        }
    }
}