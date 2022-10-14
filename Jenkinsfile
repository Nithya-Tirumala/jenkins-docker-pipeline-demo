pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                sh echo 'building docker image'
                sh('docker build -t sainammi/jenkins-demo-pipeline .')
                sh echo 'successfully build docker image'
            }
        }
        stage('Publish to Hub/Registry') {
            environment {
                SERVICE_CREDS = credentials('docker_creds')
            }
            steps {
                sh 'echo "Service user is $SERVICE_CREDS_USR"'
                sh 'echo "Service password is $SERVICE_CREDS_PSW"'
                sh 'curl -u $SERVICE_CREDS https://hub.docker.com/'
                sh 'echo "successfully connected to github"'
                sh echo 'publishing to Hub'
                sh docker push sainammi/jenkins-demo-pipeline
                sh echo 'pushed image to docker hub'
            }
        }
        stage('pull image from hub/registry') {
            steps {
                sh echo 'pulling image from docker hub'
                sh docker pull sainammi/jenkins-demo-pipeline
                sh echo 'pulled image sainammi/jenkins-demo-pipeline'
                sh docker images
            }
        }
        stage('start a container') {
            steps {
                sh("docker run -it -d -p 8081:80 --name sai-jenkins-web-server sainammi/jenkins-demo-pipeline")
                sh docker exec sai-jenkins-web-server service nginx start
            }
        }
    }
}
