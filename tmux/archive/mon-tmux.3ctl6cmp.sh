#! /bin/bash

if [[ $(tmux list-sessions | grep -i node-monitor | wc -l) -gt 0 ]]
then
	tmux attach -t node-monitor
else

	glances_conf="'sleep 3; while true; do sudo glances --disable-ports; sleep 2; done'"

	tmux new -s node-monitor -n monMax \; \
		split-window -h -p 5   \; \
		send-keys "ping -i 2 -O 1.1.1.1 |  sed 's:64 bytes from 1.1.1.1\: icmp_seq:seq:;s:ttl=56 time:t:'" C-m \; \
		select-pane -t 0 \; \
		split-window -v \; \
		send-keys "ssh -t compute1-1 $glances_conf" C-m \; \
		split-window -h -p 83  \; \
		send-keys "ssh -t compute2-1 $glances_conf" C-m \; \
		split-window -h -p 80  \; \
		send-keys "ssh -t compute3-1 $glances_conf" C-m \; \
		split-window -h -p 75  \; \
		send-keys "ssh -t compute1-2 $glances_conf" C-m \; \
		split-window -h -p 66  \; \
		send-keys "ssh -t compute2-2 $glances_conf" C-m \; \
		split-window -h -p 50  \; \
		send-keys "ssh -t compute3-2 $glances_conf" C-m \; \
		select-pane -t 0 \; \
		send-keys "ssh -t controller1 $glances_conf" C-m \; \
		split-window -h -p 75  \; \
		send-keys "ssh -t controller2 $glances_conf" C-m \; \
		split-window -h -p 66  \; \
		send-keys "ssh -t controller3 $glances_conf" C-m \; \
		split-window -h -p 50  \; \
		send-keys "ssh controller1 " C-m \; \
		send-keys "sudo docker container list | grep bash | cut -d ' ' -f 1 | xargs sudo docker rm -f {} ; sudo /root/cephadm shell" C-m \; \
		send-keys "watch -n .2 ceph status" C-m \; \
		split-window -v -p 40 \; \
		send-keys "ssh -t controller1 sudo /root/cephadm shell" C-m \; \
		send-keys "watch -n .2 ceph health detail" C-m \; \

fi


