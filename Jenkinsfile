def restSha = 'UNKOWN'
def awesomeVersion = 'UNKNOWN'

pipeline {
    agent { node { label 'docker-rest' } }
    triggers {
        pollSCM('H/10 * * * *')
        upstream(upstreamProjects: 'trigger-rest-fork-01', threshold: hudson.model.Result.SUCCESS)
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
                  script {
		    restSha = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'")
                    awesomeVersion = sh(returnStdout: true, script: 'echo 0.0.1')
		  }
                  sh 'git remote add upstream https://github.com/nemtech/catapult-rest.git'
                  //sh 'git pull --rebase upstream master'
                }
                sh 'pwd'
                sh 'echo "end of repo steps sha : ${restSha}"'
                sh 'echo "----Finished with setup of repos----"'
            }
        }
        stage('build docker image') {
            steps {
                echo "awesomeVersion: ${awesomeVersion}"
                echo "restSha: ${restSha}"
                sh 'echo "----Building Docker Container------"'
                script {
                  docker.withRegistry("","jenkins-docker-token-01") {
                    def newImage = docker.build("nemfoundation/test1")
                    newImage.push("latest")
                    commitSha = ''
                    dir('catauplt-rest') {
                      sh 'echo "inside script/dir testing sha inline: ${restSha}"'
                    }
                    sh 'echo "Testing the sha value:${restSha}"'
                    newImage.push("commit-${restSha}")
                  }
                  echo "awesomeVersion: ${awesomeVersion}"
                  echo "restSha: ${restSha}"
                }
                sh 'echo "--------Finished building tagging and pushing new versions------------"'
            }
        }
    }
}
