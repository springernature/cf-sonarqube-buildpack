#!/bin/sh

echo "-----> Making java available"
export PATH=$PATH:/home/vcap/app/.java/bin

echo "-----> Setting sonar.properties"
echo "       sonar.web.port=${PORT}"
echo "sonar.web.port=${PORT}" >> ./sonar.properties

echo "------------------------------------------------------" > /home/vcap/app/sonarqube/logs/sonar.log

echo "-----> Starting SonarQube"

/home/vcap/app/sonarqube/bin/linux-x86-64/sonar.sh start

echo "-----> Tailing log"
tail -f /home/vcap/app/sonarqube/logs/sonar.log
