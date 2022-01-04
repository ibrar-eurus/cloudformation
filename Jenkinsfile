properties([parameters([string(defaultValue: 'master', description: 'select branch', name: 'branch')])])
properties([parameters([string(defaultValue: 'ibrar', name: 'EnvironmentName')])])
pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="489994096722"
        AWS_DEFAULT_REGION="us-east-2" 
        IMAGE_REPO_NAME="demo"
        IMAGE_TAG="$BUILD_NUMBER"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    stages {


          stage('Cloning Git') {
            steps {
              
              checkout([$class: 'GitSCM',
                          branches: [[name: "${params.branch}"]],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [],
                          gitTool: 'Default',
                          submoduleCfg: [],
                          userRemoteConfigs: [[url: 'https://github.com/ibrar-eurus/docker-demo.git', credentialsId: 'git']]
                        ])
            
                //checkout([$class: 'GitSCM', branches: [[name: '${params.BRANCH}']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git', url: 'https://github.com/ibrar-eurus/docker-demo.git']]])     
            }
        }
        
         stage('Logging into AWS ECR') {
            steps {
                script {

                sh "aws cloudformation create-stack --stack-name my-test-stack \
    --template-body file://ab.yml \
    --parameters  ParameterKey=EnvironmentName,ParameterValue=${params.EnvironmentName}  ParameterKey=Subnets,ParameterValue=\"subnet-0701fd774993bed57,subnet-031c4e048ba16d7da\" ParameterKey=InstanceType,ParameterValue=t2.micro ParameterKey=ClusterSize,ParameterValue=2 ParameterKey=VPC,ParameterValue=vpc-0d0c36615fed53aa2 ParameterKey=SecurityGroup,ParameterValue=sg-0761c2ae1d0c78119 ParameterKey=KeyPair,ParameterValue=test ParameterKey=AMId,ParameterValue=ami-0ec2e33c6e1161e98 --capabilities CAPABILITY_NAMED_IAM"
                

                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
                 
            }
        }
        
        
  
    // Building Docker images and Uploading Docker images into AWS ECR
    stage('Building and push') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
          sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
          sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    
  
    }
}