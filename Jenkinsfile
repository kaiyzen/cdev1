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
                  //sh 'git pull --rebase upstream master'
                }
                sh 'pwd'
                sh 'echo "----Finished with setup of repos----"'
            }
        }
        stage('build docker image') {
            steps {
                sh 'echo "----Building Docker Container------"'
                script {
                  docker.withRegistry("","jenkins-docker-token-01") {
                    //def newImage = docker.build("nemfoundation/test1:latest")
                    //newImage.push()
                    commitSha = ''
                    dir('catauplt-rest') {
                      commitSha = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
                      sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
                      sh "git log -n 1 --pretty=format:'%h'"
                    }
                    sh 'echo "Testing the sha value:${commitSha}"'
                    //newImage.tag("nemfoundation/test1:commit-${commitSha}")
                    //newImage.push()
                  }
                }
                sh 'echo "--------Finished building tagging and pushing new versions------------"'
            }
        }
    }
}
