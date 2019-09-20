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
        stage('Set Kubectl Context to Cluster') {
            steps{
                withAWS(region:'ap-southeast-2',credentials:'aws') {
                    sh 'echo "Set current kubectl context to the cluster..."'
                    export KUBECONFIG=~/.kube/config
                    sh 'kubectl config use-context arn:aws:eks:ap-southeast-2:048353547478:cluster/capstonecluster'
                }

            }
        }
    }
}