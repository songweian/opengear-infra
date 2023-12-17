for i in {1..5}
do
    node_name=k$i
    node_ip=$(multipass info $node_name --format json | jq -r ".info.$node_name.ipv4[] | select(startswith(\"192.168.31.\"))")
    echo "$node_name ansible_host=$node_ip ansible_user=ubuntu"
done