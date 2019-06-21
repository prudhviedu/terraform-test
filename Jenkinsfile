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
			environment {
				changes = sh(script: "build-support/check-effected.sh", returnStdout: true).trim()
			}
			when {
				expression { env.changes == null }
			}
			steps {
				echo "No changes found in Packer, Terraform and Ansible in this commit ${env.GIT_COMMIT} ..."
				script {
					currentBuild.result = 'SUCCESS'
				}
			}
		}
		stage ('test_cases_run') {
			steps {
				echo 'Running the test_cases'
				sh 'chmod u+x build-support/test_cases_run_non_master.sh;build-support/test_cases_run_non_master.sh ${BRANCH_NAME} ${GIT_COMMIT}'
			}
		}
	}
}
