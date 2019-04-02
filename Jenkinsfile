pipeline
{
agent any
//triggers {
	//cron('*/3 * * * *')
//}
tools { 
        maven 'jenkins-maven' 
        jdk 'jdk8' 
    }
options {
  buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '10', daysToKeepStr: '', numToKeepStr: '10')
  retry(3)  
}
parameters {
	choice (name: 'Build_object', choices: ['clean', 'compile', 'package'], description: 'This is for proving maven build objects')
}

stages
{
    stage ("Checkout scm")
	{
		steps
		{
		   checkout scm
		}
	}
	stage ("Initialize")
	{ 	
	steps 
		{
		 sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
		}
	}
	
	
	stage ("build")
	{
	 steps {
		// bobject = "${params.Build_object}"
	  echo "selected options ${params.Build_object}"
	  //sh 'mvn clean compile package'
	  
	  	sh 	" mvn ${params.Build_object}"
	  
	 } 
	}
}
post
{
	always
	{
		//cleanWs cleanWhenSuccess: false
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
