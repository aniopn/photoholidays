#!/bin/bash

#script to organize photo by room numbers with authentication by room number and a seed always changing
#room number + user web nginx

systemctl restart nginx

mycase=$1

#where to create the room folder tree
mypath=/opt/photoholidays/rooms

case $mycase in

	requirements)
		#authentication x
		 yum install httpd-tools -y
		 yum install nginx -y
		;;

	rooms)
		#creation una tantum
		read -p "numbers of ROOMS available? " rooms
		echo "total rooms number are:  $rooms"
		mystart=1
		for (( r = $mystart; r <= $rooms ; r++)); do
			echo "room number $r"
			mkdir -p $mypath/$r
		done
		;;

	checkin1)
		#for each new checkin of the new customer
		#read -p "which is the ROOM's  number? " room

#room level
		#trb
		room=539
		#trb
		#read -p "write here the CHECK-IN date in the following format yyyymmdd " checkin
		checkin=20240728
		echo -e "room: $room; \t checkin: $checkin"
		#trb
		rm -rf ${mypath}/${room}
		mkdir -p $mypath/$room

		#mi serve per fare in modo che la singola room sia accessibile via web
	  cat <<EOF > "/opt/photoholidays/nginx-conf/${room}.conf"
location /${room} {
  autoindex on;
  auth_basic           "room ${room}";
  auth_basic_user_file ${mypath}/${room}/.htpasswd;
}
EOF

  #ogni volta che faccio checkin genero quindi una nuova password col cognome
  myuser=$room
  #trb
  #read -p "whcih is you SURNAME? " surname
  #mypassword=$surname
  mypassword=rossi
  echo $mypassword | htpasswd -c -i -B $mypath/$room/.htpasswd $myuser

  #checkin level
  #non é necessario che sia ragg via web, ma che sia accessibile da quell nuovo utente correttamente
  mkdir -p $mypath/$room/$checkin

  #trb 1 folder
  mkdir -p $mypath/$room/00000000
  #trb 1 immagine
cat <<EOF > $mypath/$room/$checkin/1.svg
<html><body><h1>My first SVG</h1>
<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="50" r="40" stroke="green" stroke-width="4" fill="yellow" />
</svg></body></html>
EOF

  #devo assicurarmi che solo la folder del checkin sia visibile tra le altre
  chmod 0600 -R $mypath/$room/
  chmod 0755 $mypath
  chmod 0644 $mypath/.htpasswd


  #solo la room interessata dal checkin
  chmod 0755 $mypath/$room/
  chmod 644 ${mypath}/${room}/.htpasswd

  chmod 0755 -R $mypath/$room/$checkin 
;;

checkinlist)

  chmod 0600 -R $mypath
  chmod 0755 $mypath
  chmod 0644 $mypath/.htpasswd

  while read line; do
    room=$(echo $line | cut -d";" -f1)
    checkin=$(echo $line | cut -d";" -f2)
    surname=$(echo $line | cut -d";" -f3)
    echo "room: $room; checkin: $checkin; surname: $surname"

    #trb
    rm -rf $mypath/$room
    mkdir -p $mypath/$room

cat <<EOF > "/opt/photoholidays/nginx-conf/${room}.conf"
location /${room} {
  autoindex on;
  auth_basic           "room ${room}";
  auth_basic_user_file ${mypath}/${room}/.htpasswd;
}
EOF

  myuser=$room
  mypassword=$surname
  echo $mypassword | htpasswd -c -i -B $mypath/$room/.htpasswd $myuser

  #creation folder for the new photos
  mkdir -p $mypath/$room/$checkin
  mkdir -p $mypath/$room/00000000
  chmod 0600 $mypath/$room/00000000

cat <<EOF > "${mypath}/${room}/${checkin}/1.svg"
<html><body><h1>My first SVG</h1>
<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="50" r="40" stroke="green" stroke-width="4" fill="redw" />
</svg></body></html>
EOF

  chmod 0755 $mypath/$room/
  chmod 644 ${mypath}/${room}/.htpasswd
  chmod 0755 -R $mypath/$room/$checkin

done < checkins-list.txt

;;

	user)
		#first user and first creation file -c
		myuser=rooms
		mypassword=rooms
		echo $mypassword | htpasswd -i -B -c $mypath/.htpasswd $myuser
		chmod 0755 $mypath
                chmod 0644 $mypath/.htpasswd

	;;

"delete")

	read -p "insert the storage days to keep: " mystorage
	#find $mypath -type f -iname "*.jpg" -mtime +"${mystorage}" -exec rm -f {} \;
	find $mypath -type f -iname "*.svg" -mtime +"${mystorage}" -ls 
	;;

	*)
		echo "pirla"
		;;

esac
