#!/bin/bash

# 创建5个虚拟机
# echo "Creating 5 nodes..."
for i in {1..5}
do
    if multipass info k$i &> /dev/null; then
        echo "k$i exists"
    else
        multipass launch --name k$i -c 2 -m 4G -d 100G --network bridged
        mkdir -p /Users/swa-c/multipass/k$i
        multipass mount /Users/swa-c/multipass/k$i k$i:/home/ubuntu/rlocal
        echo "k$i created"
    fi
done

# 修改hostname
for i in {1..5}
do
  multipass exec k$i -- bash -c "echo 'k$i.opengear.local' | sudo tee /etc/hostname"
  multipass exec k$i -- bash -c "sudo hostname -F /etc/hostname"
  multipass exec k$i -- bash -c "echo '127.0.1.1 k$i.opengear.local' | sudo tee -a /etc/hosts"
done



