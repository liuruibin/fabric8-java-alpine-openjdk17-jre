 properties([ [ $class: 'ThrottleJobProperty',
                categories: ['metersphere'], 
                limitOneJobWithMatchingParams: false,
                maxConcurrentPerNode: 1,
                maxConcurrentTotal: 1,
                paramsToUseForLimit: '',
                throttleEnabled: true,
                throttleOption: 'category' ] ])
                
pipeline {
    agent {
        node {
            label 'metersphere'
        }
    }
    triggers {
        pollSCM('0 * * * *')
    }
    environment {
        BRANCH_NAME = 'latest'
        IMAGE_NAME = 'alpine-openjdk17-jre'
        IMAGE_PREFIX = 'registry.cn-qingdao.aliyuncs.com/metersphere'
    }
    stages {
        stage('Docker build & push') {
            steps {
                sh '''
                 docker --config /home/metersphere/.docker buildx build --build-arg MS_VERSION=\${TAG_NAME:-\$BRANCH_NAME}-\${GIT_COMMIT:0:8} -t ${IMAGE_PREFIX}/${IMAGE_NAME}:\${TAG_NAME:-\$BRANCH_NAME} --platform linux/amd64,linux/arm64 . --push
                '''
            }
        }
    }
    post('Notification') {
        always {
            sh "echo \$WEBHOOK\n"
            withCredentials([string(credentialsId: 'wechat-bot-webhook', variable: 'WEBHOOK')]) {
                qyWechatNotification failNotify: true, mentionedId: '', mentionedMobile: '', webhookUrl: "$WEBHOOK"
            }
        }
    }
}
