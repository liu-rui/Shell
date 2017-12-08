#!/bin/bash

#      开发环境初始化脚本
#   配置了vim,vscode,java,docker和运维的一些工具
#   注意：只在ubuntu 18下测试通过
#
#  创建者 刘锐<1313475@qq.com>
#  github: https://github.com/liu-rui


function init(){
    shell_dir='/tmp/Shell'    

    if [ ! -d "$shell_dir" ]; then
        git clone https://github.com/liu-rui/Shell.git   $shell_dir    
    fi
}

function clear(){
    rm -fR $shell_dir
}

function apt_update(){
    sudo apt-get  update \
    && sudo apt-get -y upgrade    
}

function init_environment(){
    base_tag="base env"
    is_set $base_tag

    if [ $? -eq 0 ]; then
        return
    fi

    echo '
# --- '$base_tag' ---
export SOFTWARE_HOME="$HOME/software"
' >> ~/.bashrc
}


function install_base_packages(){
    sudo apt-get -y install openssh-server git lrzsz wget bash-completion
}

function init_vim_environment(){
    sudo apt-get -y install ctags xclip vim-gnome astyle python-setuptools

    if [ ! -f "~/.vim/bundle/Vundle.vim" ]; then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    if [ ! -f "~/.vimrc" ]; then
        cp $shell_dir/ubuntu/base/vim.sh ~/.vimrc
    fi    
    vim +PluginInstall +qall
}

function init_vscode_environment(){
    code  --version

    if [ $? -eq 0 ]; then
        echo "已经安装vscode"
        return
    fi

    if [ ! -f "code.deb" ]; then
        wget -O code.deb  --tries 4  https://go.microsoft.com/fwlink/?LinkID=760868
    fi

    sudo dpkg  -i  code.deb \
    && rm -fR code.deb \
    && mkdir -p ~/.config/Code/User \
    && cp $shell_dir/ubuntu/vscode/*  ~/.config/Code/User/

    extensions=("robertohuertasm.vscode-icons" 
                "PeterJausovec.vscode-docker"
                "wholroyd.jinja"
                "eriklynd.json-tools"
                "humao.rest-client"
                "DotJoshJohnson.xml"
                "adamvoss.yaml")

    for name in ${extensions[@]}
    do
        code --install-extension $name
    done

    code  --version
    echo_result "vscode"
}

function init_java_environment(){
    java_tag="java stack"
    is_set $java_tag

    if [ $? -eq 0 ]; then
        echo "已经设置java配置"
        return
    fi

    echo '
# --- '$java_tag' ---
export JAVA_HOME="$SOFTWARE_HOME/jdk"
export PATH="$JAVA_HOME/bin:$PATH"
export JRE_HOME="$JAVA_HOME/jre"
export PATH="$JRE_HOME/bin:$PATH"
export M2_HOME="$SOFTWARE_HOME/maven"
export MAVEN_HOME="$M2_HOME"
export PATH="$M2_HOME/bin:$PATH"
export MAVEN_OPTS="-Xms128m –Xmx512m "
export CATALINA_HOME="$SOFTWARE_HOME/tomcat"
' >> ~/.bashrc
}

function  install_docker(){
    install_docker_ce \
    && install_docker_compose \
    && install_docker_packages
    echo_result "docker"
}

#https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#set-up-the-repository
function  install_docker_ce(){
    sudo  docker --version

    if [ $? -eq 0 ]; then
        echo "已经安装docker-ce"
        return
    fi
    sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

    if [ ! -f "docker.deb" ]; then
        wget -O docker.deb  --tries 4  https://download.docker.com/linux/ubuntu/dists/artful/pool/edge/amd64/docker-ce_17.11.0~ce-0~ubuntu_amd64.deb
    fi
    sudo dpkg -i docker.deb \
    && rm -fR docker.deb \
    && sudo docker --version

    echo_result "docker-ce"
}

#https://docs.docker.com/compose/install/#install-compose
function  install_docker_compose(){
    sudo docker-compose --version

    if [ $? -eq 0 ]; then
        echo "已经安装docker_compose"
        return
    fi

    if [ ! -f "/usr/local/bin/docker-compose" ]; then
        sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
        && sudo chmod +x /usr/local/bin/docker-compose
    fi   

    if [ ! -f "/etc/bash_completion.d/docker-compose" ]; then
        sudo curl -L https://raw.githubusercontent.com/docker/compose/1.17.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
    fi

    sudo docker-compose --version
    echo_result "docker_compose"
}

function install_docker_packages(){
    install_ctop \
    && install_dockerize
}

#https://github.com/bcicen/ctop/blob/master/README.md
function install_ctop(){
    sudo ctop -v

    if [ $? -eq 0 ]; then
        echo "已经安装ctop"
        return
    fi
    ctop_version="0.6.1"

    sudo wget -O /usr/local/bin/ctop --tries 4  https://github.com/bcicen/ctop/releases/download/v$ctop_version/ctop-$ctop_version-linux-amd64 \
    && sudo chmod +x /usr/local/bin/ctop \
    && sudo ctop -v

    echo_result "ctop"
}

#https://github.com/jwilder/dockerize
function install_dockerize(){
    sudo dockerize --version

    if [ $? -eq 0 ]; then
        echo "已经安装dockerize"
        return
    fi
    dockerize_version="v0.6.0"    

    if [ ! -f "dockerize.tar.gz" ]; then
        sudo wget  -O dockerize.tar.gz --tries 4 https://github.com/jwilder/dockerize/releases/download/$dockerize_version/dockerize-linux-amd64-$dockerize_version.tar.gz 
    fi
    sudo tar -C /usr/local/bin -xzvf dockerize.tar.gz \
    && sudo rm dockerize.tar.gz &&
    sudo dockerize --version

    echo_result "dockerize"
}


function install_ope_packages(){
    sudo apt-get -y install  apache2-utils ansible telnet

    ope_tag="ope stack"
    is_set $ope_tag

    if [ $? -eq 0 ]; then
        echo "已经设置运维配置"
        return
    fi
    echo '
# --- '$ope_tag' ---
export CRT_HOME="$SOFTWARE_HOME/scrt"
' >> ~/.bashrc
}

function is_set(){
    grep $1 ~/.bashrc >> /dev/null
}

function echo_result(){
     if [ $? -eq 0 ]; then
        echo "安装$1  successed!"
        return 0
    else
        echo "安装$1  failed!"
        return 1
    fi
}


function main(){
    init \
    && apt_update \
    && init_environment \
    && install_base_packages \
    && init_vim_environment \
    && init_vscode_environment \
    && init_java_environment \
    && install_docker \
    && install_ope_packages \
    && clear

    if [ $? -eq 0 ]; then
        echo "恭喜！环境已经初始化完成"
    else
        echo "很抱歉，环境初始化失败"
    fi
}

main