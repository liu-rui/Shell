# Linux 环境初始化
> 目前包括centos和ubuntu

### 1. centos 
> centos作为生产环境使用，此初始化脚本已在centos7.2上经过验证

#### 1. 使用
```shell
wget  https://raw.githubusercontent.com/liu-rui/Shell/master/centos/centos7/init.sh
sudo sh init.sh
```

#### 2. 功能
- yum源使用阿里云
- 时间定时同步
- 优化内核


### 2. ubuntu 
> ubuntu作为日常开发环境使用，此初始化脚本已在Ubuntu18上经过验证

#### 1. 使用

```shell
curl -s https://raw.githubusercontent.com/liu-rui/Shell/master/ubuntu/ghost.sh | sudo sh bash
```