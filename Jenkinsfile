pipeline {
    agent any

    // Triggers build automatically when Jenkins receives a GitHub push webhook.
    // Ensure the "GitHub Integration: GitHub plugin" is installed in Jenkins
    // and the webhook URL in GitHub is set to: http://<YOUR_JENKINS_SERVER>/github-webhook/
    triggers {
        githubPush()
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timestamps()
    }

    /* Uncomment and configure tools if your Jenkins agent uses tool configurations
    tools {
        maven 'Maven 3'
        jdk 'Java 17'
    }
    */

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
            // Collect JUnit test reports
            junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
            // Archive the generated JAR
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

