pipeline {
	agent any
	stages {
		stage ('git') {
			steps {
				checkout scm
				echo "curren branch is ${BRANCH_NAME} and git SHA ${GIT_COMMIT} and ${env.GIT_COMMIT}"
			}
		}
	}
}
