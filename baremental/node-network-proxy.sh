for i in {1..5}
do
    multipass exec k$i -- bash -c "echo 'export https_proxy=http://192.168.31.183:7890' | sudo tee -a /etc/environment"
    multipass exec k$i -- bash -c "echo 'export http_proxy=http://192.168.31.183:7890' | sudo tee -a /etc/environment"
    multipass exec k$i -- bash -c "echo 'export all_proxy=socks5://192.168.31.183:7890' | sudo tee -a /etc/environment"
done