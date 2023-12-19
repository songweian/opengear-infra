#!/bin/bash

# 创建5个虚拟机
# echo "Creating 5 nodes..."
for i in {1..1}
do
    if multipass info ceph$i &> /dev/null; then
        echo "ceph$i exists"
    else
        multipass launch --name ceph$i -c 4 -m 8G -d 200G --network bridged
        mkdir -p /Users/swa-c/multipass/ceph$i
        multipass mount /Users/swa-c/multipass/ceph$i ceph$i:/home/ubuntu/rlocal
        echo "k$i created"
    fi
done

# 修改hostname
for i in {1..1}
do
  multipass exec ceph$i -- bash -c "echo 'ceph$i.opengear.local' | sudo tee /etc/hostname"
  multipass exec ceph$i -- bash -c "sudo hostname -F /etc/hostname"
  multipass exec ceph$i -- bash -c "echo '127.0.1.1 ceph$i.opengear.local' | sudo tee -a /etc/hosts"
done