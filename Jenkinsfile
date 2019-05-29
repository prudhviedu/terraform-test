pipeline {
  agent any
  node {
    checkout scm
  }
  stages {
   
    stage ('terraform test') {
      steps {
        sh 'terraform init'
      
      }
    }  
  }
}
