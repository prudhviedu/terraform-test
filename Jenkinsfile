def get_changed_dir() {
    sh "build-support/check-effected.sh > effected_dir"
    readFileIntoLines("effected_dir")
}
def readFileIntoLines(filename) {
    def contents = readFile(filename)
    if (contents.trim() == "") {
        return []
    } else {
        return contents.split("\n")
    }
}

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
				git_changes = get_changed_dir()
			}

			steps {
				echo "changes deducted in ${env.git_changes}"
			}
		}
		stage ('test_cases_run') {
			steps {
				echo 'Running the test_cases'
				sh 'chmod u+x build-support/test_cases_run.sh; build-support/test_cases_run.sh ${BRANCH_NAME} ${GIT_COMMIT}'
			}
		}
	}
}
