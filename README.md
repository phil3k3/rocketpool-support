# Rocketpool 

Setup and deploy rocketpool on a single machine using Ansible.

Requirements:
 - python3

Setup:
 - Create file ```inventory.ini``` with the following contents:
```
[rocketpool]
<ROCKETPOOL_IP_ADDRESS>
```
 - Run ```source deploy_rocketpool.sh ```
 
 - After your whole rocketpool setup is complete, you can run

```cat harden.sh | ssh root@<ROCKETPOOL_IP_ADDRESS> 'bash -'```

manually to disable root access. This is to avoid the script from locking itself out prematurely.

 - Optionally, you can install tailscale to setup a VPN between your validator host 
and your local machine:

```cat tailscale.sh | ssh root@<ROCKETPOOL_IP_ADDRESS> 'bash -' ```

For details, refer to [https://rocketpool.net/](https://docs.rocketpool.net/)
   

