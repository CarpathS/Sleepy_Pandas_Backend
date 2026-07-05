pipeline {
    agent any

    environment {
        PYTHON_IMAGE = "sleepy-panda-ci:latest"
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
        }docker system df

        stage('Install Dependencies & Test') {
            steps {
                echo 'Menjalankan test menggunakan CI image...'
                sh '''
                    docker run --rm \
                    --volumes-from sleepy_panda_jenkins \
                    -w "$WORKSPACE" \
                    ${PYTHON_IMAGE} \
                    sh -c "ls -la && python -m compileall backend"
                '''
            }
        }

        stage('Build Backend Image') {
            steps {
                echo 'Build Docker image backend...'
                sh 'docker build -t ${APP_IMAGE} .'
            }
        }

        stage('Prepare Env File') {
            steps {
                echo 'Membuat file .env dari Jenkins Credentials...'

                withCredentials([
                    string(credentialsId: 'db-user', variable: 'DB_USER'),
                    string(credentialsId: 'db-pass', variable: 'DB_PASS'),
                    string(credentialsId: 'db-name', variable: 'DB_NAME'),
                    string(credentialsId: 'db-host', variable: 'DB_HOST'),
                    string(credentialsId: 'db-port', variable: 'DB_PORT'),
                    string(credentialsId: 'database-url', variable: 'DATABASE_URL'),
                    string(credentialsId: 'secret-key', variable: 'SECRET_KEY'),
                    string(credentialsId: 'jwt-algorithm', variable: 'JWT_ALGORITHM'),
                    string(credentialsId: 'access-token-expire-minutes', variable: 'ACCESS_TOKEN_EXPIRE_MINUTES'),
                    string(credentialsId: 'smtp-server', variable: 'SMTP_SERVER'),
                    string(credentialsId: 'smtp-port', variable: 'SMTP_PORT')
                ]) {
                    sh '''
                        cat > .env <<EOF
DB_USER=$DB_USER
DB_PASS=$DB_PASS
DB_NAME=$DB_NAME
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT

DATABASE_URL=$DATABASE_URL

SECRET_KEY=$SECRET_KEY
JWT_ALGORITHM=$JWT_ALGORITHM
ACCESS_TOKEN_EXPIRE_MINUTES=$ACCESS_TOKEN_EXPIRE_MINUTES

SMTP_SERVER=$SMTP_SERVER
SMTP_PORT=$SMTP_PORT
EMAIL_SENDER=
EMAIL_PASSWORD=
EOF

                        chmod 600 .env
                        echo ".env berhasil dibuat untuk Docker Compose"
                        ls -la .env
                    '''
                }
            }
        }

        stage('Deploy With Docker Compose') {
            steps {
                echo 'Deploy ulang aplikasi dengan Docker Compose...'
                sh 'docker compose --env-file .env down'
                sh 'docker compose --env-file .env up -d --build'
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