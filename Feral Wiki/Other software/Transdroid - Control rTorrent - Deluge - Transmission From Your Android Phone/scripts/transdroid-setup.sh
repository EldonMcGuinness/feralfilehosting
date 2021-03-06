#!/bin/bash
# Transdroid/Transdrone Setup
scriptversion="1.0.7"
scriptname="transdroid.setup"
# Author: adamaze (frankthetank7254)
# Contributors: randomessence
#
# wget -qO ~/transdroid.setup http://git.io/lU_B9w && bash ~/transdroid.setup
#
############################
## Version History Starts ##
############################
#
############################
### Version History Ends ###
############################
#
############################
###### Variable Start ######
############################
#
scripturl="https://raw.githubusercontent.com/feralhosting/feralfilehosting/master/Feral%20Wiki/Other%20software/Transdroid%20-%20Control%20rTorrent%20-%20Deluge%20-%20Transmission%20From%20Your%20Android%20Phone/scripts/transdroid-setup.sh"
#
rtorrentjson="https://raw.githubusercontent.com/feralhosting/feralfilehosting/master/Feral%20Wiki/Other%20software/Transdroid%20-%20Control%20rTorrent%20-%20Deluge%20-%20Transmission%20From%20Your%20Android%20Phone/json/rtorrent-settings.json"
delugejson="https://raw.githubusercontent.com/feralhosting/feralfilehosting/master/Feral%20Wiki/Other%20software/Transdroid%20-%20Control%20rTorrent%20-%20Deluge%20-%20Transmission%20From%20Your%20Android%20Phone/json/deluge-settings.json"
transmissionjson="https://raw.githubusercontent.com/feralhosting/feralfilehosting/master/Feral%20Wiki/Other%20software/Transdroid%20-%20Control%20rTorrent%20-%20Deluge%20-%20Transmission%20From%20Your%20Android%20Phone/json/transmission-settings.json"
#
option1="ruTorrent"
option2="Deluge"
option3="Transmission"
option4="Custom Rutorrent instance"
option5="Quit"
#
tmpdir1=".transdroid_import"
tmpdir2="transdroid_import"
#
# Random password generation
randompass=$(< /dev/urandom tr -dc '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' | head -c20; echo;)
#
URL="https://$(whoami):$randompass@$(hostname -f)/$(whoami)/$tmpdir2"
#
############################
####### Variable End #######
############################
#
############################
#### Self Updater Start ####
############################
#
[[ ! -d ~/bin ]] && mkdir -p ~/bin
[[ ! -f ~/bin/"$scriptname" ]] && wget -qO ~/bin/"$scriptname" "$scripturl"
#
wget -qO ~/.000"$scriptname" "$scripturl"
#
if [[ $(sha256sum ~/.000"$scriptname" | awk '{print $1}') != $(sha256sum ~/bin/"$scriptname" | awk '{print $1}') ]]
then
    echo -e "#!/bin/bash\nwget -qO ~/bin/$scriptname $scripturl\ncd && rm -f $scriptname{.sh,}\nbash ~/bin/$scriptname\nexit" > ~/.111"$scriptname"
    bash ~/.111"$scriptname"
    exit
else
    if [[ -z $(ps x | fgrep "bash $HOME/bin/$scriptname" | grep -v grep | head -n 1 | awk '{print $1}') && $(ps x | fgrep "bash $HOME/bin/$scriptname" | grep -v grep | head -n 1 | awk '{print $1}') -ne "$$" ]]
    then
        echo -e "#!/bin/bash\ncd && rm -f $scriptname{.sh,}\nbash ~/bin/$scriptname\nexit" > ~/.222"$scriptname"
        bash ~/.222"$scriptname"
        exit
    fi
fi
cd && rm -f .{000,111,222}"$scriptname"
chmod -f 700 ~/bin/"$scriptname"
#
############################
##### Self Updater End #####
############################
#
############################
#### Core Script Starts ####
############################
#
echo
echo -e "Hello $(whoami), you have the latest version of the" "\033[36m""$scriptname""\e[0m" "script. This script version is:" "\033[31m""$scriptversion""\e[0m"
echo
read -ep "The scripts have been updated, do you wish to continue [y] or exit now [q] : " -i "y" updatestatus
echo
if [[ "$updatestatus" =~ ^[Yy]$ ]]
then
#
############################
#### User Script Starts ####
############################
#
    echo This script will generate the "settings.json" file that Transdroid requires for importing settings. Please choose the client you are using.
    echo
    showMenu () 
    {
            echo "1) $option1"
            echo "2) $option2"
            echo "3) $option3"
            echo "4) $option4"
            echo "5) $option5"
            echo
    }

    while [ 1 ]
    do
            showMenu
            read -e CHOICE
            echo
            case "$CHOICE" in
                    "1")
                            if [[ -d ~/.nginx ]]
                            then
                                mkdir -p ~/$tmpdir1
                                #
                                wget -qO ~/$tmpdir1/qrencode_3.3.0-2_amd64.deb http://ftp.uk.debian.org/debian/pool/main/q/qrencode/qrencode_3.3.0-2_amd64.deb
                                wget -qO ~/$tmpdir1/libqrencode3_3.3.0-2_amd64.deb http://ftp.uk.debian.org/debian/pool/main/q/qrencode/libqrencode3_3.3.0-2_amd64.deb
                                #
                                dpkg-deb -x ~/$tmpdir1/qrencode_3.3.0-2_amd64.deb ~/$tmpdir1
                                dpkg-deb -x ~/$tmpdir1/libqrencode3_3.3.0-2_amd64.deb ~/$tmpdir1
                                #
                                wget -qO ~/$tmpdir1/settings.json "$rtorrentjson"
                                read -ep "Please enter the ruTorrent password from your Account overview page: " pass
                                echo
                                #
                                sed -i 's/rutorrent main/rutorrent '$(hostname | grep -oE "^([a-z]+)")' main/' ~/$tmpdir1/settings.json
                                sed -i 's/USERNAME-CHANGEME/'$(whoami)'/' ~/$tmpdir1/settings.json
                                sed -i 's/HOSTNAME_CHANGEME/'$(hostname -f)'/' ~/$tmpdir1/settings.json
                                sed -i 's/PASSWORD-CHANGEME/'$pass'/' ~/$tmpdir1/settings.json
                                #
                                mkdir -p ~/www/$(whoami).$(hostname)/public_html/$tmpdir2
                                #
                                # cp -f ~/$tmpdir1/settings.json ~/www/$(whoami).$(hostname)/public_html/$tmpdir2/settings.json
                                htpasswd -cbm ~/www/$(whoami).$(hostname -f)/public_html/$tmpdir2/.htpasswd "$(whoami)" "$randompass" > /dev/null 2>&1
                                #
                                if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
                                then
                                    echo -e 'location /'"$tmpdir2"' {\n    auth_basic "'"$tmpdir2"'";\n    auth_basic_user_file "'"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/'"$tmpdir2"'/.htpasswd";\n}' > ~/.nginx/conf.d/000-default-server.d/transdroid_import.conf
                                    /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                                fi
                                #
                                echo -e 'AuthType Basic\nAuthName "'"$tmpdir2"'"\nAuthUserFile "'"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/'"$tmpdir2"'/.htpasswd"\nRequire "'$(whoami)'"' > ~/www/$(whoami).$(hostname -f)/public_html/"$tmpdir2"/.htaccess
                                #
                                # LD_LIBRARY_PATH=~/.transdroid_import/usr/lib/x86_64-linux-gnu ~/.transdroid_import/usr/bin/qrencode -m 1 -t ANSI256 -o - "$URL"
                                LD_LIBRARY_PATH=~/.transdroid_import/usr/lib/x86_64-linux-gnu ~/.transdroid_import/usr/bin/qrencode -m 10 -t PNG "$(cat ~/.transdroid_import/settings.json)" -o ~/www/$(whoami).$(hostname)/public_html/$tmpdir2/rtorrent.png
                                #
                                echo -e "1: Open Transdroid/Transdrone and go to:" "\033[36m""Settings > System > Import settings""\e[0m"
                                echo
                                echo -e "2: Click" "\033[36m""Use QR code""\e[0m"
                                echo
                                echo -e "3: Open this URL in a browser:"
                                echo
                                echo -e "\033[32m""$URL/rtorrent.png""\e[0m"
                                echo
                                echo -e "4: Now scan with Transdroid/Transdrone to import""\e[0m"
                                echo
                                echo -e "Note: Imported connections will be merged with existing ones. Nothing will be lost."
                                echo
                                read -ep "After you have scanned the qrcode, press ENTER to clean up." useless
                                echo
                                #
                                if [[ ! -z "$tmpdir1" && ! -z "$tmpdir2" ]]
                                then
                                    cd && rm -rf $tmpdir1 ~/www/$(whoami).$(hostname)/public_html/$tmpdir2
                                    if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
                                    then
                                        rm -f ~/.nginx/conf.d/000-default-server.d/transdroid_import.conf
                                        /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                                    fi
                                else
                                    echo "Nothing was removed. Please check manually."
                                fi
                            else
                                echo "Nginx is not installed and is a prerequisite for using Transdroid/Transdrone"
                                echo
                                echo "Please see this FAQ -- https://www.feralhosting.com/faq/view?question=231"
                                echo
                            fi
                            ;;
                    "2")
                            if [[ -d ~/.nginx ]]
                            then
                                mkdir -p ~/$tmpdir1
                                #
                                wget -qO ~/$tmpdir1/qrencode_3.3.0-2_amd64.deb http://ftp.uk.debian.org/debian/pool/main/q/qrencode/qrencode_3.3.0-2_amd64.deb
                                wget -qO ~/$tmpdir1/libqrencode3_3.3.0-2_amd64.deb http://ftp.uk.debian.org/debian/pool/main/q/qrencode/libqrencode3_3.3.0-2_amd64.deb
                                #
                                dpkg-deb -x ~/$tmpdir1/qrencode_3.3.0-2_amd64.deb ~/$tmpdir1
                                dpkg-deb -x ~/$tmpdir1/libqrencode3_3.3.0-2_amd64.deb ~/$tmpdir1
                                #
                                wget -qO ~/$tmpdir1/settings.json "$delugejson"
                                read -ep "Please enter the Deluge password from your Account overview page: " pass
                                echo
                                #
                                sed -i 's/deluge main/deluge '$(hostname | grep -oE "^([a-z]+)")' main/' ~/$tmpdir1/settings.json
                                sed -i 's/USERNAME-CHANGEME/'$(whoami)'/g' ~/$tmpdir1/settings.json
                                sed -i 's/HOSTNAME_CHANGEME/'$(hostname -f)'/' ~/$tmpdir1/settings.json
                                sed -i 's/PASSWORD-CHANGEME/'$pass'/' ~/$tmpdir1/settings.json
                                #
                                mkdir -p ~/www/$(whoami).$(hostname)/public_html/$tmpdir2
                                #
                                # cp -f ~/$tmpdir1/settings.json ~/www/$(whoami).$(hostname)/public_html/$tmpdir2/settings.json
                                htpasswd -cbm ~/www/$(whoami).$(hostname -f)/public_html/$tmpdir2/.htpasswd "$(whoami)" "$randompass" > /dev/null 2>&1
                                #
                                if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
                                then
                                    echo -e 'location /'"$tmpdir2"' {\n    auth_basic "'"$tmpdir2"'";\n    auth_basic_user_file "'"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/'"$tmpdir2"'/.htpasswd";\n}' > ~/.nginx/conf.d/000-default-server.d/transdroid_import.conf
                                    /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                                fi
                                #
                                echo -e 'AuthType Basic\nAuthName "'"$tmpdir2"'"\nAuthUserFile "'"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/'"$tmpdir2"'/.htpasswd"\nRequire "'$(whoami)'"' > ~/www/$(whoami).$(hostname -f)/public_html/"$tmpdir2"/.htaccess
                                #
                                # LD_LIBRARY_PATH=~/.transdroid_import/usr/lib/x86_64-linux-gnu ~/.transdroid_import/usr/bin/qrencode -m 1 -t ANSI256 -o - "$URL"
                                LD_LIBRARY_PATH=~/.transdroid_import/usr/lib/x86_64-linux-gnu ~/.transdroid_import/usr/bin/qrencode -m 10 -t PNG "$(cat ~/.transdroid_import/settings.json)" -o ~/www/$(whoami).$(hostname)/public_html/$tmpdir2/deluge.png
                                #
                                echo -e "1: Open Transdroid/Transdrone and go to:" "\033[36m""Settings > System > Import settings""\e[0m"
                                echo
                                echo -e "2: Click" "\033[36m""Use QR code""\e[0m"
                                echo
                                echo -e "3: Open this URL in a browser:"
                                echo
                                echo -e "\033[32m""$URL/deluge.png""\e[0m"
                                echo
                                echo -e "4: Now scan with Transdroid/Transdrone to import""\e[0m"
                                echo
                                echo -e "Note: Imported connections will be merged with existing ones. Nothing will be lost."
                                echo
                                read -ep "After you have scanned the qrcode, press ENTER to clean up." useless
                                echo
                                #
                                if [[ ! -z "$tmpdir1" && ! -z "$tmpdir2" ]]
                                then
                                    cd && rm -rf $tmpdir1 ~/www/$(whoami).$(hostname)/public_html/$tmpdir2
                                    if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
                                    then
                                        rm -f ~/.nginx/conf.d/000-default-server.d/transdroid_import.conf
                                        /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                                    fi
                                else
                                    echo "Nothing was removed. Please check manually."
                                fi
                            else
                                echo "Nginx is not installed and is a prerequisite for using Transdroid/Transdrone"
                                echo
                                echo "Please see this FAQ -- https://www.feralhosting.com/faq/view?question=231"
                                echo
                            fi
                            ;;
                    "3")
                            if [[ -d ~/.nginx ]]
                            then
                                mkdir -p ~/$tmpdir1
                                #
                                wget -qO ~/$tmpdir1/qrencode_3.3.0-2_amd64.deb http://ftp.uk.debian.org/debian/pool/main/q/qrencode/qrencode_3.3.0-2_amd64.deb
                                wget -qO ~/$tmpdir1/libqrencode3_3.3.0-2_amd64.deb http://ftp.uk.debian.org/debian/pool/main/q/qrencode/libqrencode3_3.3.0-2_amd64.deb
                                #
                                dpkg-deb -x ~/$tmpdir1/qrencode_3.3.0-2_amd64.deb ~/$tmpdir1
                                dpkg-deb -x ~/$tmpdir1/libqrencode3_3.3.0-2_amd64.deb ~/$tmpdir1
                                #
                                wget -qO ~/$tmpdir1/settings.json "$transmissionjson"
                                read -ep "Please enter the Transmission password from your Account overview page: " pass
                                echo
                                #
                                sed -i 's/transmission main/transmission '$(hostname | grep -oE "^([a-z]+)")' main/' ~/$tmpdir1/settings.json
                                sed -i 's/USERNAME-CHANGEME/'$(whoami)'/' ~/$tmpdir1/settings.json
                                sed -i 's/HOSTNAME_CHANGEME/'$(hostname -f)'/' ~/$tmpdir1/settings.json
                                sed -i 's/PASSWORD-CHANGEME/'$pass'/' ~/$tmpdir1/settings.json
                                #
                                mkdir -p ~/www/$(whoami).$(hostname)/public_html/$tmpdir2
                                #
                                # cp -f ~/$tmpdir1/settings.json ~/www/$(whoami).$(hostname)/public_html/$tmpdir2/settings.json
                                htpasswd -cbm ~/www/$(whoami).$(hostname -f)/public_html/$tmpdir2/.htpasswd "$(whoami)" "$randompass" > /dev/null 2>&1
                                #
                                if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
                                then
                                    echo -e 'location /'"$tmpdir2"' {\n    auth_basic "'"$tmpdir2"'";\n    auth_basic_user_file "'"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/'"$tmpdir2"'/.htpasswd";\n}' > ~/.nginx/conf.d/000-default-server.d/transdroid_import.conf
                                    /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                                fi
                                #
                                echo -e 'AuthType Basic\nAuthName "'"$tmpdir2"'"\nAuthUserFile "'"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/'"$tmpdir2"'/.htpasswd"\nRequire "'$(whoami)'"' > ~/www/$(whoami).$(hostname -f)/public_html/"$tmpdir2"/.htaccess
                                #
                                # LD_LIBRARY_PATH=~/.transdroid_import/usr/lib/x86_64-linux-gnu ~/.transdroid_import/usr/bin/qrencode -m 1 -t ANSI256 -o - "$URL"
                                LD_LIBRARY_PATH=~/.transdroid_import/usr/lib/x86_64-linux-gnu ~/.transdroid_import/usr/bin/qrencode -m 10 -t PNG "$(cat ~/.transdroid_import/settings.json)" -o ~/www/$(whoami).$(hostname)/public_html/$tmpdir2/transmission.png
                                #
                                echo -e "1: Open Transdroid/Transdrone and go to:" "\033[36m""Settings > System > Import settings""\e[0m"
                                echo
                                echo -e "2: Click" "\033[36m""Use QR code""\e[0m"
                                echo
                                echo -e "3: Open this URL in a browser:"
                                echo
                                echo -e "\033[32m""$URL/transmission.png""\e[0m"
                                echo
                                echo -e "4: Now scan with Transdroid/Transdrone to import""\e[0m"
                                echo
                                echo -e "Note: Imported connections will be merged with existing ones. Nothing will be lost."
                                echo
                                read -ep "After you have scanned the qrcode, press ENTER to clean up." useless
                                echo
                                #
                                if [[ ! -z "$tmpdir1" && ! -z "$tmpdir2" ]]
                                then
                                    cd && rm -rf $tmpdir1 ~/www/$(whoami).$(hostname)/public_html/$tmpdir2
                                    if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
                                    then
                                        rm -f ~/.nginx/conf.d/000-default-server.d/transdroid_import.conf
                                        /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                                    fi
                                else
                                    echo "Nothing was removed. Please check manually."
                                fi
                            else
                                echo "Nginx is not installed and is a prerequisite for using Transdroid/Transdrone"
                                echo
                                echo "Please see this FAQ -- https://www.feralhosting.com/faq/view?question=231"
                                echo
                            fi
                            ;;
                    "4")
                            if [[ -d ~/.nginx ]]
                            then
                                mkdir -p ~/$tmpdir1
                                #
                                wget -qO ~/$tmpdir1/qrencode_3.3.0-2_amd64.deb http://ftp.uk.debian.org/debian/pool/main/q/qrencode/qrencode_3.3.0-2_amd64.deb
                                wget -qO ~/$tmpdir1/libqrencode3_3.3.0-2_amd64.deb http://ftp.uk.debian.org/debian/pool/main/q/qrencode/libqrencode3_3.3.0-2_amd64.deb
                                #
                                dpkg-deb -x ~/$tmpdir1/qrencode_3.3.0-2_amd64.deb ~/$tmpdir1
                                dpkg-deb -x ~/$tmpdir1/libqrencode3_3.3.0-2_amd64.deb ~/$tmpdir1
                                #
                                wget -qO ~/$tmpdir1/settings.json "$rtorrentjson"
                                until [[ -d ~/www/$(whoami).$(hostname -f)/public_html/rutorrent-$suffix ]]
                                do
                                    read -ep "What is the suffix of the instance you wish to connect to: rutorrent-" suffix
                                done
                                read -ep "Please enter the ruTorrent password from your Account overview page: " pass
                                echo
                                #
                                sed -i 's|\\\/rtorrent\\\/rpc|\\\/rtorrent-'$suffix'\\\/rpc|' ~/.transdroid_import/settings.json
                                sed -i 's/rutorrent main/rutorrent-'$suffix' '$(hostname | grep -oE "^([a-z]+)")'/' ~/$tmpdir1/settings.json
                                sed -i 's/USERNAME-CHANGEME/'$(whoami)'/' ~/$tmpdir1/settings.json
                                sed -i 's/HOSTNAME_CHANGEME/'$(hostname -f)'/' ~/$tmpdir1/settings.json
                                sed -i 's/PASSWORD-CHANGEME/'$pass'/' ~/$tmpdir1/settings.json
                                #
                                mkdir -p ~/www/$(whoami).$(hostname)/public_html/$tmpdir2
                                #
                                # cp -f ~/$tmpdir1/settings.json ~/www/$(whoami).$(hostname)/public_html/$tmpdir2/settings.json
                                htpasswd -cbm ~/www/$(whoami).$(hostname -f)/public_html/$tmpdir2/.htpasswd "$(whoami)" "$randompass" > /dev/null 2>&1
                                #
                                if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
                                then
                                    echo -e 'location /'"$tmpdir2"' {\n    auth_basic "'"$tmpdir2"'";\n    auth_basic_user_file "'"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/'"$tmpdir2"'/.htpasswd";\n}' > ~/.nginx/conf.d/000-default-server.d/transdroid_import.conf
                                    /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                                fi
                                #
                                echo -e 'AuthType Basic\nAuthName "'"$tmpdir2"'"\nAuthUserFile "'"$HOME"'/www/'$(whoami)'.'$(hostname -f)'/public_html/'"$tmpdir2"'/.htpasswd"\nRequire "'$(whoami)'"' > ~/www/$(whoami).$(hostname -f)/public_html/"$tmpdir2"/.htaccess
                                #
                                # LD_LIBRARY_PATH=~/.transdroid_import/usr/lib/x86_64-linux-gnu ~/.transdroid_import/usr/bin/qrencode -m 1 -t ANSI256 -o - "$URL"
                                LD_LIBRARY_PATH=~/.transdroid_import/usr/lib/x86_64-linux-gnu ~/.transdroid_import/usr/bin/qrencode -m 10 -t PNG "$(cat ~/.transdroid_import/settings.json)" -o ~/www/$(whoami).$(hostname)/public_html/$tmpdir2/rtorrent.png
                                #
                                echo -e "1: Open Transdroid/Transdrone and go to:" "\033[36m""Settings > System > Import settings""\e[0m"
                                echo
                                echo -e "2: Click" "\033[36m""Use QR code""\e[0m"
                                echo
                                echo -e "3: Open this URL in a browser:"
                                echo
                                echo -e "\033[32m""$URL/rtorrent.png""\e[0m"
                                echo
                                echo -e "4: Now scan with Transdroid/Transdrone to import""\e[0m"
                                echo
                                echo -e "Note: Imported connections will be merged with existing ones. Nothing will be lost."
                                echo
                                read -ep "After you have scanned the qrcode, press ENTER to clean up." useless
                                echo
                                #
                                if [[ ! -z "$tmpdir1" && ! -z "$tmpdir2" ]]
                                then
                                    cd && rm -rf $tmpdir1 ~/www/$(whoami).$(hostname)/public_html/$tmpdir2
                                    if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
                                    then
                                        rm -f ~/.nginx/conf.d/000-default-server.d/transdroid_import.conf
                                        /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
                                    fi
                                else
                                    echo "Nothing was removed. Please check manually."
                                fi
                            else
                                echo "Nginx is not installed and is a prerequisite for using Transdroid/Transdrone"
                                echo
                                echo "Please see this FAQ -- https://www.feralhosting.com/faq/view?question=231"
                                echo
                            fi
                            ;;
                    "5")
                            echo "You chose to quit the script."
                            echo
                            exit
                            ;;
            esac
    done
#
############################
##### User Script End  #####
############################
#
else
    echo -e "You chose to exit after updating the scripts."
    echo
    cd && bash
    exit 1
fi
#
############################
##### Core Script Ends #####
############################
#
