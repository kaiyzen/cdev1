def restSha = 'UNKOWN'

pipeline {
    agent { node { label 'docker-rest' } }
    triggers {
        pollSCM('H/5 * * * *')
//        upstream(upstreamProjects: 'trigger-rest-fork-01,trigger-rest-fork-02', threshold: hudson.model.Result.SUCCESS)
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }
    stages {
        stage('setup repos') {
            steps {
                sh 'rm -rf catapult-rest'
                //sh 'git clone https://github.com/Alexhuszagh/catapult-rest.git'
                sh 'git clone https://github.com/kaiyzen/catapult-rest.git'
                dir('catapult-rest') {
                  //sh 'git fetch origin release'
                  //sh 'git checkout release'
                  sh 'git remote add upstream https://github.com/nemtech/catapult-rest.git'
                  sh 'git pull --rebase upstream master'
                  script {
		    restSha = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'")
		  }
                }
                sh 'echo "----Finished with setup of repos----"'
            }
        }
        stage('build docker image') {
            steps {
                sh 'echo "----Building Docker Container------"'
                script {
                  docker.withRegistry("","jenkins-docker-token-01") {
                    def newImage = docker.build("nemfoundation/symbol-rest-beta")
                    newImage.push("latest")
                    commitSha = ''
                    dir('catauplt-rest') {
                      sh 'echo "inside script/dir testing sha inline: ${restSha}"'
                    }
                    sh 'echo "Testing the sha value:${restSha}"'
                    newImage.push("commit-${restSha}")
                  }
                }
                sh 'echo "--------Finished building tagging and pushing new versions------------"'
            }
        }
        stage('run digest update') {
            steps {
                sh 'echo "--------Pulling Image to Update Container Digest-------"'
                //script {
                //  docker.withRegistry("","jenkins-docker-token-01") {
                //    def dImg = docker.image("rpelavin/update-digests")
                //    dImg.run("-v /home/ubuntu/jenkins/docker/f2-compat-auto-update-cfg.yaml:/usr/share/auto-update/config.yaml")
                //    sh 'echo "Ran docker digest update test..."'
                //  }
                //}
            }
        }
    }
    post {
      failure {
        mail to: "daminate@gmail.com,nate@nem.foundation",
        subject: "Catapult Rest Build Failed: ${currentBuild.fullDisplayName}",
        body: "Error with build attempt: ${env.BUILD_URL}"
      }
    }
}
