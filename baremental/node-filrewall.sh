for i in {1..5}
do
    multipass exec k$i -- sudo ufw disable
done