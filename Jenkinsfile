pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                echo 'building docker image'
                sh('docker build -t sainammi/jenkins-demo-pipeline .')
            }
        }
        stage('Publish to Hub/Registry') {
            environment {
                SERVICE_CREDS = credentials('docker_creds')
            }
            steps {
                echo "Service user is $SERVICE_CREDS_USR"'
                echo "Service password is $SERVICE_CREDS_PSW"'
                curl -u $SERVICE_CREDS https://hub.docker.com/'
                echo "successfully connected to github"'
                echo 'publishing to Hub'
                docker push sainammi/jenkins-demo-pipeline
                echo 'pushed image to docker hub'
            }
        }
        stage('pull image from hub/registry') {
            steps {
                echo 'pulling image from docker hub'
                docker pull sainammi/jenkins-demo-pipeline
                echo 'pulled image sainammi/jenkins-demo-pipeline'
                docker images
            }
        }
        stage('start a container') {
            steps {
                docker run -it -d -p 8081:80 --name sai-jenkins-web-server sainammi/jenkins-demo-pipeline
                docker exec sai-jenkins-web-server service nginx start
            }
        }
    }
}
