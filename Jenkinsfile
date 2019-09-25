pipeline
{
agent any
environment 
{
    registry = "krmkumar/cicd_test"
    registryCredential = 'dockerhub'
}
//triggers {
	//cron('*/3 * * * *')
//}
tools { 
        maven 'jenkins-maven' 
        jdk 'jdk8' 
    }
options {
  buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '10', daysToKeepStr: '', numToKeepStr: '10')
  //retry(3)  
}
//parameters {
//	choice (name: 'Build_object', choices: ['clean', 'compile', 'package'], description: 'This is for proving maven build objects')
//}

stages
{
    stage ("Checkout")
    {
        steps
        {
            git branch:'master', url:'https://github.com/RajaKoppuravuri/stormpath-spring-boot-jpa-example.git', credentialsId:'GitHub'
        }
    }
    
	stage ("Initialize")
	{ 	
	steps 
		{
		 sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                    echo $env
                '''
		}
	}
	
	
	stage ("compile Code")
	{
	 steps {

	  //echo "selected options ${params.Build_object}"
	  
	  //	sh 	"mvn ${params.Build_object}"
      	sh 	"mvn package"
	  
	 } 
	}

    stage ("Build Docker image")
    {
        steps
        {
            script
            {
               
               dockerImage=docker.build("$registry:$BUILD_NUMBER")
            }
        }
    }

    stage ("Push Docker image to registry")
    {
        steps
        {
            script
            {
               docker.withRegistry( '', registryCredential ) 
               {
                    dockerImage.push()
               }
            }

        }
    }
    stage ("Delete image")
    {
        steps
        {
            script
            {
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}
post
{
	always
	{
		
		 cleanWs(
                cleanWhenAborted: false,
                cleanWhenFailure: false,
                cleanWhenNotBuilt: false,
                cleanWhenSuccess: false,
                cleanWhenUnstable: false,
                deleteDirs: false
            )
	}
}
}
