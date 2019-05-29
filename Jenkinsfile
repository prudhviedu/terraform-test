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

    try {
      sh "export AWS_PROFILE='test-env'"
      sh "export AWS_REGION='us-east-1'"
      sh "terraform init"
      sh "echo 'yes' |terraform apply"
      sh "terraform output --json > test/verify/files/terraform.json"
      sh "inspec exec test/verify -t aws://eu-central-1"
      sh "echo 'yes' |terraform destroy"
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
