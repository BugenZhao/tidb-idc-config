#!/bin/bash

echo ">> basic"
yum install -y git wget tmux

echo ">> ssh"
ssh-keygen

echo ">> gcc-8"
yum install -y centos-release-scl
yum install -y devtoolset-8-gcc devtoolset-8-gcc-c++
echo 'source scl_source enable devtoolset-8' >> .bashrc
source .bashrc

echo ">> golang"
rm -f go1.17.1.linux-amd64.tar.gz
wget https://golang.org/dl/go1.17.1.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.1.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> .bashrc
source .bashrc

echo ">> rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo ">> tiup"
curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh

echo ">> ticat"
git clone https://github.com/innerr/ticat.git ticat-src
make -C ticat-src
mkdir -p ticat
cp -f ticat-src/bin/ticat ticat/ticat
echo 'export PATH=$PATH:$HOME/ticat' >> .bashrc
source .bashrc
ticat hub.add innerr/workload-sim.tidb.ticat

echo ">> mkfs"
mkfs.ext4 /dev/nvme0n1
mkfs.ext4 /dev/nvme1n1

echo ">> mount"
mkdir -p /data0
mount /dev/nvme0n1 /data0
mkdir -p /data1
mount /dev/nvme1n1 /data1

echo ">> conda"
rm -f miniconda.sh
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
chmod +x miniconda.sh
./miniconda.sh -b -p $HOME/miniconda
echo 'export PATH=$PATH:$HOME/miniconda/bin' >> .bashrc
source .bashrc

echo ">> zsh"
yum install -y ncurses-devel
rm -rf zsh-5.8.tar.xz zsh-5.8
wget https://nchc.dl.sourceforge.net/project/zsh/zsh/5.8/zsh-5.8.tar.xz
tar -xf zsh-5.8.tar.xz
cd zsh-5.8 && ./configure && make install -j8 && cd -
echo $(which zsh) >> /etc/shells
chsh -s $(which zsh)
