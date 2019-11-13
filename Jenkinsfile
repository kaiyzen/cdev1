pipeline {
    agent { node { label 'docker-rest' } }
    stages {
        stage('setup repos') {
            steps {
                sh 'echo "hello first pipeline run!!"'
            }
        }
    }
}
