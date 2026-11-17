pipeline {
    agent any

    triggers {
        githubPush()
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code from SCM...'
                checkout scm
            }
        }

        stage('Compile') {
            steps {
                echo 'Compiling Java source code...'
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                echo 'Running unit tests...'
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging application JAR...'
                sh 'mvn package -DskipTests'
            }
        }

        stage('Run / Smoke Test') {
            steps {
                echo 'Executing application JAR to verify output...'
                sh 'java -jar target/java-hello-world-1.0-SNAPSHOT.jar'
            }
        }
    }

    post {
        always {
            junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
            archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
        }
        success {
            echo "Pipeline build #${env.BUILD_NUMBER} completed successfully!"
        }
        failure {
            echo "Pipeline build #${env.BUILD_NUMBER} failed. Please inspect build console output."
        }
    }
}
