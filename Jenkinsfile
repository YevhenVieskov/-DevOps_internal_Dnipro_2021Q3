// Jenkinsfile
String credentialsId = 'awsCredentials'
properties([pipelineTriggers([githubPush()])])
pipeline {
  
  environment {
    tf_s3              = 'infrastructure/s3_tfstate'
    iac                = './iac'     
    plan_file          = 'plan.tfplan'
    AWS_DEFAULT_REGION ="us-east-2"        
  }

  agent any
  options {
    disableConcurrentBuilds()
  }

  stages{

    stage("Checkout") {
      steps {
        git credentialsId: 'github-ssh-key', url: 'https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git', branch: 'main'

      }
    }
    
    stage('Tools versions') {
      steps {
        sh '''
          terraform --version
          aws --version          
          docker --version
        '''
      }
    }

    stage('Initialisation network and security related infrastructure with TF') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'vieskovtf', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          sh '''
            echo "#---> Initialisation and validation network infrastructure with TF..."
            cd ${WORKSPACE}/$iac
            terraform init && terraform validate
            
          '''
        }
      }
    }

    stage('Create network and security related infrastructure with TF') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'vieskovtf', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          sh '''
            echo "#---> Create network and security network infrastructure with TF..."
            cd ${WORKSPACE}/$iac            
            terraform apply -target aws_route53_zone.main
            #terraform plan -out=$plan_file -var "aws_region=${AWS_DEFAULT_REGION}" \
            #  -var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
	        #    -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}"
            terraform apply  #-input=false $plan_file
          '''
        }
      }
    }
    
    stage("Approve") {
      steps { approve('Do you want to destroy your infrastructure?') }
		}

    stage('Destroy network and security related infrastructure with TF') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'vieskovtf', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          sh '''
            echo "#---> Destroy network and security related infrastructure with TF..."
            cd ${WORKSPACE}/$iac
            terraform init && terraform validate
            terraform plan -out=$plan_file -var "aws_region=${AWS_DEFAULT_REGION}" \
              -var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
	            -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}"
            terraform destroy -input=false $plan_file
          '''
        }
      }
    } //stage destroy  

  }  //stages   

} //pipeline




/*

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
try {
  stage('checkout') {
    node {
      cleanWs()
      checkout scm
    }
  }

  // Run terraform init
  stage('init') {
    node {
      withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: credentialsId,
        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
      ]]) {
        ansiColor('xterm') {
          sh 'terraform init'
        }
      }
    }
  }

  // Run terraform plan
  stage('plan') {
    node {
      withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: credentialsId,
        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
      ]]) {
        ansiColor('xterm') {
          sh 'terraform plan'
        }
      }
    }
  }

  if (env.BRANCH_NAME == 'master') {

    // Run terraform apply
    stage('apply') {
      node {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: credentialsId,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh 'terraform apply -auto-approve'
          }
        }
      }
    }

    // Run terraform show
    stage('show') {
      node {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: credentialsId,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh 'terraform show'
          }
        }
      }
    }
  }
  currentBuild.result = 'SUCCESS'
}
catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException flowError) {
  currentBuild.result = 'ABORTED'
}
catch (err) {
  currentBuild.result = 'FAILURE'
  throw err
}
finally {
  if (currentBuild.result == 'SUCCESS') {
    currentBuild.result = 'SUCCESS'
  }
}

*/


