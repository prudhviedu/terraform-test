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
			steps {
				git_changed_dir = get_changed_dir()
				echo "changed directories are ${git_changed_dir}"
			}
		}
	}
}
