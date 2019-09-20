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

                        # Step 1:
                        # Create dockerpath
                         dockerpath=adamsteff/cloudcapstone:$BUILD_ID

                        # Step 2:
                        # Authenticate & tag
                        #echo "Docker ID and Image: $dockerpath"
                        #docker login
                        docker tag cloudcapstone $dockerpath

                        # Step 3:
                        # Push image to a docker repository
                        docker push adamsteff/cloudcapstone:$BUILD_ID

                    '''
                }

            }
        }
    }
}