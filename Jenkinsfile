def restSha = 'UNKOWN'

pipeline {
    agent { node { label 'docker-rest' } }
    triggers {
        pollSCM('H/5 * * * *')
        upstream(upstreamProjects: 'trigger-rest-fork-01,trigger-rest-fork-02', threshold: hudson.model.Result.SUCCESS)
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }
    stages {
        stage('run digest update') {
            steps {
                sh 'echo "--------Pulling Image to Update Container Digest-------"'
                script {
                  docker.withRegistry("","jenkins-docker-token-01") {
                    def dImg = docker.image("rpelavin/update-digests")
                    dImg.run()
                    sh 'echo "Ran docker digest update test..."'
                  }
                }
            }
        }
        stage('setup repos') {
            steps {
                //sh 'rm -rf catapult-rest'
                sh 'git clone https://github.com/Alexhuszagh/catapult-rest.git'
                dir('catapult-rest') {
                  sh 'git fetch origin release'
                  sh 'git checkout release'
                  script {
		    restSha = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'")
		  }
                  sh 'git remote add upstream https://github.com/nemtech/catapult-rest.git'
                  //sh 'git pull --rebase upstream master'
                }
                sh 'echo "----Finished with setup of repos----"'
            }
        }
        stage('build docker image') {
            steps {
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
                    //newImage.push("commit-${restSha}")
                    newImage.push("foooooooo/bararrrrrrr/basssssssss/commit-${restSha}")
                  }
                }
                sh 'echo "--------Finished building tagging and pushing new versions------------"'
            }
        }
    }
    post {
      failure {
        mail to: "daminate@gmail.com,nate@nem.foundation,daminate@hotmail.com",
        subject: "Catapult Rest Build Failed: ${currentBuild.fullDisplayName}",
        body: "Error with build attempt: ${env.BUILD_URL}"
      }
    }
}
