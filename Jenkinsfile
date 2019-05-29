pipeline {
  agent any
  
  stages {
   
    stage ('terraform test') {
      steps {
      checkout scm
      sh 'terraform init'
      
      }
    }  
  }
}
