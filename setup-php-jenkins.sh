#!/bin/bash

cd /var/lib/jenkins

#get the php job template
sudo curl https://raw.githubusercontent.com/sebastianbergmann/php-jenkins-template/master/config.xml | java -jar jenkins-cli.jar -s http://localhost:8080 create-job php-template

#restart Jenkins for the template to be recognized
sudo java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart

#stop Jenkins
sudo /etc/init.d/jenkins stop

#download the latest war file to the /usr/share/jenkins/ directory
sudo wget -P /usr/share/jenkins/ http://mirrors.jenkins-ci.org/war/latest/jenkins.war

#start Jenkins
sudo /etc/init.d/jenkins start
