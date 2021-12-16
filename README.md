# bashjumper介绍
bashjumper是一个基于linux bash的命令行下的超轻量的跳板机.
# bashjumper使用方法
## 安装
```shell
git clone https://github.com/feko2018/bashjumper.git
cd bashjumper
chmod +x jump.sh
./jump.sh
```
## 添加平台和主机
```shell
保留第一行，安装这种模板来添加
[root@test-vm-002 bashjumper]# cat platform.txt 
#平台
4499
7878
[root@test-vm-002 bashjumper]# cat hosts.txt 
#主机名  平台   类型   主机ip           端口  备注
test-001 4499   web    192.168.31.170    22   web服务器
test-002 7878   web    192.168.31.161    22   无
test-003 7878   web    127.0.0.1         22  
```
# bashjumper显示效果
## 首页
![image](https://user-images.githubusercontent.com/38614242/146331054-d153502a-97af-4059-b6a8-ea4fcf568d8f.png)

## 显示所有主机
![image](https://user-images.githubusercontent.com/38614242/146331137-87bb39a8-6971-4c14-acdc-f36f6d2447f0.png)

## 显示所有平台
![image](https://user-images.githubusercontent.com/38614242/146331182-eb71cf73-fe0b-42ad-813f-da81e7d921da.png)


### 显示对应平台的主机页
![image](https://user-images.githubusercontent.com/38614242/146331282-44d7da1b-c061-4ba3-bef4-310c56b1b386.png)
