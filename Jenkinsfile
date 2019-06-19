pipeline {
	agent any
	stages {
		stage ('git') {
			steps {
				checkout([
					$class: 'GitSCM',
					branches: scm.branches,
					doGenerateSubmoduleConfigurations: false,
					extensions: scm.extensions + [[$class: 'SubmoduleOption', disableSubmodules: false, recursiveSubmodules: true, reference: '', trackingSubmodules: false]],
					submoduleCfg: [],
					userRemoteConfigs: scm.userRemoteConfigs])				
			}
			node {
				echo 'Pulling...' + env.BRANCH_NAME
			}
		}
	}
}
