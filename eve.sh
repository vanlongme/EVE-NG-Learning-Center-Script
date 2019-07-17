#! /bin/sh
# Author : Nguyen Van long
# Version : 1.0.0
# Contact : vanlong.me@gmail.com
# Copyright (c) https://nguyenvanlong.me - itforvn.com
echo 'Nhap username muon tao so luong lon'
read username
if  [ -z $username ]; then
	echo 'vui long nhap tham so'
	exit 1
else
	echo 'Nhap so luong username muon tao'
	read count
	echo 'Nhap so luong user da ton tai'
	read avai
	echo 'Username se duoc tao tu '$username$avai' toi' $username`expr $count + $avai`
	count=`expr $count + $avai`
	echo 'nhap password muon dat cho cac users'
	read ipass
	tmp=`echo -n $ipass | openssl dgst -sha256`
	echo $pass
	passwd=`echo ${tmp#(stdin)= }`
	echo 'Thanh cong !'
	echo 'Mat khau duoc dat de tao cho users la:' $passwd
	echo 'Nhap duong dan chua path LAB cho hoc vien, vi du: /ISE/'
	read lab
	mkdir /opt/unetlab/labs$lab
	read -r -p "Ban co muon tao lab trong cho User ? [Y/N] " input
	case $input in
    			[yY])
 			echo 'OK !'
				;;
    			[nN])
 		echo "No"
       			;;
    			*)
		echo "Invalid input..."
 		exit 1
 				;;
	esac


fi
dot="'"
unl=".unl"
loop=$count
uid=`uuidgen -r`
while [ $loop != $avai ]
do
	echo 'Dang tao user:' $username$loop
	echo "INSERT INTO users VALUES ($dot$username$loop$dot,NULL,'admin@itforvn.com',-1,'Eve-NG Administrator',$dot$passwd$dot,NULL,'',$dot$username$loop$dot,$dot$lab$dot,1);" | mysql --host=localhost --user=root --password=eve-ng eve_ng_db
	echo "Dang tao LAB cho User...."
	case $input in
    			[yY])
		echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<lab name="'$username$loop'" id="'$uid'" version="1" scripttimeout="300" lock="0" author="'$username$loop'"/>' >> /opt/unetlab/labs/$lab$username$loop$unl
	esac
	echo "Tao Lab Thanh Cong !"
	loop=`expr $loop - 1`
done
sleep 3
while [ $count != $avai ]
do
	RANDOM=$$
	id=`expr $RANDOM + $count - 69`
	echo "INSERT INTO pods VALUES ($dot$id$dot,-1,$dot$username$count$dot,$dot$lab$dot)" | mysql --host=localhost --user=root --password=eve-ng eve_ng_db
        echo "update pods set lab_id=$dot$lab$username$count$unl$dot where username=$dot$username$count$dot;" | mysql --host=localhost --user=root --password=eve-ng eve_ng_db
	count=`expr $count - 1`
done
echo 'Dang fix phan quyen'
`/opt/unetlab/wrappers/unl_wrapper -a fixpermissions`
echo 'Fix phan quyen hoan thanh'
echo 'Ban co muon khoa tinh nang Close Lab hay khong ?'
read closelab
case $closelab in
    			[yY])
 			echo 'Da khoa closelab !'
 			`wget -O action.js https://raw.githubusercontent.com/vanlong2k/EVE-NG-Learning-Center-Script/master/Cracked/actions.js?token=AHGGBQAW752YAIAYNCQXO7K5HAUZY && mv action.js /opt/unetlab/html/themes/default/js`
				;;
    			[nN])
 		echo "No"
       			;;
    			*)
		echo "Invalid input..."
 		exit 1
 				;;
	esac
echo "SUCCESS !"