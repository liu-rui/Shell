#!/bin/sh

apt_update(){
    sudo apt-get  update
    sudo apt-get -y upgrade
    sudo apt-get -y install openssh-server git  lrzsz wget bash-completion
}

init_base_environment(){
    #下载包
    git clone https://github.com/liu-rui/Shell.git
    cd Shell/ubuntu
    #搜狗输入法
    wget -O sogou.deb  --tries 4  http://pinyin.sogou.com/linux/download.php?f=linux&bit=64 
    sudo dpkg  -i  sogou.deb

    #mariadb
    sudo apt-get -y install mariadb-server  mysql-workbench
    sudo systemctl disable mysql
    
}

init_vim_environment(){
    sudo apt-get -y install ctags xclip vim-gnome astyle python-setuptools
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim  
    cp base/vim.sh ~/.vimrc
    vim +PluginInstall +qall
}

init_vscode_environment(){    
    wget -O code.deb  --tries 4  https://go.microsoft.com/fwlink/?LinkID=760868
    sudo dpkg  -i  code.deb
    mkdir -p ~/.config/Code/User    
    cp vscode/*  ~/.config/Code/User/
    
    #安装vscode默认环境插件
    code --install-extension robertohuertasm.vscode-icons
}

init_python_environment(){
    sudo  apt-get -y install libc6-dev gcc make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev git libsqlite3-dev wget curl llvm
    git clone https://github.com/yyuu/pyenv.git ~/.pyenv 
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc    
    git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv 
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
    sh ~/.bashrc
    pyenv install  3.5.3 -v
    pyenv  virtualenv 3.5.3  dev3.5.3
    pyenv global  dev3.5.3

    #为vscode配置python环境
    python -m  pip  install --upgrade pip
    python -m  pip  install flake8
    python -m  pip  install pylint
    python -m  pip  install autopep8
    code --install-extension donjayamanne.python

    #安装python常用库
    pip install jinja2
    pip install nose
    pip install flask
    pip install sqlalchemy
    pip install cookiecutter

    pip install thefuck
    echo 'eval "$(thefuck --alias fuck)"'  >> ~/.bashrc
    sh ~/.bashrc
} 

init_go_environment(){
    sudo  apt-get -y install golang-go golang-golang-x-tools        
    sudo mkdir -p /data
    user="$(whoami)"
    eval "sudo chown ${user}:${user} /data"
    mkdir -p  /data/code/go/src
    echo 'export GOPATH="/data/code/go"' >> ~/.bashrc
    echo 'PATH="$GOPATH/bin:$PATH"' >> ~/.bashrc
    sh ~/.bashrc       
    
    #为vscode配置go环境
    tar zxvf go/go_package.tar.gz  -C "$GOPATH/src/"    
    go install -v github.com/nsf/gocode
    go install -v github.com/rogpeppe/godef
    go install -v github.com/zmb3/gogetdoc
    go install -v github.com/golang/lint/golint
    go install -v github.com/lukehoban/go-outline
    go install -v sourcegraph.com/sqs/goreturns
    go install -v golang.org/x/tools/cmd/gorename
    go install -v github.com/tpng/gopkgs
    go install -v github.com/newhook/go-symbols
    go install -v golang.org/x/tools/cmd/guru    
    go install -v github.com/cweill/gotests/...
    cd $GOPATH/src/github.com/derekparker/delve
    make install
    cd -
    code --install-extension lukehoban.Go    

    #安装go常用库
    go get -u -v github.com/astaxie/beego
    go get -u -v github.com/beego/bee
}

init_nodejs_environment(){
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
    sh .bashrc
    nvm  install node
    nvm  use node
    npm config set registry https://registry.npm.taobao.org
    npm install gulp --global

    code --install-extension abusaidm.html-snippets
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension msjsdiag.debugger-for-chrome
}

init_java_environment(){
    #配置JDK
    echo 'export JAVA_HOME="$HOME/software/jdk1.8.0_121"' >> ~/.bashrc
    echo 'PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
    echo 'export JRE_HOME="$JAVA_HOME/jre"' >> ~/.bashrc
    echo 'PATH="$JRE_HOME/bin:$PATH"' >> ~/.bashrc
    sh ~/.bashrc 

    #安装maven
    wget -O maven.tar.gz  --tries 4  http://apache.fayea.com/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
    tar -C ~/.maven -zxvf apache-maven-3.3.9-bin.tar.gz
    echo 'export M2_HOME="$HOME/.maven/apache-maven-3.3.9"' >> ~/.bashrc
    echo 'PATH="$M2_HOME/bin:$PATH"' >> ~/.bashrc
    echo 'export MAVEN_OPTS="-Xms128m –Xmx512m "' >> ~/.bashrc
    sh ~/.bashrc 
    cp java/maven.config.xml $M2_HOME/config/settings.xml
    #配置maven创建项目时使用本地配置达到加快创建效果
    mkdir -p $HOME/.m2
    wget -O $HOME/.m2/archetype-catalog.xml  --tries 4 http://repo1.maven.org/maven2/archetype-catalog.xml

    #配置tomcat
    echo 'export CATALINA_HOME="$HOME/software/apache-tomcat-8.5.11"' >> ~/.bashrc
    sh ~/.bashrc 
}


init_mono_environment(){
    mkdir  -p /data/software
    cd /data/software    
    sudo add-apt-repository ppa:alexlarsson/flatpak    
    sudo apt update
    sudo apt install  -y flatpak
    flatpak install --user --from https://download.mono-project.com/repo/monodevelop.flatpakref    
    #配置asp.net运行环境
    # sudo apt-get install -y  libtool-bin
    # wget -O xsp.tar.gz  --tries 4 https://github.com/mono/xsp/archive/4.4.tar.gz -C    
    # tar -zxf  xsp.tar.gz 
    # cd xsp-4.4
    # ./configure --prefix=/usr/lib/mono/xsp
	# make 
	# sudo make install
    # sudo ln -s /usr/lib/mono/xsp/bin/xsp4  /usr/lib/mono/4.5/xsp4.exe
    sudo apt-get  install -y mono-xsp
    sudo  chmod  -R  +w /etc/mono
    wget http://172.18.112.106/riderRS-171.3655.1246.tar.gz
    tar -zxf riderRS-171.3655.1246.tar.gz
}


main(){
    echo -e "\033[31m 这个是ubuntu开发环境初始化脚本，请慎重运行！ press ctrl+C to cancel \033[0m"
    sleep 5

    apt_update
    init_base_environment
    init_vim_environment
    init_vscode_environment
    init_python_environment
    init_go_environment
    init_nodejs_environment
    init_java_environment
}

main