# 配置本地DNS，使得可以通过域名访问每个ii节点
for i in {1..5}
do
  IP=$(multipass info node$i | grep IPv4 | awk '{print $2}')
  echo "$IP k$i.opengear.local" | sudo tee -a /etc/hosts
done