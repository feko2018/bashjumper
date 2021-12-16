#!/bin/bash
#
#

source base.sh
source colors.sh
direc=$(dirname $0)

main() {
  while [ True ]; do
    clear
    logo
    echo -e '         1) 输入 \033[0;32m l \033[m 显示所有主机.'
    echo -e '         2) 输入 \033[0;32m p \033[m 显示所有平台.'
    echo -e '         3) 输入 \033[0;32m h \033[m 显示帮助，也是回到首页.'
    echo -e '         4) 输入 \033[0;32m q或exit \033[m 退出跳板机.'
    read -p "选择操作： " action
    case "$action" in
    p)
      list_platform
      ;;
    l)
      list_all_hosts
      ;;
    h)
      continue
      ;;
    q|exit)
      color red "退出跳板机......"
      exit
      ;;
    *)
      color red "输入有误..."
      sleep 1
      ;;
    esac
    continue
  done
}
main