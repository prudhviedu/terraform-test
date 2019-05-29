node {
  checkout scm
  echo "code is cloned"
}

def go() {
    def git_hash = get_git_hash()
    def git_branch = get_git_branch()
    echo "current git sha is ${git_hash} and branch is ${git_branch}"

    // fetch the docker container used to run pants
    try {
      sh "export AWS_PROFILE='default'"
      sh "export AWS_REGION='us-east-1'"
      sh "terraoform init"
      sh "terraform plan"      
    } catch (e) {
      throw e
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
