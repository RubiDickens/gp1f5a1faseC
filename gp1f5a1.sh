#!/bin/bash
ver=$(cat /var/lib/jenkins/workspace/hotel/README | grep "Versió:" | cut -d "." -f 2)
echo $ver
ver_ant=$(cat /var/lib/jenkins/workspace/hotel/README | grep "Versió anterior:" | cut -d "." -f 3)
echo $ver_ant
ssh vagrant@producciog07 mkdir -p gp1f5a1/$ver
scp -r /var/lib/jenkins/workspace/hotel vagrant@producciog07:~/gp1f5a1/$ver
if [[ ! -z $ver_ant ]]
then
   comprova=$(ssh vagrant@producciog07 ls /home/vagrant/gp1f5a1 | grep $ver_ant)
   if [[ $comprova != "" ]]
   then
      ssh vagrant@producciog07 docker-compose -f /home/vagrant/gp1f5a1/$ver_ant/hotel/docker-compose.yml down
   fi
fi
ssh vagrant@producciog07 docker-compose -f /home/vagrant/gp1f5a1/$ver/hotel/docker-compose.yml up -d
exit 0
