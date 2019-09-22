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
                        docker build --no-cache -t adamsteff/capstone-green:latest .
                    '''
                }

            }
        }
        stage('Push Docker Image') {
           steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
                    sh '''
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker push adamsteff/capstone-green:latest
                    '''
                }

            }
        }
        stage('Set Kubectl Context to Cluster') {
            steps{
                sh 'kubectl config use-context arn:aws:eks:ap-southeast-2:048353547478:cluster/capstonecluster'
            }
        }
        stage('Create Blue Controller') {
            when {
                expression { env.BRANCH_NAME == 'blue' }
            }
            steps{
                withAWS(region:'ap-southeast-2',credentials:'aws') {
                    sh '''
                        ##sed -i 's/BUILD_ID/'$BUILD_ID'/g' ./blue-controller.json
                        cat ./green-controller.json
                    '''
                    sh 'kubectl apply -f ./blue-controller.json'
                    sh 'kubectl rolling-update blueversion --image=adamsteff/capstone-blue:latest'
                }
            }
        }
        stage('Create Green Controller') {
                    when {
                        expression { env.BRANCH_NAME == 'green' }
                    }
                    steps{
                        withAWS(region:'ap-southeast-2',credentials:'aws') {
                            sh '''
                                ##sed -i 's/BUILD_ID/'$BUILD_ID'/g' ./green-controller.json
                                cat ./green-controller.json
                            '''
                            sh 'kubectl apply -f ./green-controller.json'
                             sh 'kubectl rolling-update greenversion --image=adamsteff/capstone-green:latest'
                        }
                    }
                }
        stage('Deploy to Production?') {
              when {
                expression { env.BRANCH_NAME != 'master' }
              }

              steps {
                // Prevent any older builds from deploying to production
                milestone(1)
                input 'Deploy to Production?'
                milestone(2)
              }
        }
        stage('Create Blue-Green service') {
            when {
                expression { env.BRANCH_NAME != 'master' }
            }
            steps{
                withAWS(region:'ap-southeast-2',credentials:'aws') {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                        sh 'kubectl apply -f ./blue-green-service.json'
                        sh 'kubectl get pods'
                        sh 'kubectl describe service bluegreenlb4'
                    }
                }
            }

        }
    }
}