for i in {1..5}
do
    multipass exec k$i -- bash -c "echo 'export https_proxy=http://192.168.31.183:7890' | sudo tee -a /etc/environment"
    multipass exec k$i -- bash -c "echo 'export http_proxy=http://192.168.31.183:7890' | sudo tee -a /etc/environment"
    multipass exec k$i -- bash -c "echo 'export all_proxy=socks5://192.168.31.183:7890' | sudo tee -a /etc/environment"
done

# export https_proxy=http://192.168.31.183:7890 http_proxy=http://192.168.31.183:7890 all_proxy=socks5://192.168.31.183:7890


sudo mkdir -p /etc/systemd/system/docker.service.d
sudo echo -e '[Service]\nEnvironment="HTTP_PROXY=http://192.168.31.183:7890"\nEnvironment="HTTPS_PROXY=http://192.168.31.183:7890"\nEnvironment="NO_PROXY=localhost,127.0.0.1,192.168.*.*,10.*.*.*,172.*.*.*"' | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl show --property=Environment docker

docker run -it --rm -p 5000:5000  --cap-add NET_ADMIN --stop-timeout 60 vdsm/virtual-dsm:latest
