pipeline {
    agent {
        docker { image 'node:22.19.0-alpine3.22' }
    }

    environment {
        APP_DIR = 'MyAngularApp'
        EC2_USER = 'ubuntu'                          // EC2 username
        EC2_HOST = '98.89.5.238'                     // your EC2 IP
        SSH_KEY = '/home/saiteja/.ssh/id_rsa'        // Jenkins private key path
        REMOTE_DIR = '/var/www/html/my-angular-app'  // where files should go on EC2
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/saiteja-feed/MyAngularApp.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh """
                cd $APP_DIR
                npm install
                """
            }
        }

        stage('Build Angular App') {
            steps {
                sh """
                cd $APP_DIR
                npm run build -- --prod
                """
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: "$APP_DIR/dist/**", fingerprint: true
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh """
                # Copy build files to EC2
                scp -i $SSH_KEY -r $APP_DIR/dist/* $EC2_USER@$EC2_HOST:$REMOTE_DIR

                # Restart Nginx (make sure Nginx serves from $REMOTE_DIR)
                ssh -i $SSH_KEY $EC2_USER@$EC2_HOST "sudo systemctl restart nginx"
                """
            }
        }
    }

    post {
        success {
            echo '✅ Build, artifact archiving, and EC2 deployment completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}
