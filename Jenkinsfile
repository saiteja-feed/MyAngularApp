pipeline {
    agent any

    environment {
        EC2_USER = 'ubuntu'
        EC2_IP = '98.89.5.238'
        PEM_PATH = '/home/saiteja/Downloads/jenkinsang.pem'
        REMOTE_DIR = '/var/www/my-angular-app'
        LOCAL_PROJECT = "${WORKSPACE}"  // Jenkins workspace
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Build') {
            steps {
                dir("${LOCAL_PROJECT}") {
                    sh 'npm install'
                    sh 'npx ng build --output-path=dist/my-angular-app'
                }
            }
        }

        stage('Transfer Artifacts') {
            steps {
                sh """
                scp -i ${PEM_PATH} -r ${LOCAL_PROJECT}/dist/my-angular-app/* ${EC2_USER}@${EC2_IP}:${REMOTE_DIR}/
                """
            }
        }

        stage('Restart Nginx') {
            steps {
                sh """
                ssh -i ${PEM_PATH} ${EC2_USER}@${EC2_IP} 'sudo systemctl restart nginx'
                """
            }
        }
    }

    post {
        success {
            echo "Angular app deployed successfully! Visit http://${EC2_IP}"
        }
        failure {
            echo "Deployment failed. Check logs for details."
        }
    }
}
