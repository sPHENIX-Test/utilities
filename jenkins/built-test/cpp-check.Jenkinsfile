pipeline 
{
	agent any
    
//    environment { 
//        JenkinsBase = 'jenkins/test/'
//    }
       
	stages { 
		stage('Initialize') 
		{
			
            
			steps {
				timestamps {
					ansiColor('xterm') {
						
						slackSend (color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
										
						build(job: 'github-comment-label',
		    			parameters:
		    			[
		    				string(name: 'ghprbPullLink', value: "${ghprbPullLink}"), 
			    			string(name: 'LabelCategory', value: "cpp-check"),
			    			string(name: 'LabelStatus', value: "PENDING")
			    		],
		    			wait: false, propagate: false)
						
						script {
						
							currentBuild.displayName = "${env.BUILD_NUMBER} - ${sha_coresoftware}"
							currentBuild.description = "${upstream_build_description} / <a href=\"${git_url_coresoftware}\">coresoftware</a> # ${sha_coresoftware}" 
							
						}
										
						dir('coresoftware') {
							deleteDir()
						}
						dir('report') {
							deleteDir()
						}
						sh('rm -fv cppcheck-result.xml')
					
						sh('hostname')
						sh('pwd')
						sh('env')
						sh('ls -lvhc')

					}
				}
			}
		}

		stage('Git Checkout')
		{
			
			steps 
			{
				timestamps { 
					ansiColor('xterm') {
						
						dir('coresoftware') {
							// git credentialsId: 'sPHENIX-bot', url: 'https://github.com/sPHENIX-Collaboration/coresoftware.git'
							
							checkout(
								[
						 			$class: 'GitSCM',
						   		extensions: [               
							   		[$class: 'CleanCheckout'],     
							     	[
							   			$class: 'PreBuildMerge',
							    		options: [
											mergeRemote: 'origin',
							  			mergeTarget: "$mergeTarget_coresoftware"
							  			]
							    	],
						   		],
							  	branches: [
							    	[name: "${sha_coresoftware}"]
							    ], 
							  	userRemoteConfigs: 
							  	[[
							    	//credentialsId: 'sPHENIX-bot', url: 'https://github.com/sPHENIX-Collaboration/coresoftware.git'
							     	credentialsId: 'sPHENIX-bot', 
							     	url: '${git_url_coresoftware}',
							     	refspec: ('+refs/pull/*:refs/remotes/origin/pr/* +refs/heads/master:refs/remotes/origin/master'), 
							    	branch: ('*')
							  	]]
								] //checkout
							)//checkout
						}//						dir('coresoftware') {
						
					}
				}
			}
		}//stage('SCM Checkout')
		
		// hold this until jenkins supports nested parallel
		//stage('Build')
		//{
		//	parallel {
			
				stage('cpp-check')
				{
					steps 
					{
						
						sh ('/usr/bin/singularity exec -B /var/lib/jenkins/singularity/cvmfs:/cvmfs -B /gpfs -B /direct -B /afs -B /sphenix /var/lib/jenkins/singularity/cvmfs/sphenix.sdcc.bnl.gov/singularity/rhic_sl7_ext.simg tcsh -f utilities/jenkins/built-test/cpp-check.sh')

		   		}
				}// Stage - cpp check
				 
				
					    
								stage('cpp-check-analysis')
								{
									
									steps 
									{
										archiveArtifacts artifacts: 'cppcheck-result.xml'
										// 	def buildana = scanForIssues tool: gcc4(pattern: 'build/${build_type}/rebuild.log')
        						//	publishIssues issues: [buildana]
        						recordIssues enabledForFailure: true, tool: cppCheck(pattern: 'cppcheck-result.xml')
									}										
								} // 				stage('sPHENIX-Build')
	}//stages
		
	post {
		always{
		  
			dir('report')
			{
				sh('ls -lvhc')
			  writeFile file: "cpp-check.md", text: "* [![Build Status ](https://web.racf.bnl.gov/jenkins-sphenix/buildStatus/icon?job=${env.JOB_NAME}&build=${env.BUILD_NUMBER})](${env.BUILD_URL}) cpp-check on coresoftware [is ${currentBuild.currentResult}](${env.BUILD_URL}), [:bar_chart:cppcheck report](${env.BUILD_URL}/cppcheck/)"				
			}
		  		  
			archiveArtifacts artifacts: 'report/*.md'
		
		}
	
		success {
		
			build(job: 'github-comment-label',
			  parameters:
			  [
					string(name: 'ghprbPullLink', value: "${ghprbPullLink}"), 
					string(name: 'LabelCategory', value: "cpp-check"),
					string(name: 'LabelStatus', value: "AVAILABLE")
				],
				wait: false, propagate: false)
		
			slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
		}
		failure {
		
			build(job: 'github-comment-label',
			  parameters:
			  [
					string(name: 'ghprbPullLink', value: "${ghprbPullLink}"), 
					string(name: 'LabelCategory', value: "cpp-check"),
					string(name: 'LabelStatus', value: "FAIL")
				],
				wait: false, propagate: false)
		
			slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
		}
		unstable {
		
			build(job: 'github-comment-label',
			  parameters:
			  [
					string(name: 'ghprbPullLink', value: "${ghprbPullLink}"), 
					string(name: 'LabelCategory', value: "cpp-check"),
					string(name: 'LabelStatus', value: "AVAILABLE")
				],
				wait: false, propagate: false)
				
			slackSend (color: '#FFF000', message: "UNSTABLE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
		}
	}
	
}//pipeline 

