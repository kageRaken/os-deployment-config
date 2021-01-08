#! /bin/bash

sess="node-monitor"

if [[ $(tmux list-sessions | grep -i node-monitor | wc -l) -gt 0 ]]
then
	tmux attach -t $sess
else

	glances_conf="'sudo docker ps | grep -i bash | cut -f 1 -d \" \" | xargs sudo docker rm {} -f; sleep 3; while true; do sudo glances --disable-ports; sleep 2; done'"
	rows="$(tput lines)"
	cols="$(tput cols)"


	tmux new-session -s $sess -d -x "$cols" -y "$rows"
	tmux rename-window mon-ctl
	tmux split-window -h -p 0	# A
	tmux resize-pane -L 17		# 7
	tmux select-pane -t 0		
	tmux split-window -v 		# B 
	tmux split-window -h -p 66 	# C 
	tmux split-window -h -p 50 	# D
	tmux select-pane -t 0
	tmux split-window -h -p 66 	# E
	tmux split-window -h -p 50 	# F
	tmux split-window -v -p 0 	# G
	tmux resize-pane -U 7		# 3
	tmux select-pane -t 0		
	tmux split-window -v -p 100 	# H 
	tmux resize-pane -D 5		# 0
	tmux select-pane -t 2		
	tmux split-window -v -p 100 	# I 
	tmux resize-pane -D 5		# 2
	tmux select-pane -t 6		
	tmux split-window -v -p 100 	# J 
	tmux resize-pane -D 5		# 6
	tmux select-pane -t 8		
	tmux split-window -v -p 100 	# J 
	tmux resize-pane -D 5		# 6
	tmux select-pane -t 10		
	tmux split-window -v -p 100 	# J 
	tmux resize-pane -D 5		# 6
	tmux send-keys -t 0  "ssh -t controller1 htop" C-m 
	tmux send-keys -t 1  "ssh -t controller1 $glances_conf" C-m 
	tmux send-keys -t 2  "ssh -t controller2 htop" C-m 
	tmux send-keys -t 3  "ssh -t controller2 $glances_conf" C-m 
	tmux send-keys -t 4  "ssh -t controller1 sudo /root/cephadm shell" C-m 
	tmux send-keys -t 4  "watch -n .2 ceph status" C-m 
	tmux send-keys -t 5  "ssh -t controller1 sudo /root/cephadm shell" C-m 
	tmux send-keys -t 5  "watch -n .2 ceph health detail" C-m 
	tmux send-keys -t 6  "ssh -t controller3 htop" C-m 
	tmux send-keys -t 7  "ssh -t controller3 $glances_conf" C-m 
	tmux send-keys -t 8  "ssh -t controller4 htop" C-m 
	tmux send-keys -t 9  "ssh -t controller4 $glances_conf" C-m 
	tmux send-keys -t 10 "ssh -t controller5 htop" C-m 
	tmux send-keys -t 11 "ssh -t controller5 $glances_conf" C-m 
	tmux send-keys -t 12  "ping -i 2 -O 1.1.1.1 |  sed 's:64 bytes from 1.1.1.1\: icmp_seq:seq:;s:ttl=56 time:t:'" C-m
	tmux attach -t node-monitor 



fi

############################################################
#       0       E         2        F               A       #
#HHHHHHHHHHHHHHHEIIIIIIIIIIIIIIIIIIF       4       A       #
#               E                  F               A       #
#               E                  FGGGGGGGGGGGGGGGA       #
#       2       E         3        F               A       #
#               E                  F       5       A       #
#               E                  F               A       #
#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBA   12  #
#       6       C         8        D       10      A       #
#JJJJJJJJJJJJJJJCKKKKKKKKKKKKKKKKKKDLLLLLLLLLLLLLLLA       #
#               C                  D               A       #
#       7       C         9        D       11      A       #
#               C                  D               A       #
#               C                  D               A       #
#               C                  D               A       #
############################################################



