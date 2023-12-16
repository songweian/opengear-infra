#!/bin/bash

# 创建5个虚拟机
# echo "Creating 5 nodes..."
for i in {1..5}
do
    if multipass info k$i &> /dev/null; then
        echo "node$i exists"
    else
        multipass launch --bridged -c 2 -m 2G -n k$i --name k$i
        echo "node$i created"
    fi
done

for i in {1..5}
do
  multipass exec k$i -- bash -c "echo 'k$i.opengear.local' | sudo tee /etc/hostname"
  multipass exec k$i -- bash -c "sudo hostname -F /etc/hostname"
  multipass exec k$i -- bash -c "echo '127.0.1.1 k$i.opengear.local' | sudo tee -a /etc/hosts"
done

# 设置代理服务器地址
PROXY="http://192.168.31.183:7890"
# export https_proxy=http://192.168.31.183:7890 http_proxy=http://192.168.31.183:7890 all_proxy=socks5://192.168.31.183:7890
#在每个虚拟机上设置代理
for i in {1..5}
do
    echo "set network proxy on node$i"
    multipass exec k$i -- bash -c "echo 'export http_proxy=$PROXY' >> ~/.bashrc"
    multipass exec k$i -- bash -c "echo 'export https_proxy=$PROXY' >> ~/.bashrc"
    multipass exec k$i -- bash -c "echo 'export all_proxy=$PROXY' >> ~/.bashrc"
    multipass exec k$i -- bash -c "source ~/.bashrc"
done

# 配置本地DNS，使得可以通过域名访问每个节点
for i in {1..5}
do
  IP=$(multipass info node$i | grep IPv4 | awk '{print $2}')
  echo "$IP k$i.opengear.local" | sudo tee -a /etc/hosts
done

