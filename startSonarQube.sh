#!/bin/sh

echo "-----> Making java available"
export PATH=$PATH:/home/vcap/app/.java/bin

echo "-----> Setting sonar.properties"
echo "       sonar.web.port=${PORT}"
echo "\n ------- The following properties were automatically created by the buildpack -----\n" >> ./sonar.properties
echo "sonar.web.port=${PORT}\n" >> ./sonar.properties

# Replace all environment variables with syntax ${MY_ENV_VAR} with the value
# thanks to https://stackoverflow.com/questions/5274343/replacing-environment-variables-in-a-properties-file
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' ./sonar.properties > ./sonar_replaced.properties
mv ./sonar_replaced.properties ./sonar.properties

echo "------------------------------------------------------" > /home/vcap/app/sonarqube/logs/sonar.log



echo "-----> set vm max map count"
#echo "vm.max_map_count=262144" >> /etc/sysctl.d/99-sysctl.conf
#echo "fs.file-max=65536" >> /etc/sysctl.d/99-sysctl.conf
#sudo sysctl vm.max_map_count
#sudo sysctl fs.file-max

#echo "vm.max_map_count=262144" >> /etc/sysctl.conf
#echo "fs.file-max=65536" >> /etc/sysctl.conf

#sudo sysctl -w vm.max_map_count=262144
#sudo sysctl -w fs.file-max=65536
#ulimit -n 65536
#ulimit -u 4096

echo "-----> Starting SonarQube"

/home/vcap/app/sonarqube/bin/linux-x86-64/sonar.sh start

sleep 30

echo "-----> set vm max map count after"
sysctl vm.max_map_coun
sysctl fs.file-max

sudo sysctl vm.max_map_count
sudo sysctl fs.file-max


echo "-----> Tailing log"
sleep 10 # give it a bit of time to create files
cd /home/vcap/app/sonarqube/logs
tail -f ./sonar.log ./es.log ./web.log ./ce.log ./access.log



#echo "-----> set discovery.type: single-node and restart"
#echo "discovery.type: single-node" >> /home/vcap/app/sonarqube/temp/conf/es/elasticsearch.yml
#/home/vcap/app/sonarqube/bin/linux-x86-64/sonar.sh restart

