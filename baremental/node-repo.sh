for i in {1..5}
do
    multipass exec k$i -- bash -c "echo 'deb http://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list"
done

for i in {1..5}
do
    multipass exec k$i -- sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B53DC80D13EDEF05
done