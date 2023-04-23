# SQL Server 备份

SQL Server数据库备份

## 安装部署
+ 说明

使用方式在此不过多介绍，主要流程为：  
1、 打包成镜像  
2、 运行镜像  
3、 调用镜像中的API接口执行备份或恢复

+ 1、安装docker，如CentOS执行
```
yum install docker -y
systemctl start docker
```
+ 2、打包成镜像，以CentOS为例

```
cd /home
git clone https://github.com/JiaHaoL/SQLServerBackUp.git
cd SQLServerBackUp
docker build -t mssqlback:1.0 .
```

+ 3、运行镜像
```
# /app/home/SCApp/backDir 为容器中使用的存储目录
# /home/backDir 为宿主机存储目录，可自定义
# --network host 使用宿主机的网络，方便回调接口
docker run -d -p 8088:80 -v /home/backDir:/app/home/SCApp/backDir --name mssqlback --network host mssqlback:1.0
```

## 调用镜像中的API接口

### 数据备份

POST http://[IP]:[8088]/DbBackup/StartDbBackup

> Body 请求参数

```json
{
  "ServerInstance": "192.168.0.71",
  "port": "1433",
  "Username": "sa",
  "Password": "aaaaa",
  "DatabaseName": "master",
  "FileName": "20221.sql",
  "FilePath": "%2Fapp",
  "CallBackUri": "http%3A%2F%2F192.168.0.71%3A8084%2Fasd%2Fasd"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» ServerInstance|body|string| 是 |数据库IP地址|
|» port|body|string| 是 |数据库端口|
|» Username|body|string| 是 |数据库用户名|
|» Password|body|string| 是 |数据库密码|
|» DatabaseName|body|string| 是 |数据库名称|
|» FileName|body|string| 是 |备份文件名称，如 20230423.sql|
|» FilePath|body|string| 是 |数据库备份文件存储目录，建议直接使用[%2Fapp]|
|» CallBackUri|body|string| 是 |回调接口地址，备份完成后会调用此接口地址进行通知|

### 数据还原
POST http://[IP]:[8088]/DbBackup/DbRestore

> Body 请求参数

```json
{
  "ServerInstance": "192.168.1.11",
  "port": "1433",
  "Username": "sa",
  "Password": "aaa",
  "DatabaseName": "test",
  "FileName": "20221.sql",
  "FilePath": "%2Fapp"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» ServerInstance|body|string| 是 |数据库IP地址|
|» port|body|string| 是 |数据库端口|
|» Username|body|string| 是 |数据库用户名|
|» Password|body|string| 是 |数据库密码|
|» DatabaseName|body|string| 是 |数据库名称|
|» FileName|body|string| 是 |备份文件名称，如 20230423.sql|
|» FilePath|body|string| 是 |数据库备份文件存储目录|