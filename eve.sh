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
	echo 'Username se duoc tao tu '$username$avai' toi' $username`expr $count + $avai + 1`
	count=`expr $count + $avai`
	echo 'nhap password da hash muon dat cho cac users'
	read ipass
	tmp=`echo -n $ipass | openssl dgst -sha256`
	echo $pass
	passwd=`echo ${tmp#(stdin)= }`
	echo 'Thanh cong !'
	echo 'Mat khau duoc dat de tao cho users la:' $passwd
	echo 'Nhap duong dan chua path LAB cho hoc vien, vi du: /ISE/'
	read lab
        echo "Nhap files Lab mau da tao, de cung voi noi dat script"
        read filename
	mkdir /opt/unetlab/labs/$lab

fi
dot="'"
unl=".unl"
loop=$count
while [ $loop != $avai ]
do
	echo 'Dang tao user:' $username$loop
	echo "INSERT INTO users VALUES ($dot$username$loop$dot,NULL,'admin@itforvn.com',-1,'Eve-NG Administrator',$dot$passwd$dot,NULL,'',$dot$username$loop$dot,$dot$lab$dot,1);" | mysql --host=localhost --user=root --password=eve-ng eve_ng_db
	echo "Dang tao LAB cho User...."
	cp $filename /opt/unetlab/labs/$lab/$username$loop$unl
	echo "Tao Lab Thanh Cong !"
	loop=`expr $loop - 1`
done
sleep 3
echo "Dang nhap vao cac User da tao va bam y de gan lab cho User"
read conf
while [ $count != $avai ]
do
	RANDOM=$$
	id=`expr $RANDOM + $count - 69`
	echo "INSERT INTO pods VALUES ($dot$id$dot,-1,$dot$username$count$dot,$dot$lab$dot)" | mysql --host=localhost --user=root --password=eve-ng eve_ng_db
        echo "update pods set lab_id=$dot$lab$username$count$unl$dot where username=$dot$username$count$dot;" | mysql --host=localhost --user=root --password=eve-ng eve_ng_db
	count=`expr $count - 1`
done
echo "SUCCESS !"