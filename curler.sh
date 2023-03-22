#/bin/bash
##JZyla 2023
#Simple Icinga2 plugin to check if website is fine, served from multiple servers (i.e. in load balanced environments)
#Allows you to check total response time, response code, and confirms that it's been served from specific server.
#
#Great way to say hello to my GitHub 

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
	echo "One of the parameters is not defined.";
	echo "[USAGE]./curler.sh [domain] [ip address] [port]";
	exit 3; 
else
	curl=`curl $1 --resolve $1:$3:$2 -w "Total response time: %{time_total}s\nResponse code: %{response_code}\nRemote IP: %{remote_ip}\nRemote port: %{remote_port}\n" -o /dev/null -s`; 
	curl_code=$?
	if [ "$curl_code" == "0" ]; then
		time=`echo "$curl" | head -n 1 | awk '{print $NF}' | sed "s/s//g" | sed "s/\..*//g"`;
		if [ "$time" -gt "10" ]; then
			CODE="2"; 
		elif [ "$time" -gt "5" ]; then
			CODE="1"
		else
			CODE="0"
		fi
		echo "$curl"
		exit $CODE;
	else
		echo "Something is no yes with curl, exit code is $curl_code";
		exit $curl_code
	fi
fi

