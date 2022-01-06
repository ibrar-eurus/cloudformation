#!/bin/bash -xe
                if aws cloudformation describe-stacks --stack-name ${stackname} >/dev/null 2>/dev/null
then
	echo "${stackname} exists!"
  

aws cloudformation deploy --template-file real.yml --stack-name ${stackname} \\
    	--parameter-overrides ParameterKey=EnvironmentName,ParameterValue=${EnvironmentName}  ParameterKey=Subnets,ParameterValue=${subnets} ParameterKey=InstanceType,ParameterValue=${InstanceType} ParameterKey=ClusterSize,ParameterValue=${ClusterSize} ParameterKey=VPC,ParameterValue=${VPC} ParameterKey=SecurityGroup,ParameterValue=${SecurityGroup} ParameterKey=KeyPair,ParameterValue=${KeyPair} ParameterKey=AMId,ParameterValue=${AMId} --no-fail-on-empty-changeset  --capabilities CAPABILITY_NAMED_IAM
    	echo "${stackname} updating start!"
	aws cloudformation wait stack-update-complete --stack-name ${stackname}
    	echo "${stackname} update complete!"


else
	echo "${stackname} creation start"
	aws cloudformation create-stack --stack-name ${stackname} \\
    	--template-body file://real.yml \\
    	--parameters  ParameterKey=EnvironmentName,ParameterValue=${EnvironmentName}  ParameterKey=Subnets,ParameterValue=${subnets} ParameterKey=InstanceType,ParameterValue=${InstanceType} ParameterKey=ClusterSize,ParameterValue=${ClusterSize} ParameterKey=VPC,ParameterValue=${VPC} ParameterKey=SecurityGroup,ParameterValue=${SecurityGroup} ParameterKey=KeyPair,ParameterValue=${KeyPair} ParameterKey=AMId,ParameterValue=${AMId} --capabilities CAPABILITY_NAMED_IAM
 
 	aws cloudformation wait stack-create-complete --stack-name ${stackname}
    	echo "${stackname} creation  complete!"
    

fi '''