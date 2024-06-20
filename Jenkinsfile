pipeline {
    environment {
        imagename = "royaldevops/java-docker"
        registryCredential = 'dockerpasswd'
        dockerImage = ''
    }

    agent any
    tools {
       maven 'maven3'
   }

    stages {
        stage('CHECKOUT STAGE') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/guhan2104/java-helloworld.git']])
            }
        }
        // stage('SONAR STAGE') {
        //     steps {
        //         sh "mvn clean verify sonar:sonar -Dsonar.projectKey=java-new -Dsonar.projectName='java-new' -Dsonar.host.url=http://44.202.212.236:9000 -Dsonar.token=sqp_04538421ce3bd1baac821a2e4189812b19bbd28b"
        //     }
        // }
        stage('MAVEN BUILD STAGE') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('DAST SCAN') {
            steps {
                dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'Dp-check'
            }
        }
	stage('JFROG ARTIFACTORY PUSH') {
            steps {
                sh 'curl -H X-JFrog-Art-Api:cmVmdGtuOjAxOjE3NTA0MzU1OTM6cEN5ZU9KbFMydVp6Wmx1MjdyYkZRZDVETlhU -T /var/lib/jenkins/workspace/javapp/target/helloworld-1.0-SNAPSHOT.war http://44.199.244.80:8082/artifactory/java-repo/$BUILD_NUMBER/helloworld-1.0-SNAPSHOT.war'
            }
        }
        stage('Building image') {
    steps{
         script {
                dockerImage = docker.build imagename
            }
        }
    }
    stage('TRIVY SCAN') {
            steps {
                sh 'trivy image $imagename'
            }
        }
    stage('Deploy Image') {
    steps{
        script {
                docker.withRegistry( '', registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
                }
            }
        }
    }
    stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $imagename:$BUILD_NUMBER"
                sh "docker rmi $imagename:latest"
            }
        }
    stage('SSH Docker Container Stop') {
            steps{
                script {
                    input message: 'Approve Docker Stop?', ok: 'Approve', submitter: 'admin'
                }
                sshPublisher(publishers: [sshPublisherDesc(configName: 'app-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'sudo docker stop java-app', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
            }
        }
	stage('SSH Docker Container Remove') {
            steps{
                sshPublisher(publishers: [sshPublisherDesc(configName: 'app-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'sudo docker rm java-app', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
            }
        }
	stage('SSH Docker Image Remove') {
            steps{
                sshPublisher(publishers: [sshPublisherDesc(configName: 'app-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'sudo docker rmi royaldevops/java-docker:latest', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
            }
        }
	stage('SSH Docker Pull') {
            steps{
                sshPublisher(publishers: [sshPublisherDesc(configName: 'app-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'sudo docker pull royaldevops/java-docker:latest', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
            }
        }
	stage('SSH Docker Run') {
            steps{
                sshPublisher(publishers: [sshPublisherDesc(configName: 'app-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'sudo docker run -itd --name=java-app -p 8080:8080 royaldevops/java-docker:latest', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
            }
        }	


    }
}
