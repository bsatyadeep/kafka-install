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
sudo yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel
cat > /etc/profile.d/java8.sh <<EOF
export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
export PATH=\$PATH:\$JAVA_HOME/bin
export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib:\$JAVA_HOME/lib/tools.jar
EOF
source /etc/profile.d/java8.sh
cd /usr/local
wget "https://downloads.apache.org/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8-bin.tar.gz"
tar -xvf "apache-zookeeper-3.5.8-bin.tar.gz"

touch apache-zookeeper-3.5.8-bin/conf/zoo.cfg

echo "tickTime=2000" >> apache-zookeeper-3.5.8-bin/conf/zoo.cfg
echo "dataDir=/var/lib/zookeeper" >> apache-zookeeper-3.5.8-bin/conf/zoo.cfg
echo "clientPort=2181" >> apache-zookeeper-3.5.8-bin/conf/zoo.cfg
echo "initLimit=5" >> apache-zookeeper-3.5.8-bin/conf/zoo.cfg
echo "syncLimit=2" >> apache-zookeeper-3.5.8-bin/conf/zoo.cfg

i=1
while [ $i -le $2 ]
do
    echo "server.$i=$3:2888:3888" >> apache-zookeeper-3.5.8-bin/conf/zoo.cfg
    i=$(($i+1))
done

mkdir -p /var/lib/zookeeper

echo $(($1+1)) >> /var/lib/zookeeper/myid

apache-zookeeper-3.5.8-bin/bin/zkServer.sh start
