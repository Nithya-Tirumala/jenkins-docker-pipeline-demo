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
                docker_creds = credentials('docker_creds')
            }
            steps {
                sh('docker login -u $docker_creds_USR -p $docker_creds_PSW')
                echo "successfully connected to Docker-Hub"
                echo 'publishing to Hub'
                sh('docker push sainammi/jenkins-demo-pipeline')
                echo 'pushed image to docker hub'
            }
        }
        stage('pull image from hub/registry') {
            steps {
                echo 'pulling image from docker hub'
                sh('docker pull sainammi/jenkins-demo-pipeline')
                echo 'pulled image sainammi/jenkins-demo-pipeline'
                sh('docker images')
            }
        }
        stage('start a container') {
            steps {
                sh('docker run -it -d -p 8081:80 --name sai-jenkins-web-server sainammi/jenkins-demo-pipeline')
                sh('docker exec sai-jenkins-web-server service nginx start')
            }
        }
    }
}
