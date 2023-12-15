#!/bin/bash

# 创建5个虚拟机
echo "Creating 5 nodes..."
for i in {1..5}
do
    if multipass info node$i &> /dev/null; then
        echo "node$i exists"
    else
        multipass launch --name node$i
        echo "node$i created"
    fi
done

for i in {1..5}
do
  multipass exec node$i -- bash -c "echo 'node$i.opengear.local' | sudo tee /etc/hostname"
  multipass exec node$i -- bash -c "sudo hostname -F /etc/hostname"
  multipass exec node$i -- bash -c "echo '127.0.1.1 node$i.opengear.local' | sudo tee -a /etc/hosts"
done

# 设置代理服务器地址
PROXY="http://192.168.31.183:7890"
## export https_proxy=http://192.168.31.183:7890 http_proxy=http://192.168.31.183:7890 all_proxy=socks5://192.168.31.183:7890
# 在每个虚拟机上设置代理
# for i in {1..5}
# do
#     echo "set network proxy on node$i"
#     multipass exec node$i -- bash -c "echo 'export http_proxy=$PROXY' >> ~/.bashrc"
#     multipass exec node$i -- bash -c "echo 'export https_proxy=$PROXY' >> ~/.bashrc"
#     multipass exec node$i -- bash -c "echo 'export all_proxy=$PROXY' >> ~/.bashrc"
#     multipass exec node$i -- bash -c "source ~/.bashrc"
# done

# 配置本地DNS，使得可以通过域名访问每个节点
# echo "$IP1 node1" | sudo tee -a /etc/hosts
# for i in {1..5}
# do
#   IP=$(multipass info node$i | grep IPv4 | awk '{print $2}')
#   echo "$IP node$i.opengear.local" | sudo tee -a /etc/hosts
# done

echo "installing k3s..."
# 在虚拟机上安装k3s
for i in {1..1}
do
    if multipass exec node$i -- bash -c "command -v k3s &> /dev/null"; then
        echo "node$i k3s exists"
        multipass exec node$i -- bash -c "k3s --version"
    else
        multipass exec node$i -- bash -c "curl -sfL https://get.k3s.io | sh -"
        echo "node$i k3s installed"
        multipass exec node$i -- bash -c "k3s --version"
    fi
done

echo "configuring k3s..."
# 获取第一个节点的token和ip
TOKEN=$(multipass exec node1 -- bash -c "sudo cat /var/lib/rancher/k3s/server/node-token")
IP1=$(multipass info node1 | grep IPv4 | awk '{print $2}')

# 其他节点加入集群
echo "joining k3s..."
for i in {2..5}
do
    if multipass exec node$i -- bash -c "sudo k3s kubectl get node | grep node$i"; then
        echo "node$i joined"
    else
        multipass exec node$i -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=https://$IP1:6443 K3S_TOKEN=$TOKEN sh -"
        echo "node$i new joined"
    fi
done