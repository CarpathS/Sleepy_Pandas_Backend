pipeline {
    agent any

    environment {
        PYTHON_IMAGE = "python:3.12-slim"
        APP_IMAGE = "sleepy-panda-backend:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Mengambil source code dari repository...'
                checkout scm
            }
        }

        stage('Check Docker') {
            steps {
                echo 'Cek Docker dan Docker Compose...'
                sh 'docker --version'
                sh 'docker compose version'
            }
        }

        stage('Check Project Python') {
            steps {
                echo 'Cek versi Python sesuai project...'
                sh '''
                    docker run --rm ${PYTHON_IMAGE} python --version
                '''
            }
        }

        stage('Install Dependencies & Test') {
            steps {
                echo 'Install dependency dan menjalankan test menggunakan Python project...'
                sh '''
                    docker run --rm \
                    --volumes-from sleepy_panda_jenkins \
                    -w "$WORKSPACE" \
                    ${PYTHON_IMAGE} \
                    sh -c "ls -la && python -m pip install --upgrade pip && pip install -r requirements-ci.txt && python -m compileall backend"
                '''
            }
        }
        
        stage('Build Backend Image') {
            steps {
                echo 'Build Docker image backend...'
                sh 'docker build -t ${APP_IMAGE} .'
            }
        }

        stage('Deploy With Docker Compose') {
            steps {
                echo 'Deploy ulang aplikasi dengan Docker Compose...'
                sh 'docker compose down'
                sh 'docker compose up -d --build'
            }
        }

        stage('Check Running Containers') {
            steps {
                echo 'Cek container yang sedang berjalan...'
                sh 'docker ps'
            }
        }
    }

    post {
        success {
            echo 'CI/CD berhasil. Aplikasi berhasil di-build dan di-deploy ulang.'
        }

        failure {
            echo 'CI/CD gagal. Cek log error di Jenkins.'
        }
    }
}