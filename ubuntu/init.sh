apt_update(){
    sudo  apt-get  update
    sudo  apt-get  upgrade
}

init_vim_environment(){
    sudo apt-get install ctags xclip vim-gnome astyle python-setuptools
}

init_python_environment(){

}

init_go_environment(){

}

init_nodejs_environment(){

}


main(){
    if [[ "$(whoami)" != "root" ]]; then
        echo "please run this script as root ." >&2
        exit 1
    fi
    echo -e "\033[31m 这个是ubuntu开发环境初始化脚本，请慎重运行！ press ctrl+C to cancel \033[0m"
    sleep 5

    apt_update
    init_python_environment
    init_go_environment
    init_nodejs_environment
}

main