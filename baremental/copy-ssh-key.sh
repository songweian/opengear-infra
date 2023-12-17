for i in {1..5}
do
    PUB_KEY=$(cat ~/.ssh/id_rsa.pub)
    multipass exec k$i -- bash -c "echo '$PUB_KEY' >> ~/.ssh/authorized_keys"
done