mkdir -p $HOME/bin
wget https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-amd64 -O $HOME/bin/rocketpool
chmod +x $HOME/bin/rocketpool


export PATH=$HOME/bin:$PATH
rocketpool --version
rocketpool service install --yes

sg docker "newgrp `id -gn`"

rocketpool service config --smartnode-network prater \
                          --executionClientMode local \
                          --executionClient geth \
                          --reconnectDelay 2m \
                          --consensusClientMode local \
                          --consensusClient lighthouse \
                          --enableMetrics \
                          --enableODaoMetrics \
                          --enableBitflyNodeMetrics \
                          --bitflyNodeMetrics-bitflySecret OTVFZzBQRXYzbG1HNEhuM2tBcUR0VDZ0ZE9YOQ \
                          --enableMevBoost \
                          --mevBoost-mode local \
                          --mevBoost-selectionMode profile \
                          --mevBoost-enableRegulatedAllMev \
                          --consensusCommon-doppelgangerDetection \
                          --consensusCommon-checkpointSyncUrl https://prater-checkpoint-sync.stakely.io


rocketpool service start --ignore-slash-timer --yes

# SUDO
SUBNET=$(docker inspect rocketpool_monitor-net | grep -Po "(?<=\"Subnet\": \")[0-9./]+")
ufw allow from "$SUBNET" to any port 9103 comment "Allow prometheus access to node-exporter"


rocketpool node join-smoothing-pool
