#/bin/bash
path=$(dirname $0)
. ${path}/fire.conf

set_chain(){
	#黑名单自定义
	/sbin/iptables -L blacklist > /dev/null 2> /dev/null
	if [ $? -eq 0 ] ; then
		/sbin/iptables -F blacklist #清空
	else
		/sbin/iptables -N blacklist  #新建
	fi
	#白名单自定义
	/sbin/iptables -L whitelist > /dev/null 2> /dev/null
	if [ $? -eq 0 ] ; then
		/sbin/iptables -F whitelist  #清空
	else
		/sbin/iptables -N whitelist  #新建
	fi
	#端口服务
	/sbin/iptables -L inports > /dev/null 2> /dev/null
	if [ $? -eq 0 ] ; then
		/sbin/iptables -F inports  #清空
	else
		/sbin/iptables -N inports  #新建
	fi
	/sbin/iptables -L outports > /dev/null 2> /dev/null
	if [ $? -eq 0 ] ; then
		/sbin/iptables -F outports  #清空
	else
		/sbin/iptables -N outports  #新建
	fi
}

set_whitelist(){
	for iprange in $localip
	do
		/sbin/iptables -t filter -A whitelist -d $iprange -s $iprange -j ACCEPT
	done
	for iprange in $white_range
	do
		/sbin/iptables -t filter -A whitelist  -m iprange --src-range $iprange -j ACCEPT
		/sbin/iptables -t filter -A whitelist  -m iprange --dst-range $iprange -j ACCEPT
	done
	for iprange in $docker_range
	do
		/sbin/iptables -t filter -A whitelist -d $localip -m iprange --src-range $iprange -j ACCEPT
		/sbin/iptables -t filter -A whitelist -s $localip -m iprange --dst-range $iprange -j ACCEPT
	done
}

set_blacklist(){
	for iprange in $black_range
	do
		/sbin/iptables -t filter -A blacklist  -m iprange --src-range  $iprange -j DROP
		/sbin/iptables -t filter -A blacklist  -m iprange --dst-range  $iprange -j DROP
	done	
}

set_ports(){
	for port in $oport_tcp
	do
		/sbin/iptables -t filter -A inports -p tcp --sport $port -j ACCEPT
		/sbin/iptables -t filter -A outports -p tcp --dport $port -j ACCEPT
	done

	for port in $iport_tcp
	do
		/sbin/iptables -t filter -A inports -p tcp --dport $port -j ACCEPT
		/sbin/iptables -t filter -A outports -p tcp --sport $port -j ACCEPT
	done

	for port in $iport_udp
	do
			/sbin/iptables -t filter -A inports -p udp --dport $port -j ACCEPT
			/sbin/iptables -t filter -A outports -p udp --sport $port -j ACCEPT
	done
	for port in $oport_udp
	do
		/sbin/iptables -t filter -A inports -p udp --sport $port -j ACCEPT
		/sbin/iptables -t filter -A outports -p udp --dport $port -j ACCEPT
	done

	/sbin/iptables -t filter -A inports  -j DROP
	/sbin/iptables -t filter -A outports -j DROP

}

set_rule(){
	/sbin/iptables -t filter -C INPUT -p icmp --icmp 8 -j ACCEPT > /dev/null 2> /dev/null
	if [ ! $? -eq 0 ] ; then
		/sbin/iptables -t filter -A INPUT -p icmp --icmp 8 -j ACCEPT
	fi

	/sbin/iptables -t filter -C OUTPUT -p icmp --icmp 0 -j ACCEPT > /dev/null 2> /dev/null
	if [ ! $? -eq 0 ] ; then
		/sbin/iptables -t filter -A OUTPUT -p icmp --icmp 0 -j ACCEPT
	fi

	/sbin/iptables  -t filter -C INPUT -j whitelist  > /dev/null 2> /dev/null
	if [ ! $? -eq 0 ] ; then
		/sbin/iptables -t filter -A INPUT -j whitelist
	fi

	/sbin/iptables -t filter -C OUTPUT -j whitelist > /dev/null 2> /dev/null
	if [ ! $? -eq 0 ] ; then
		/sbin/iptables -t filter -A OUTPUT -j whitelist
	fi

	/sbin/iptables -t filter -C INPUT -j blacklist > /dev/null 2> /dev/null
	if [ ! $? -eq 0 ] ; then
		/sbin/iptables -t filter -A INPUT -j blacklist
	fi

	/sbin/iptables -t filter -C OUTPUT -j blacklist > /dev/null 2> /dev/null
	if [ ! $? -eq 0 ] ; then
		/sbin/iptables -t filter -A OUTPUT -j blacklist
	fi

	/sbin/iptables -t filter -C INPUT -j inports > /dev/null 2> /dev/null
	if [ ! $? -eq 0 ] ; then
		/sbin/iptables -t filter -A INPUT -j inports
	fi

	/sbin/iptables -t filter -C OUTPUT -j outports > /dev/null 2> /dev/null
	if [ ! $? -eq 0 ] ; then
		/sbin/iptables -t filter -A OUTPUT -j outports
	fi
}

set_chain
set_rule
set_whitelist
set_blacklist
set_ports
