#! /usr/bin/env  bash


upgrade_system(){
    sudo apt-get  update
    sudo apt-get -y upgrade
    sudo apt-get -y install openssh-server git  lrzsz wget
}


install_sogou(){
    #搜狗输入法
    dpkg --status sogoupinyin &> /dev/null
    if [ $? -ne 0 ]; then
        wget -O sogou.deb  --tries 4  http://pinyin.sogou.com/linux/download.php?f=linux&bit=64 
        sudo dpkg  -i  sogou.deb
    else
        echo "跳过，已经安装了搜狗输入法"
    fi
}


install_jdk(){    
    #配置JDK
    if [ 0"$JAVA_HOME" = "0" ]; then
        wget http://172.18.112.106/jdk-8u121-linux-x64.tar.gz
        tar -zxf jdk-8u121-linux-x64.tar.gz
        echo 'export JAVA_HOME="$HOME/software/jdk1.8.0_121"' >> ~/.bashrc
        echo 'PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
        echo 'export JRE_HOME="$JAVA_HOME/jre"' >> ~/.bashrc
        echo 'PATH="$JRE_HOME/bin:$PATH"' >> ~/.bashrc
        sh ~/.bashrc
     else
        echo "跳过，已经安装了JDK"
    fi
}

install_flatpak(){
    apt show  flatpak &> /dev/null
    if [ $? -ne 0 ]; then
        sudo add-apt-repository ppa:alexlarsson/flatpak    
        sudo apt update
        sudo apt install  -y flatpak
        flatpak install --user --from https://download.mono-project.com/repo/monodevelop.flatpakref 
    else
        echo "跳过，已经安装了flatpak"
    fi
}

install_rider_ide(){
    file="/data/software/Rider-171.4089.265/bin/rider.sh"

    if [ ! -e "$file" ]; then 
        wget http://172.18.112.106/riderRS-171.4089.265.tar.gz
        tar -zxf riderRS-171.4089.265.tar.gz
    else
        echo "跳过，已经安装了Rider"
    fi
    nohup sh "$file"  &
}

repair_mono(){
    repair_aspnet
}

repair_aspnet(){
    #安装xsp,使得支持asp.net mvc开发
    dpkg --status mono-xsp4
    sleep 5
    if [ $? -ne 0 ]; then
        sudo apt-get  install -y mono-xsp 
    else
        "跳过，已经安装了xsp"
    fi

    #解决asp.net项目无法打开问题
    file="/usr/lib/mono/xbuild/Microsoft/VisualStudio/v14.0/WebApplications/Microsoft.WebApplication.targets"
    if [ ! -e "$file" ]; then 
        sudo  mkdir -p /usr/lib/mono/xbuild/Microsoft/VisualStudio/v14.0/WebApplications
        sudo wget -O "$file"  --tries 4 https://raw.githubusercontent.com/liu-rui/Shell/master/ubuntu/mono/Microsoft.WebApplication.targets    
    fi

    # 解决asp.net运行时出现权限问题
    file="/etc/mono/registry"
    if [ ! -e "$file" ]; then 
        sudo mkdir -p $file
        sudo  chmod  -R  go+rwx $file
    fi
} 


init(){

    if [ ! -e "/data" ]; then
        sudo mkdir -p /data
    fi
    user="$(whoami)"
    eval "sudo chown ${user}:${user} /data"

    if [ ! -e "/data/software" ]; then
        mkdir /data/software
        ln  -s /data/software  ~/software
    fi

    cd /data/software
}

main(){
    init
    upgrade_system
    install_sogou
    install_jdk
    install_flatpak    
    repair_mono

    echo "mono开发环境安装完成！"
    install_rider_ide
}


main