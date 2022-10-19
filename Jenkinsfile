pipeline {
    agent any
    parameters {
        string(name: 'Status', defaultValue: 'Successful', description: 'build status?')
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo 'building docker image'
                sh('docker build -t sainammi/jenkins-demo-pipeline .')
            }
        }
        stage('Publish to Hub/Registry') {
            environment {
                Docker = credentials('Sai_Docker_Hub')
            }
            
            steps {
                script{
                    catchError(buildResult: curentBuild.result, stageResult: 'FAILURE') {
                        sh('docker login -u ${Docker_USR} -p ${Docker_PS}')
                        echo "successfully connected to Docker-Hub"
                        echo 'publishing to Hub'
                        sh('docker push sainammi/jenkins-demo-pipeline')
                        echo 'pushed image to docker hub'
                    }
                }
                
            }
            post {
                unstable {
                    echo "Build step Failed. Continue to the next step"  
                }        
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
                sh '''if [ $(docker ps | awk \'{print $NF}\' | grep sai-jenkins-web-server) = \'sai-jenkins-web-server\' ]; then
                        docker stop "sai-jenkins-web-server"
                        docker rm "sai-jenkins-web-server"
                fi'''
                sh('docker run -it -d -p 8081:80 --name sai-jenkins-web-server sainammi/jenkins-demo-pipeline')
                sh('docker exec sai-jenkins-web-server service nginx start')
                echo "Build ${params.Status}"
            }
        }
    }
}
