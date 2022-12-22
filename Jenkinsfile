pipeline {
    agent any
    parameters {
        string(name: 'Status', defaultValue: 'finished', description: 'build status?')
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo 'building docker image'
                sh('sudo docker build -t sainammi/jenkins-demo-pipeline .')
            }
        }
        stage('Publish to Hub/Registry') {
            environment {
                Docker = credentials('Sai_Docker_Hub')
            }
            
            steps {
                script{
                    catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                        sh('sudo docker login -u ${Docker_USR} -p ${Docker_PSW}')
                        echo "successfully connected to Docker-Hub"
                        echo 'publishing to Hub'
                        sh('sudo docker push sainammi/jenkins-demo-pipeline')
                        echo 'pushed image to docker hub'
                    }
                }
                
            }
            
        }
        stage('pull image from hub/registry') {
            steps {
                echo 'pulling image from docker hub'
                sh('sudo docker pull sainammi/jenkins-demo-pipeline')
                echo 'pulled image sainammi/jenkins-demo-pipeline'
                sh('sudo docker images')
            }
        }
        stage('start a container') {
            steps {
                sh '''if [ $(sudo docker ps | awk \'{print $NF}\' | grep sai-jenkins-web-server) = \'sai-jenkins-web-server\' ]; then
                        sudo docker stop "sai-jenkins-web-server"
                        sudo docker rm "sai-jenkins-web-server"
                fi'''
                sh('sudo docker run -it -d -p 8081:80 --name sai-jenkins-web-server sainammi/jenkins-demo-pipeline')
                sh('sudo docker exec sai-jenkins-web-server service nginx start')
                echo "Build ${params.Status}"
            }
        }
    }
    post {
        always {
            emailext body: "details: \n '${env.BUILD_URL}'",
                subject: "Jenkins Job '${env.BUILD_TAG} ${currentBuild.result}'",
                     to: 'sai_nammi@persistent.com',
                     attachLog: true
        }
    }
}
