#!/bin/bash
#
#
source colors.sh
direc=$(dirname $0)                  ##当前路径
platformfile="$direc/platform.txt"   ##平台列表
hostsfile="$direc/hosts.txt"         ##主机列表
user="root"               ##默认root用户
keys="/root/.ssh/id_rsa"  ##默认私钥


###创建平台和主机示例文件
if [ ! -f $platformfile ];then
  echo "#平台" >> ${platformfile}
  echo "4499" >> ${platformfile}
  echo "7878" >> ${platformfile}
fi
if [ ! -f $hostsfile ];then
  touch $hostsfile
  echo '#主机名  平台   类型   主机ip           端口  备注' >> ${hostsfile}
  echo 'test-001 4499   web    192.168.31.170    22   web服务器' >> ${hostsfile}
  echo 'test-002 7878   web    192.168.31.161    22   无' >> ${hostsfile}
  echo 'test-003 7878   web    127.0.0.1         22     ' >> ${hostsfile}
fi


##显示平台
function list_platform(){
while [ True ]; do
array_platform=()
return_status=''
      clear
      if [  ! -s ${platformfile} ];then
         color red "平台列表是空的，返回首页......"
         sleep 2
         break
      fi
      cat -n  ${platformfile}| bash  draw_table.sh -3 -red,-white,-blue
      echo -e "1) 输入 \033[0;32m 数字或平台 \033[m 进入对应平台的主机列表."
      echo -e '2) 输入 \033[0;32m h \033[m 显示帮助，也是回到首页.'
      echo -e '3) 输入 \033[0;32m q或exit \033[m 退出跳板机.'
      ind=1
      while read line
      do
        array_platform[$ind]=$line
        ((ind++))
      done <  ${platformfile}
      read -p '选择平台序号>> ' keyword
      case $keyword in
      h)
        ##帮助，也是回到首页
        break
        ;;
      q|exit)
      color red "退出跳板机......"
      exit
      ;;
      *)##通配平台名
     if [  -z  $keyword ];then
          color red "输入有误，请输入对应平台的序号，等待2秒......"
          sleep 2
          continue
        fi
        let "num=${#array_platform[@]}+1" ##数组下标从1开始
        for i in $(seq 1 $num)
        do
          platform=$(echo "${array_platform[$i]}" |awk '{print $1}')
          if [[ "$keyword" = "$platform" ]];then
              list_single_platform_hosts "$platform"
              break
          elif [[ $keyword -gt 1 && $keyword -le ${#array_platform[@]} ]]; then
              platform=$(echo "${array_platform[$keyword]}" |awk '{print $1}')
              list_single_platform_hosts "$platform"
              break
          fi
        done
      ;;
    esac
done
}

##显示单个平台的机器
function list_single_platform_hosts(){
platform=$1
while [ True ]; do
array_hosts=()
      clear
      cat   ${hostsfile}|awk  '(NR==1)||($2 == pfx) {print}' pfx=$platform|cat -n|bash  draw_table.sh -3 -red,-white,-blue
      echo -e "1) 输入 \033[0;32m 数字或主机名或ip \033[m 进行跳到对应的主机."
      echo -e '2) 输入 \033[0;32m p \033[m 显示平台.'
      echo -e '3) 输入 \033[0;32m h \033[m 显示帮助，也是回到首页.'
      echo -e '4) 输入 \033[0;32m q或exit \033[m 退出跳板机.'
      ind=1
      while read line
      do
          if [[ $ind -eq 1 || `echo $line|grep -w "$platform"|wc -l` -eq 1 ]];then
            array_hosts[$ind]=$line
            ((ind++))
          fi
      done <  ${hostsfile}
      read -p '选择主机序号>> ' keyword
      case $keyword in
      [0-9] | [1-9][0-9] | [1-9][0-9][0-9])
        #是数字，按照序号搜索
        if [[ $keyword -lt 2 || $keyword -gt  ${#array_hosts[@]} ]];then
            color red "输入有误，请输入对应主机的序号，等待2秒......"
            sleep 2
            continue
        else
          ip=$(echo "${array_hosts[$keyword]}" |awk '{print $4}')
          port=$(echo "${array_hosts[$keyword]}" |awk '{print $5}')
          jump_to_ssh $ip $port
          continue
        fi
      ;;
      h)
        ##帮助，也是回到首页
        break 3;
        ;;
      p)
        ##帮助，也是回到首页
        break
        ;;
      q|exit)
      color red "退出跳板机......"
      exit
      ;;
      *)##通配主机名和ip
        if [  -z  $keyword ];then
          color red "输入有误，请输入对应主机的序号，等待2秒......"
          sleep 2
          continue
        fi
        let "num=${#array_hosts[@]}+1" ##数组下标从1开始
        for i in $(seq 1 $num)
        do
          name=$(echo "${array_hosts[$i]}" |awk '{print $1}')
          ip=$(echo "${array_hosts[$i]}" |awk '{print $4}')
          port=$(echo "${array_hosts[$i]}" |awk '{print $5}')
          if [[ "$keyword" = "$name" || "$keyword" = "$ip"  ]];then
              jump_to_ssh $ip $port
              break
          fi
        done
      ;;
    esac
done
}



##显示全部主机
function list_all_hosts(){
while [ True ]; do
array_hosts=()
      clear
      if [  ! -s ${hostsfile} ];then
        color red "主机列表是空的，返回首页......"
        sleep 2
        break
      fi
      cat -n  ${hostsfile}|bash  draw_table.sh -3 -red,-white,-blue
      echo -e "1) 输入 \033[0;32m 数字或主机名或ip \033[m 进行跳到对应的主机."
      echo -e '2) 输入 \033[0;32m h \033[m 显示帮助，也是回到首页.'
      echo -e '3) 输入 \033[0;32m q或exit \033[m 退出跳板机.'
      ind=1
      while read line
      do
          array_hosts[$ind]=$line
          ((ind++))
      done <  ${hostsfile}
      read -p '选择主机序号>> ' keyword
      case $keyword in
      [0-9] | [1-9][0-9] | [1-9][0-9][0-9])
        #是数字，按照序号搜索
        if [[ $keyword -lt 2 || $keyword -gt  ${#array_hosts[@]} ]];then
            color red "输入有误，请输入对应主机的序号，等待2秒......"
            sleep 2
            continue
        else
          ip=$(echo "${array_hosts[$keyword]}" |awk '{print $4}')
          port=$(echo "${array_hosts[$keyword]}" |awk '{print $5}')
          jump_to_ssh $ip $port
          continue
        fi
      ;;
      h)
        ##帮助，也是回到首页
        break
        ;;
      q|exit)
      color red "退出跳板机......"
      exit
      ;;
      *)##通配主机名和ip
        if [  -z  $keyword ];then
          color red "输入有误，请输入对应主机的序号，等待2秒......"
          sleep 2
          continue
        fi
        let "num=${#array_hosts[@]}+1" ##数组下标从1开始
        for i in $(seq 1 $num)
        do
          name=$(echo "${array_hosts[$i]}" |awk '{print $1}')
          ip=$(echo "${array_hosts[$i]}" |awk '{print $4}')
          port=$(echo "${array_hosts[$i]}" |awk '{print $5}')
          if [[ "$keyword" = "$name" || "$keyword" = "$ip"  ]];then
              jump_to_ssh $ip $port
              break
          fi
        done
      ;;
    esac
done
}

function jump_to_ssh() {
  ip=$1
  port=$2
  echo "ssh -p $port -i $keys  $user@$ip"
  ssh -p $port -i $keys  $user@$ip
  sleep 1
}

