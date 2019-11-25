pipeline
{
agent any

parameters
{
  string defaultValue: '0.0.1-SNAPSHOT', description: 'Provide the artifact version', name: 'Arificat_version', trim: true
}
environment
{
    registry = "662738233441.dkr.ecr.us-east-2.amazonaws.com"
    registry_url = "https://662738233441.dkr.ecr.us-east-2.amazonaws.com"
    image_repo = "cicd_poc"
    registryCredential = 'ecr:us-east-2:ecr_cred'
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
            git branch:'ecs', url:'https://github.com/RajaKoppuravuri/stormpath-spring-boot-jpa-example.git', credentialsId:'GitHub'
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
      	sh 	"mvn clean compile package -Dartifact.version=${Arificat_version}"

	 }
	}

    stage ("Build Docker image")
    {
        steps
        {
            script
            {

               dockerImage=docker.build("$registry/$image_repo:$BUILD_NUMBER", "--build-arg artifact_version=${Arificat_version} .")
            }
        }
    }

    stage ("Push Docker image to registry")
    {
        steps
        {
            script
            { 
              sh("eval \$(aws ecr get-login --no-include-email --region us-east-2 | sed 's|https://||')")
               docker.withRegistry(registry_url, registryCredential )
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
                sh "docker rmi $registry/$image_repo:$BUILD_NUMBER"
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
