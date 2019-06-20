pipeline {
	agent any
	stages {
		stage ('git') {
			steps {
				checkout scm
				echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL} ${env.BRANCH_NAME}"
			}
		}
		stage ('echo') {
			steps {
				sh 'echo ${BRANCH_NAME}'
			}
		
		}
	}
}
