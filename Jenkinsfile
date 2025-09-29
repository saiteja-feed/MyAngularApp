pipeline {
    agent {
        docker { image 'node:22.19.0-alpine3.22' }
    }

    environment {
        APP_DIR = 'MyAngularApp'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/saiteja-feed/MyAngularApp.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                cd $APP_DIR
                npm install
                '''
            }
        }

        stage('Build Angular App') {
            steps {
                sh '''
                cd $APP_DIR
                npm run build -- --prod
                '''
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'MyAngularApp/dist/**', fingerprint: true
            }
        }
    }
}
