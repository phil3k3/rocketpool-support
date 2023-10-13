

scp rocketpool.sh root@${HOSTNAME}:.
# todo call script
scp ~/.ssh/id_ecdsa.pub root@${HOSTNAME}:/home/eth/.ssh/authorized_keys

