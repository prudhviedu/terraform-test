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
		stage ('testing') {
			steps {
				script {
					for (i = 0; i < git_changes.size(); i++) {
        					def tool_name = env.git_changes[i]
						echo "changed tool name is ${tool_Name}"

                    				if (get_git_branch() != "master" && tool_name == "terraform") {
                        				stage ('Stage 1') {
                            					sh 'echo Stage 1'
                        				}
						}
                    			}
				}
			}
		}
	}
}
