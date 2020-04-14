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
                sh 'git clone https://github.com/nemtech/catapult-rest.git'
                dir('catapult-rest') {
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
                    def newImage = docker.build("techbureau/catapult-rest-server-nightly")
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
    }
    post {
      failure {
        mail to: "daminate@gmail.com,nate@nem.foundation",
        subject: "Catapult Rest Build Failed: ${currentBuild.fullDisplayName}",
        body: "Error with build attempt: ${env.BUILD_URL}"
      }
    }
}
