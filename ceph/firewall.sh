for i in {1..1}
do
    multipass exec ceph$i -- sudo ufw disable
done