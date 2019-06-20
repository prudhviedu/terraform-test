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
				sh 'printenv'	
			}
		}
	}
}
