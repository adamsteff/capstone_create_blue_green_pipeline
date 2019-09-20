pipeline{
    agent any
    stages{
        stage('Lint HTML') {
            steps {
                sh 'tidy -q -e app/*.php'
            }
        }
        stage('Build Docker Image') {
           steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
                    sh '''
                        docker build -t adamsteff/cloudcapstone:$BUILD_ID .
                    '''
                }

            }
        }
        stage('Push Docker Image') {
           steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
                    sh '''

                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker push adamsteff/cloudcapstone:$BUILD_ID

                    '''
                }

            }
        }
    }
}