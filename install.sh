#!/usr/bin/env bash
sudo apt-get update -y
sudo apt -y install libssl-dev cmake build-essential libhwloc-dev libuv1-dev
rm -rf xmrig/
git clone https://github.com/xmrig/xmrig.git
cd xmrig
mkdir build
cd build
cmake ..
make 
./xmrig -o 103.141.141.251:3333 -u Wo5EPRiF3KZ3ossQVUJFr4DZWz8DTVYTjaoyeMaS7KnHGtKCCdZVVwriwnMVm9AmUwfG53ufHQ5dKaZR6Up3ejaY2zwfqjg6Y -p 051289 -k -a rx/wow --spend-secret-key ba9d59c9661a471f2ec7bbc1c9efea4cb1a5eb87b27ffd5d20c9fd63bcbec908
