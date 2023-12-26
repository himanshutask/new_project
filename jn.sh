pipeline {
    agent any
 
    tools  {
          maven 'local_maven'

    }
    parameters {
         string (name: 'testjn' , defaultvalue: '192.168.0.50' , description: 'remote staging server')
    }

stages{
        stage(Build') {
            steps {
                sh 'mvn clean package'
            }
            post  {
                success  {
                    echo 'Archiving the artifacts'
                    archiveartifacts artifacrs: '**/target/*.war'
                 }
            }
       }
       stage ('Deployments') {
           parallel {
               stage  ("Deploy to Staging") {
                   steps {
                      sh "scp -v -o StrictHostChecking=no **/*.war root@${params.testjn}:/opt/testjnwebapps/"
                      }
                   }
               }
          }
     }

