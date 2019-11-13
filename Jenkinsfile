pipeline {
    agent { node { label 'docker-rest' } }
    triggers {
        pollSCM('H/5 * * * *')
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }
    stages {
        stage('setup repos') {
            steps {
                sh 'rm -rf catapult-rest'
                sh 'git clone https://github.com/Alexhuszagh/catapult-rest.git'
                dir('catapult-rest') {
                  sh 'git fetch origin release'
                  sh 'git checkout release'
                  sh 'git remote add upstream https://github.com/nemtech/catapult-rest.git'
                  sh 'git pull --rebase upstream master'
                }
                sh 'pwd'
                sh 'echo "----Finished with setup of repos----"'
            }
        }
    }
}
