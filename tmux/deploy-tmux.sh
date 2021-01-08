#! /bin/bash

if [[ $(tmux list-sessions | grep -i deployment | wc -l) -gt 0 ]]
then
	tmux attach -t deployment
else

	glances_conf="glances --disable-ports"

	tmux new -s deployment -n deploy  \; \
		send-keys "nload" C-m \; \
		split-window -h \; \
		send-keys "htop" C-m \; \
		split-window -v -p 90 \; \
		send-keys "$glances_conf" C-m \; \
		split-window -v -p 59 \; \
		send-keys "docker logs -f registry-mirror" C-m \; \
		split-window -v -p 35 \; \
		send-keys "ssh -t 10.0.0.1 -p 13456 nload" C-m \; \
		select-pane -t 3 \; \
		split-window -v -p 50 \; \
		send-keys "docker logs -f apt-cache" C-m \; \
		select-pane -t 0 \; \
		split-window -v -p 80 \; \
		send-keys "watch --no-title du -sh /var/lib/registry/ /var/cache/apt-cacher-ng/ /var/lib/devpi/" C-m \; \
		split-window -v -p 94 \; \
		select-pane -t 2 \; \
		send-keys ". ussuri/bin/activate" C-m \; \
		send-keys "cd ussuri" C-m \; \



fi

