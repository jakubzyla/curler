#/bin/bash
##JZyla 2023

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
	echo "One of the parameters is not defined.";
	echo "./curler.sh [domain] [ip address] [port]";
	exit 3; 
else
	curl=`curl $1 --resolve $1:$3:$2 -w "Total response time: %{time_total}s\nResponse code: %{response_code}\nRemote IP: %{remote_ip}\nRemote port: %{remote_port}\n" -o /dev/null -s`; 
	time=`echo "$curl" | head -n 1 | awk '{print $NF}' | sed "s/s//g" | sed "s/\..*//g"`;

	echo "$curl"

	if [ "$time" -gt "10" ]; then
		CODE="2"; 
	elif [ "$time" -gt "5" ]; then
		CODE="1"
	else
		CODE="0"
	fi

	exit $CODE;
fi

