脚本环境：
Apache_zookeeper-3.6.1
Kafka_2.12-2.5.0(新版本Kafka不依赖Zookeeper，因此不适合新版本kafka)

Ps: 如果出现一下内容
Syntax error: "elif" unexpected (expecting "then")

则需要在命令命令终端中执行一下内容
sed -i 's/\r//' *.sh