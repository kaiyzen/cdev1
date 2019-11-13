pipeline {
    agent { node { label 'docker-rest' } }
    stages {
        stage('setup repos') {
            steps {
                sh 'git clone https://github.com/Alexhuszagh/catapult-rest.git'
                sh 'cd catapult-rest'
                sh 'git fetch origin release && git checkout release'
                sh 'git remote add upstream https://github.com/nemtech/catapult-rest.git'
                sh 'git pull --rebase upstream master
                sh 'echo "----Finished with setup of repos----"'
            }
        }
    }
}
