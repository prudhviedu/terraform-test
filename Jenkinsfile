pipeline {
	agent any
	stages {
		stage ('checkout') {
			steps {
				checkout scm
				echo "current git sha is ${BRANCH_NAME} and branch is ${GIT_COMMIT}"
			}
		}
		stage ('check_changes') {
			steps {
				sh 'sh build-support/check-effected.sh'
			}
		}
	}
}
