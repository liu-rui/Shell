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
- 时区自动同步
- 优化内核


### 2. ubuntu 
> ubuntu作为日常开发环境使用，此初始化脚本已在Ubuntu16.4上经过验证

#### 1. 使用

```shell
wget https://raw.githubusercontent.com/liu-rui/Shell/master/ubuntu/init.sh
sh init.sh
```

#### 2. 功能
- 升级apt
- 安装搜狗输入法
- 优化vim,使得更容易使用
- 安装vscode
- 配置python环境，支持多版本并存（pyenv）
- 配置golang环境,安装常用库，如beego等
- 配置nodejs环境





