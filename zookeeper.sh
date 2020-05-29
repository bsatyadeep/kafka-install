#!/bin/bash
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.tar.gz"
tar -xvf jdk-7*
mkdir /usr/lib/jvm
mv ./jdk1.7* /usr/lib/jvm/jdk1.7.0
update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.7.0/bin/java" 1
update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.7.0/bin/javac" 1
update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.7.0/bin/javaws" 1
chmod a+x /usr/bin/java
chmod a+x /usr/bin/javac
chmod a+x /usr/bin/javaws
log "Installing Java"
add-apt-repository -y ppa:webupd8team/java
apt-get -y update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
#apt-get -y install oracle-java7-installer
apt-get -y install openjdk-8-jdk openjdk-8-jre
cat >> /etc/environment <<EOL
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
EOL
cd /usr/local

wget "https://downloads.apache.org/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8.tar.gz"
tar -xvf "apache-zookeeper-3.5.8.tar.gz"

touch apache-zookeeper-3.5.8/conf/zoo.cfg

echo "tickTime=2000" >> apache-zookeeper-3.5.8/conf/zoo.cfg
echo "dataDir=/var/lib/zookeeper" >> apache-zookeeper-3.5.8/conf/zoo.cfg
echo "clientPort=2181" >> apache-zookeeper-3.5.8/conf/zoo.cfg
echo "initLimit=5" >> apache-zookeeper-3.5.8/conf/zoo.cfg
echo "syncLimit=2" >> apache-zookeeper-3.5.8/conf/zoo.cfg

i=1
while [ $i -le $2 ]
do
    echo "server.$i=$3:2888:3888" >> apache-zookeeper-3.5.8/conf/zoo.cfg
    i=$(($i+1))
done

mkdir -p /var/lib/zookeeper

echo $(($1+1)) >> /var/lib/zookeeper/myid

apache-zookeeper-3.5.8/bin/zkServer.sh start
