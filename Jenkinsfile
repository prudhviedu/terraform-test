stage name: 'Terraform Apply&Test'
node {
  checkout scm
  if (fileExists('SKIP_BUILD')) {
    echo "Located SKIP_BUILD in project's main folder. Skipping the build right away."
  } else {
    go()
  }
}

def go() {
    def git_hash = get_git_hash()
    def git_branch = get_git_branch()
    echo "current git sha is ${git_hash} and branch is ${git_branch}"
    echo "Running the check to see which files got effected"
    def git_changed_dir = get_changed_dir()
    echo "changed directories are ${git_changed_dir}"
    for (i = 0; i < git_changed_dir.size(); i++) {
        def tool_name = git_changed_dir[i]
        if (tool_name.trim() != "") {

                if ( get_git_branch() != "master" && tool_name == "packer") {
                        try {
                                echo "Running PACKER"
				run_packer()
                        } catch (e) {
                                throw e
                        }
                        try {
                                echo "Running Terraform"
				run_terraform()
                        } catch (e) {
                                throw e
                        }
                        try {
                                echo "Running Ansible"
				run_ansible()
                        } catch (e) {
                                throw e
                        }
			break;
                } else if ( get_git_branch() != "master" && tool_name == "terraform" ) {
			try {
                        	echo "Running Terraform"
				run_terraform()
			} catch (e) {
			        throw e
			}
                        try {   
                                echo "Running Ansible"
				run_ansible()
                        } catch (e) { 
                                throw e       
                        }    			
                        break;
                } else if ( get_git_branch() != "master" && tool_name == "ansible" ) {
                        try {
                                echo "Running Ansible"
				run_ansible()
                        } catch (e) {
                                throw e
                        }
                        break;
                } else {
                        echo "There was no change in packer, terraform and ansible related code... no build process..."
		}
            }
        }
}


def get_git_hash() {
    sh "git rev-parse HEAD > githash"
    readFile("githash").replace("\n", "")
}

def get_git_branch() {
    sh "echo ${env.JOB_NAME} | cut -d/ -f 2 > gitbranch"
    readFile("gitbranch").replace("\n", "")
}

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

def run_packer() {
   sh "build-support/run_packer.sh"
}

def run_terraform() {
   sh "build-support/run_terraform.sh"
}

def run_ansible() {
   sh "build-support/run_ansible.sh"
}
