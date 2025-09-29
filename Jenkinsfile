pipeline {
    agent any

    environment {
        // Node version, update if needed
        NODE_VERSION = '18'
        // Angular app folder name
        APP_DIR = 'MyAngularApp'
        // EC2 server details
        EC2_USER = 'ubuntu'
        EC2_HOST = 'your.ec2.ip.address'
        SSH_KEY = '/var/lib/jenkins/.ssh/your-key.pem'
        REMOTE_DIR = '/var/www/html/my-angular-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/saiteja-feed/MyAngularApp.git'
            }
        }

        stage('Install Node & Dependencies') {
            steps {
                sh '''
                curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
                sudo apt-get install -y nodejs
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
                archiveArtifacts artifacts: "$APP_DIR/dist/**", fingerprint: true
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh '''
                scp -i $SSH_KEY -r $APP_DIR/dist/* $EC2_USER@$EC2_HOST:$REMOTE_DIR
                ssh -i $SSH_KEY $EC2_USER@$EC2_HOST "sudo systemctl restart nginx"
                '''
            }
        }
    }

    post {
        success {
            echo 'Build, artifact archiving, and deployment completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}
