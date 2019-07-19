#! /bin/sh
#===============================================================================
#
#          FILE:  eve.sh
# 
#         USAGE:  eve.sh 
# 
#   DESCRIPTION:  EVE-NG AUTOMATION SCRIPT
# 
#        AUTHOR:  Nguyen Van long, vanlong.me@gmail.com
#      Contributor:  Nguyen Trong Tan (), nguyentrongtan124@gmail.com
#  ORGANIZATION:  ITFORVN
#       VERSION:  3.0
#       CREATED:  16/07/2019 03:03:56 PM ICT
#        EDITED:  19/07/2019 03:03:56 PM ICT
#      REVISION:  ---
#===============================================================================

# GLOBAL VARIABLES
# Ten user muon tao
USERNAME="itforvn"
# So luong user muon tao moi
USERNEW="10"
# So luong user da ton tai
USEREXIST="20"
# Mat khau mac dinh cho user
PASSWDEXAMP="123"
# Thu muc LAB cho user dang: /DIR/
DIRLAB="/LAB-DIR/"

# In mau thong diep
echocolor () {
    echo "$(tput setaf 2)##### $1 #####$(tput sgr0)"
}

# Tao user moi
create_user () {
    echocolor "Username se duoc tao tu $USERNAME$USEREXIST toi $USERNAME$(expr $USERNEW + $USEREXIST)"
	sleep 3
    count=`expr $USERNEW + $USEREXIST`
    tmp=`echo -n $PASSWDEXAMP | openssl dgst -sha256`
    PASSUSER=`echo ${tmp#(stdin)= }`
	mkdir -p /opt/unetlab/labs$DIRLAB
	
	dot="'"
    unl=".unl"
    loop=$count
    uid=`uuidgen -r`
	
    while [ $loop != $USERNEW ]
    do
    	echocolor 'Dang tao user:' $USERNAME$loop
    	echo "INSERT INTO users VALUES ($dot$USERNAME$loop$dot,NULL,'admin@itforvn.com',-1,'Eve-NG Administrator',$dot$PASSUSER$dot,NULL,'',$dot$USERNAME$loop$dot,$dot$lab$dot,1);" | mysql --host=localhost --user=root --password=eve-ng eve_ng_db
		
    	echocolor "Dang tao LAB cho User...."
    	echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?> <lab name="'$USERNAME$loop'" id="'$uid'" version="1" scripttimeout="300" lock="0" author="'$USERNAME$loop'"/>' >> /opt/unetlab/labs$DIRLAB$USERNAME$loop$unl

    	echocolor "Tao Lab Thanh Cong !"
    	loop=`expr $loop - 1`
    done
}

# Fix phan quyen va lab
fix_lab () {   
    
    while [ $count != $USERNEW ]
    do
    	RANDOM=`python -c "import random; print random.randint(1,10000)"`
    	id=`expr $USEREXIST + $count`
    	echo "INSERT INTO pods VALUES ($dot$id$dot,-1,$dot$USERNAME$count$dot,$dot$lab$dot)" | mysql --host=localhost --user=root --password=eve-ng eve_ng_db
        echo "update pods set lab_id=$dot$lab$USERNAME$count$unl$dot where username=$dot$USERNAME$count$dot;" | mysql --host=localhost --user=root --password=eve-ng eve_ng_db
    	count=`expr $count - 1`
    done
    
    echocolor 'Dang fix phan quyen'
    /opt/unetlab/wrappers/unl_wrapper -a fixpermissions
    echocolor 'Fix phan quyen hoan thanh'
	sleep 3
	
    echocolor 'Khoa tinh nang Close Lab'
    `wget -O action.js https://raw.githubusercontent.com/vanlong2k/EVE-NG-Learning-Center-Script/master/Cracked/actions.js?token=AHGGBQAW752YAIAYNCQXO7K5HAUZY && mv action.js /opt/unetlab/html/themes/default/js`
}

####### MAIN ######

# Khoi tao tai khoan nguoi dung
create_user

# Fix lab
fix_lab

echocolor "SUCCESS!!!"