FROM ubuntu:16.04

# vs--- sudo is not installed by default for ubuntu:16 
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y wget git curl
RUN apt-get update && apt-get install -y openjdk-8-jdk
RUN apt-get update && apt-get install -y maven ant ruby rbenv make
# vs--- https is not installed by default for ubuntu:16
RUN apt-get install apt-transport-https
RUN wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
RUN echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
RUN apt-get update && apt-get install -y jenkins
RUN mkdir -p /var/jenkins_home && chown -R jenkins /var/jenkins_home
ADD init.groovy /tmp/WEB-INF/init.groovy
RUN apt-get install -y zip && cd /tmp && zip -g /usr/share/jenkins/jenkins.war WEB-INF/init.groovy
USER jenkins

# VOLUME /var/jenkins_home - bind this in via -v if you want to make this persistent.
ENV JENKINS_HOME /var/jenkins_home

# for main web interface:
EXPOSE 8080 

# will be used by attached slave agents:
EXPOSE 50000 
CMD ["/usr/bin/java",  "-jar",  "/usr/share/jenkins/jenkins.war"]