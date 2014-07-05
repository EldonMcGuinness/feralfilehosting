#!/bin/bash
# Install Madsonic
scriptversion="1.7.3"
scriptname="install.madsonic"
madsonicversion="5.0 Build 3860"
javaversion="1.7 Update 55"
jvdecimal="1.7.0_55"
#
# randomessence
#
# * * * * * bash -l ~/bin/madsonicron
#
# wget -qO ~/install.madsonic.sh http://git.io/Eq97bg && bash ~/install.madsonic.sh
#
############################
## Version History Starts ##
############################
#
# See version.txt
#
############################
### Version History Ends ###
############################
#
############################
###### Variable Start ######
############################
#
# Sets a random port between 6000-50000 for http
http=$(shuf -i 6000-49000 -n 1)
# Defines the memory variable
initmemory="2048"
maxmemory="2048"
# Gets the Java version from the last time this script installed Java
installedjavaversion=$(cat ~/.javaversion 2> /dev/null)
# Java URL
javaupdatev="http://javadl.sun.com/webapps/download/AutoDL?BundleId=87437"
# Madsonic Standalone files
madsonicfv="https://bitbucket.org/feralhosting/feralfiles/downloads/5.0.3880-standalone.zip"
madsonicfvs="5.0.3880-standalone.zip"
# ffmpeg files
mffmpegfvc="https://bitbucket.org/feralhosting/feralfiles/downloads/ffmpeg.02.07.2014.zip"
mffmpegfvcs="ffmpeg.02.07.2014.zip"
#
scripturl="https://raw.github.com/feralhosting/feralfilehosting/master/Feral%20Wiki/Software/Subsonic%20and%20Madsonic/scripts/madsonic/install.madsonic.sh"
#
############################
####### Variable End #######
############################
#
############################
#### Self Updater Start ####
############################
#
mkdir -p "$HOME/bin"
#
if [[ ! -f "$HOME/$scriptname.sh" ]]
then
    wget -qO "$HOME/$scriptname.sh" "$scripturl"
fi
if [[ ! -f "$HOME/bin/$scriptname" ]]
then
    wget -qO "$HOME/bin/$scriptname" "$scripturl"
fi
#
wget -qO "$HOME/000$scriptname.sh" "$scripturl"
#
if ! diff -q "$HOME/000$scriptname.sh" "$HOME/$scriptname.sh" > /dev/null 2>&1
then
    echo '#!/bin/bash
    scriptname="'"$scriptname"'"
    wget -qO "$HOME/$scriptname.sh" "'"$scripturl"'"
    wget -qO "$HOME/bin/$scriptname" "'"$scripturl"'"
    bash "$HOME/$scriptname.sh"
    exit 1' > "$HOME/111$scriptname.sh"
    bash "$HOME/111$scriptname.sh"
    exit 1
fi
if ! diff -q "$HOME/000$scriptname.sh" "$HOME/bin/$scriptname" > /dev/null 2>&1
then
    echo '#!/bin/bash
    scriptname="'"$scriptname"'"
    wget -qO "$HOME/$scriptname.sh" "'"$scripturl"'"
    wget -qO "$HOME/bin/$scriptname" "'"$scripturl"'"
    bash "$HOME/$scriptname.sh"
    exit 1' > "$HOME/222$scriptname.sh"
    bash "$HOME/222$scriptname.sh"
    exit 1
fi
cd && rm -f {000,111,222}"$scriptname.sh"
chmod -f 700 "$HOME/bin/$scriptname"
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
echo -e "The version of the" "\033[33m""Madsonic""\e[0m" "server being used in this script is:" "\033[31m""$madsonicversion""\e[0m"
echo -e "The version of the" "\033[33m""Java""\e[0m" "being used in this script is:" "\033[31m""$javaversion""\e[0m"
echo
if [[ -f "$HOME/private/madsonic/.version" ]]
then
    echo -e "Your currently installed version is:" "\033[32m""$(sed -n '1p' $HOME/private/madsonic/.version)""\e[0m"
    echo
fi
#
#############################
#### madsonicrsk starts  ####
#############################
#
# This section MUST be escaped properly using backslash when adding to it. If you need to see it uncommented, run this script in SSH. It will create the working, uncommented version at ~/bin/madsonicrsk
echo -e "#!/bin/bash
if [[ -d ~/private/madsonic ]]
then
    #
    httpport=\$(sed -n -e 's/MADSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/madsonic/madsonic.sh 2> /dev/null)
    #
    # v 1.2.0  Kill Start Restart Script generated by the Madsonic installer script
    #
    echo
    echo -e \"\\\033[33m1:\\\e[0m This is the process PID:\\\033[32m\$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\\\e[0m used the last time \\\033[36m~/private/madsonic/madsonic.sh\\\e[0m was started.\"
    echo
    echo -e \"\\\033[33m2:\\\e[0m This is the URL that Madsonic is configured to use:\"
    echo
    echo -e \"\\\033[31mMadsonic\\\e[0m last accessible at \\\033[31mhttps://\$(hostname -f)/\$(whoami)/madsonic/\\\e[0m\"
    echo
    echo -e \"\\\033[33m3:\\\e[0m Running instances checks:\"
    echo
    echo -e \"Checking to see, specifically, if the \\\033[32m\$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\\\e[0m is running\"
    echo -e \"\\\033[32m\"
    if [[ -z \"\$(ps -p \$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null)\" ]]
    then
        echo -e \"Nothing to show.\"
        echo -e \"\\\e[0m\"
    else
        ps -p \$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null
        echo -e \"\\\e[0m\"
    fi
    if [[ \"\$(ps -U \$(whoami) | grep -c java)\" -gt \"1\" ]]
    then
        echo -e \"There are currently \\\033[31m\$(ps -U \$(whoami) | grep -c java 2> /dev/null)\\\e[0m running Java processes.\"
        echo -e \"\\\033[31mWarning:\\\e[0m \\\033[32mMadsonic might not load or be unpredicatable with multiple instances running.\\\e[0m\"
        echo -e \"\\\033[33mIf there are multiple Madsonic processes please use the killall by using option [a] then use the restart option.\\\e[0m\"
        echo -e \"\\\033[31m\"
        ps -U \$(whoami) | grep java
        echo -e \"\\\e[0m\"
    fi
    echo -e \"\\\033[33m4:\\\e[0m Options for killing and restarting Madsonic:\"
    echo
    echo -e \"\\\033[36mKill PID only\\\e[0m \\\033[31m[y]\\\e[0m \\\033[36mKillall java processes\\\e[0m \\\033[31m[a]\\\e[0m \\\033[36mSkip to restart (where you can quit the script)\\\e[0m \\\033[31m[r]\\\e[0m\"
    echo
    read -ep \"Please press one of these options [y] or [a] or [r] and press enter: \"  confirm
    echo
    if [[ \$confirm =~ ^[Yy]\$ ]]
    then
        kill -9 \$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) 2> /dev/null
        echo -e \"The process PID:\\\033[31m\$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\\\e[0m that was started by the installer or custom scripts has been killed.\"
        echo
        echo -e \"Checking to see if the PID:\\\033[32m\$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\\\e[0m is running:\\\e[0m\"
        echo -e \"\\\033[32m\"
        if [[ -z \"\$(ps -p \$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null)\" ]]
        then
            echo -e \"Nothing to show, job done.\"
            echo -e \"\\\e[0m\"
        else
            ps -p \$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null
            echo -e \"\\\e[0m\"
        fi
    elif [[ \$confirm =~ ^[Aa]\$ ]]
    then
        killall -9 -u \$(whoami) java 2> /dev/null
        echo -e \"\\\033[31mAll java processes have been killed\\\e[0m\"
        echo
        echo -e \"\\\033[33mChecking for open java processes:\\\e[0m\"
        echo -e \"\\\033[32m\"
        if [[ -z \"\$(ps -U \$(whoami) | grep java 2> /dev/null)\" ]]
        then
            echo -e \"Nothing to show, job done.\"
            echo -e \"\\\e[0m\"
        else
            ps -U \$(whoami) | grep java
            echo -e \"\\\e[0m\"
        fi
    else
        echo -e \"Skipping to restart or quit\"
        echo
    fi
    if [[ -f ~/private/madsonic/madsonic.sh ]]
    then
        read -ep \"Would you like to restart Madsonic? [r] reload the kill features? [l] or quit the script? [q]: \"  confirm
        echo
        if [[ \$confirm =~ ^[Rr]\$ ]]
        then
            if [[ -z \"\$(ps -p \$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null)\" ]]
            then
                bash ~/private/madsonic/madsonic.sh
                echo -e \"Started Madsonic at PID:\\\033[31m\$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\\\e[0m\"
                echo
                echo -e \"\\\033[31mMadsonic\\\e[0m last accessible at \\\033[31mhttps://\$(hostname -f)/\$(whoami)/madsonic/\\\e[0m\"
                echo -e \"\\\033[32m\"
                if [[ -z \"\$(ps -p \$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null)\" ]]
                then
                    echo -e \"Nothing to show, job done.\"
                    echo -e \"\\\e[0m\"
                else
                    ps -p \$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) --no-headers 2> /dev/null
                    echo -e \"\\\e[0m\"
                fi
                exit 1
            else
                echo -e \"Madsonic with the PID:\\\033[32m\$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)\\\e[0m is already running. Kill it first then restart\"
                echo
                read -ep \"Would you like to restart the RSK script and reload it? [y] or quit the script? [q] : \"  confirmrsk
                echo
                if [[ \$confirmrsk =~ ^[Yy]\$ ]]
                then
                    bash ~/bin/madsonicrsk
                fi
                exit 1
            fi
        elif [[ \$confirm =~ ^[Ll]\$ ]]
        then
            echo -e \"\\\033[31mReloading madsonicrsk to access kill features.\\\e[0m\"
            echo
            bash ~/bin/madsonicrsk
        else
            echo This script has done its job and will now exit.
            echo
            exit 1
        fi
    else
        echo
        echo -e \"The \\\033[31m~/private/madsonic/madsonic.sh\\\e[0m does not exist.\"
        echo -e \"please run the \\\033[31m~/install.madsonic\\\e[0m to install and configure madsonic\"
        exit 1
    fi
else
    echo -e \"Madsonic is not installed\"
fi" > ~/bin/madsonicrsk
#
#############################
##### madsonicrsk ends  #####
#############################
#
#############################
#### madsonicron starts  ####
#############################
#
echo '#!/bin/bash
echo "$(date +"%H:%M on the %d.%m.%y")" >> madsonicrun.log
if [[ -z "$(ps -p $(cat ~/private/madsonic/madsonic.sh.PID) --no-headers)" ]]
then
    bash ~/private/madsonic/madsonic.sh
else
    exit 1
fi' > ~/bin/madsonicron
#
#############################
##### madsonicron ends  #####
#############################
#
# Make the ~/bin/madsonicrsk and ~/bin/madsonicron files we created executable
chmod -f 700 ~/bin/madsonicrsk
chmod -f 700 ~/bin/madsonicron
#
#############################
##### proxypass starts  #####
#############################
#
# Apache proxypass
if [[ -f ~/private/madsonic/madsonic.sh ]]
then
    echo -en 'Include /etc/apache2/mods-available/proxy.load\nInclude /etc/apache2/mods-available/proxy_http.load\nInclude /etc/apache2/mods-available/headers.load\nInclude /etc/apache2/mods-available/ssl.load\n\nProxyRequests Off\nProxyPreserveHost On\nProxyVia On\nSSLProxyEngine on\n\nProxyPass /madsonic http://10.0.0.1:'$(sed -n -e 's/MADSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/madsonic/madsonic.sh 2> /dev/null)'/${USER}/madsonic\nProxyPassReverse /madsonic http://10.0.0.1:'$(sed -n -e 's/MADSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/madsonic/madsonic.sh 2> /dev/null)'/${USER}/madsonic\nRedirect /${USER}/madsonic https://${APACHE_HOSTNAME}/${USER}/madsonic' > "$HOME/.apache2/conf.d/madsonic.conf"
    /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
    # Nginx proxypass
    if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
    then
        echo -e 'location /madsonic {\nproxy_set_header        Host            $http_x_host;\nproxy_set_header        X-Real-IP       $remote_addr;\nproxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;\nrewrite /madsonic/(.*) /'$(whoami)'/madsonic/$1 break;\nproxy_pass http://10.0.0.1:'$(sed -n -e 's/MADSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/madsonic/madsonic.sh 2> /dev/null)'/'$(whoami)'/madsonic/;\nproxy_redirect http:// https://;\n}' > ~/.nginx/conf.d/000-default-server.d/madsonic.conf
        /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
    fi
    echo -e "The" "\033[36m""nginx/apache proxypass""\e[0m" "has been installed."
    echo
    echo -e "Madsonic is accessible at:" "\033[32m""https://$(hostname -f)/$(whoami)/madsonic/""\e[0m"
    echo
fi
#
#############################
###### proxypass ends  ######
#############################
#
echo -e "The" "\033[36m""~/bin/madsonicrsk""\e[0m" "has been updated."
echo
read -ep "The scripts have been updated, do you wish to continue [y] or exit now [q] : " updatestatus
echo
if [[ "$updatestatus" =~ ^[Yy]$ ]]
then
#
############################
#### User Script Starts ####
############################
#
    mkdir -p ~/private
    echo -e "\033[31m""User Notice:""\e[0m" "\033[33m""This is a user supported script. Please don't expect or ask staff to support this directly.\nTo get support you can jump on IRC and ask other users for help.\nAll critical bugs should be reported and bug fixes or improvements are welcomed and encouraged.""\e[0m"
    echo
    sleep 2
    #
    #############################
    #### Install Java Start  ####
    #############################
    #
    if [[ ! -f ~/bin/java && -f ~/.javaversion ]]
    then
        cd && rm -f ~/.javaversion
        export installedjavaversion=""
    fi
    if [[ "$installedjavaversion" != "$javaversion" ]]
    then
        echo "Please wait a moment while java is installed"
        rm -rf ~/private/java
        wget -qO ~/java.tar.gz "$javaupdatev"
        tar xf ~/java.tar.gz
        cp -rf ~/jre"$jvdecimal"/. "$HOME/"
        rm -f ~/java.tar.gz
        rm -rf ~/jre"$jvdecimal"
        echo -n "$javaversion" > ~/.javaversion
        # we create a custom Java version file for comparison so the installer only runs once
        echo -e "\033[31m""Important:""\e[0m" "Java" "\033[32m""$javaversion""\e[0m" "has been installed to" "\033[36m""$HOME/""\e[0m"
        echo
        echo -e "This Script needs to exit for the Java changes to take effect. Please restart the Script using this command:"
        echo
        echo 'bash ~/install.madsonic.sh'
        echo
        bash
        exit 1
    fi
    #
    #############################
    ##### Install Java End  #####
    #############################
    #
    if [[ ! -d ~/private/madsonic ]]
    then
        echo -e "Congratulations," "\033[31m""Java is installed""\e[0m"". Continuing with the installation."
        sleep 1
        echo
        echo -e "Path" "\033[36m""~/private/madsonic/""\e[0m" "created. Moving to next step."
        mkdir -p ~/sonictmp
        mkdir -p ~/private/madsonic/transcode
        mkdir -p ~/private/madsonic/playlists
        mkdir -p ~/private/madsonic/Incoming
        mkdir -p ~/private/madsonic/Podcast
        mkdir -p ~/private/madsonic/playlist-import
        mkdir -p ~/private/madsonic/playlist-export
        echo -n "$madsonicfvs" > ~/private/madsonic/.version
        echo
        echo -e "\033[32m""$madsonicfvs""\e[0m" "Is downloading now."
        wget -qO ~/sonictmp/madsonic.zip "$madsonicfv"
        echo -e "\033[36m""$madsonicfvs""\e[0m" "Has been downloaded and renamed to" "\033[36m""madsonic.zip\e[0m"
        echo -e "\033[36m""madsonic.zip""\e[0m" "Is unpacking now."
        unzip -qo ~/sonictmp/madsonic.zip -d ~/private/madsonic
        echo -e "\033[36m""madsonic.zip""\e[0m" "Has been unpacked to" "\033[36m""~/private/madsonic/\e[0m"
        sleep 1
        echo
        echo -e "\033[32m""$mffmpegfvcs""\e[0m" "Is downloading now."
        wget -qO ~/sonictmp/ffmpeg.zip "$mffmpegfvc"
        echo -e "\033[36m""$mffmpegfvcs""\e[0m" "Has been downloaded and renamed to" "\033[36m""ffmpeg.tar.gz\e[0m"
        echo -e "\033[36m""$mffmpegfvcs""\e[0m" "Is being unpacked now."
        unzip -qo ~/sonictmp/ffmpeg.zip -d ~/private/madsonic/transcode/
        chmod -f 700 ~/private/madsonic/transcode/{Audioffmpeg,ffmpeg,lame,xmp}
        echo -e "\033[36m""$mffmpegfvcs""\e[0m" "Has been unpacked to" "\033[36m~/private/madsonic/transcode/\e[0m"
        rm -rf ~/sonictmp
        sleep 1
        echo
        echo -e "\033[32m""Copying over a local version of lame.""\e[0m"
        # cp -f /usr/local/bin/lame ~/private/madsonic/transcode/ 2> /dev/null
        chmod -f 700 ~/private/madsonic/transcode/lame
        echo -e "Lame copied to" "\033[36m""~/private/madsonic/transcode/\e[0m"
        sleep 1
        echo
        echo -e "\033[32m""Copying over a local version of Flac.""\e[0m"
        cp -f /usr/bin/flac ~/private/madsonic/transcode/ 2> /dev/null
        chmod -f 700 ~/private/madsonic/transcode/flac
        echo -e "Flac copied to" "\033[36m""~/private/madsonic/transcode/""\e[0m"
        sleep 1
        echo
        echo -e "\033[31m""Configuring the start-up script.""\e[0m"
        echo -e "\033[35m""User input is required for this next step:""\e[0m"
        echo -e "\033[33m""Note on user input:""\e[0m" "It is OK to use a relative path like:" "\033[33m""~/private/rtorrent/data""\e[0m"
        sed -i 's|MADSONIC_HOME=/var/madsonic|MADSONIC_HOME=~/private/madsonic|g' ~/private/madsonic/madsonic.sh
        sed -i "s/MADSONIC_PORT=4040/MADSONIC_PORT=$http/g" ~/private/madsonic/madsonic.sh
        sed -i 's|MADSONIC_CONTEXT_PATH=/|MADSONIC_CONTEXT_PATH=/$(whoami)/madsonic|g' ~/private/madsonic/madsonic.sh
        sed -i "s/MADSONIC_INIT_MEMORY=256/MADSONIC_INIT_MEMORY=$initmemory/g" ~/private/madsonic/madsonic.sh
        sed -i "s/MADSONIC_MAX_MEMORY=350/MADSONIC_MAX_MEMORY=$maxmemory/g" ~/private/madsonic/madsonic.sh
        sed -i '0,/MADSONIC_PIDFILE=/s|MADSONIC_PIDFILE=|MADSONIC_PIDFILE=~/private/madsonic/madsonic.sh.PID|g' ~/private/madsonic/madsonic.sh
        read -ep "Enter the path to your media or leave blank and press enter to skip: " path
        sed -i "s|MADSONIC_DEFAULT_MUSIC_FOLDER=/var/media|MADSONIC_DEFAULT_MUSIC_FOLDER=$path|g" ~/private/madsonic/madsonic.sh
        sed -i 's|MADSONIC_DEFAULT_UPLOAD_FOLDER=/var/media/Incoming|MADSONIC_DEFAULT_UPLOAD_FOLDER=~/private/madsonic/Incoming|g' ~/private/madsonic/madsonic.sh
        sed -i 's|MADSONIC_DEFAULT_PODCAST_FOLDER=/var/media/Podcast|MADSONIC_DEFAULT_PODCAST_FOLDER=~/private/madsonic/Podcast|g' ~/private/madsonic/madsonic.sh
        sed -i 's|MADSONIC_DEFAULT_PLAYLIST_IMPORT_FOLDER=/var/media/playlist-import|MADSONIC_DEFAULT_PLAYLIST_IMPORT_FOLDER=~/private/madsonic/playlist-import|g' ~/private/madsonic/madsonic.sh
        sed -i 's|MADSONIC_DEFAULT_PLAYLIST_EXPORT_FOLDER=/var/media/playlist-export|MADSONIC_DEFAULT_PLAYLIST_EXPORT_FOLDER=~/private/madsonic/playlist-export|g' ~/private/madsonic/madsonic.sh
        sed -i 's/quiet=0/quiet=1/g' ~/private/madsonic/madsonic.sh
        sed -i "23 i export LC_ALL=en_GB.UTF-8\n" ~/private/madsonic/madsonic.sh
        sed -i '23 i export LANG=en_GB.UTF-8' ~/private/madsonic/madsonic.sh
        sed -i '23 i export LANGUAGE=en_GB.UTF-8' ~/private/madsonic/madsonic.sh
        # Apache proxypass
        echo -en 'Include /etc/apache2/mods-available/proxy.load\nInclude /etc/apache2/mods-available/proxy_http.load\nInclude /etc/apache2/mods-available/headers.load\nInclude /etc/apache2/mods-available/ssl.load\n\nProxyRequests Off\nProxyPreserveHost On\nProxyVia On\nSSLProxyEngine on\n\nProxyPass /madsonic http://10.0.0.1:'"$http"'/${USER}/madsonic\nProxyPassReverse /madsonic http://10.0.0.1:'"$http"'/${USER}/madsonic\nRedirect /${USER}/madsonic https://${APACHE_HOSTNAME}/${USER}/madsonic' > "$HOME/.apache2/conf.d/madsonic.conf"
        /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
        echo
        # Nginx proxypass
        if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
        then
            echo -e 'location /madsonic {\nproxy_set_header        Host            $http_x_host;\nproxy_set_header        X-Real-IP       $remote_addr;\nproxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;\nrewrite /madsonic/(.*) /'$(whoami)'/madsonic/$1 break;\nproxy_pass http://10.0.0.1:'"$http"'/'$(whoami)'/madsonic/;\nproxy_redirect http:// https://;\n}' > ~/.nginx/conf.d/000-default-server.d/madsonic.conf
            /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
        fi
        echo -e "\033[31m""Start-up script successfully configured.""\e[0m"
        echo "Executing the start-up script now."
        bash ~/private/madsonic/madsonic.sh
        echo -e "A restart/start/kill script has been created at:" "\033[35m""~/bin/madsonicrsk""\e[0m"
        echo -e "\033[32m""Madsonic is now started, use the links below to access it. Don't forget to set path to FULL path to you music folder in the gui.""\e[0m"
        sleep 1
        echo
        echo -e "Madsonic is accessible at:" "\033[32m""https://$(hostname -f)/$(whoami)/madsonic/""\e[0m"
        echo -e "It may take a minute or two to load properly."
        echo
        echo -e "Madsonic started at PID:" "\033[31m""$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)""\e[0m"
        echo
        bash
        exit 1
    else
        echo -e "\033[31m""Madsonic appears to already be installed.""\e[0m" "Please kill the PID:" "\033[33m""$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)""\e[0m" "if it is running and delete the" "\033[36m""~/private/madsonic directory""\e[0m"
        echo
        read -ep "Would you like me to kill the process and remove the directories for you? [y] or update your installation [u] quit now [q]: "  confirm
        echo
        if [[ "$confirm" =~ ^[Yy]$ ]]
        then
            echo "Killing the process and removing files."
            kill -9 $(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) 2> /dev/null
            echo -e "\033[31m" "Done""\e[0m"
            sleep 1
            echo "Removing ~/private/madsonic"
            rm -rf ~/private/madsonic
            echo -e "\033[31m" "Done""\e[0m"
            sleep 1
            echo "Removing RSK scripts if present."
            rm -f ~/bin/madsonic.4.8
            rm -f ~/madsonic.4.8.sh
            rm -f ~/madsonicstart.sh
            rm -f ~/madsonicrestart.sh
            rm -f ~/madsonickill.sh
            rm -f ~/madsonicrsk.sh
            rm -f ~/bin/madsonicrsk
            rm -f ~/bin/madsonicron
            rm -f ~/.nginx/conf.d/000-default-server.d/madsonic.conf
            rm -f ~/.apache2/conf.d/madsonic.conf
            /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
            /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
            echo -e "\033[31m" "Done""\e[0m"
            sleep 1
            echo "Finalising removal."
            rm -rf ~/private/madsonic
            echo -e "\033[31m" "Done and Done""\e[0m"
            echo
            sleep 1
            read -ep "Would you like you relaunch the installer [y] or quit [q]: "  confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]
            then
                echo
                echo -e "\033[32m" "Relaunching the installer.""\e[0m"
                if [[ -f ~/"$scriptname".sh ]] 
                then
                    bash ~/"$scriptname".sh
                else
                    wget -qO ~/"$scriptname".sh "$scripturl"
                    bash ~/"$scriptname".sh
                fi
            else
                exit 1
            fi
        elif [[ "$confirm" =~ ^[Uu]$ ]]
        then
            echo -e "Madsonic is being updated. This will only take a moment."
            kill -9 $(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null) 2> /dev/null
            mkdir -p ~/sonictmp
            wget -qO ~/madsonic.zip "$madsonicfv"
            unzip -qo ~/madsonic.zip -d ~/sonictmp
            rm -f ~/sonictmp/madsonic.sh
            cp -rf ~/sonictmp/. ~/private/madsonic/
            wget -qO ~/ffmpeg.zip "$mffmpegfvc"
            unzip -qo ~/ffmpeg.zip -d ~/private/madsonic/transcode
            chmod -f 700 ~/private/madsonic/transcode/{Audioffmpeg,ffmpeg,lame,xmp}
            echo -n "$madsonicfvs" > ~/private/madsonic/.version
            rm -rf ~/madsonic.zip ~/ffmpeg.zip ~/sonictmp
            sed -i 's|^MADSONIC_CONTEXT_PATH=/$|MADSONIC_CONTEXT_PATH=/$(whoami)/madsonic|g' ~/private/madsonic/madsonic.sh
            # Apache proxypass
            echo -en 'Include /etc/apache2/mods-available/proxy.load\nInclude /etc/apache2/mods-available/proxy_http.load\nInclude /etc/apache2/mods-available/headers.load\nInclude /etc/apache2/mods-available/ssl.load\n\nProxyRequests Off\nProxyPreserveHost On\nProxyVia On\nSSLProxyEngine on\n\nProxyPass /madsonic http://10.0.0.1:'$(sed -n -e 's/MADSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/madsonic/madsonic.sh 2> /dev/null)'/${USER}/madsonic\nProxyPassReverse /madsonic http://10.0.0.1:'$(sed -n -e 's/MADSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/madsonic/madsonic.sh 2> /dev/null)'/${USER}/madsonic\nRedirect /${USER}/madsonic https://${APACHE_HOSTNAME}/${USER}/madsonic' > "$HOME/.apache2/conf.d/madsonic.conf"
            /usr/sbin/apache2ctl -k graceful > /dev/null 2>&1
            echo
            # Nginx proxypass
            if [[ -d ~/.nginx/conf.d/000-default-server.d ]]
            then
                echo -e 'location /madsonic {\nproxy_set_header        Host            $http_x_host;\nproxy_set_header        X-Real-IP       $remote_addr;\nproxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;\nrewrite /madsonic/(.*) /'$(whoami)'/madsonic/$1 break;\nproxy_pass http://10.0.0.1:'$(sed -n -e 's/MADSONIC_PORT=\([0-9]\+\)/\1/p' ~/private/madsonic/madsonic.sh 2> /dev/null)'/'$(whoami)'/madsonic/;\nproxy_redirect http:// https://;\n}' > ~/.nginx/conf.d/000-default-server.d/madsonic.conf
                /usr/sbin/nginx -s reload -c ~/.nginx/nginx.conf > /dev/null 2>&1
            fi
            bash ~/private/madsonic/madsonic.sh
            echo -e "A restart/start/kill script has been created at:" "\033[35m""~/bin/madsonicrsk""\e[0m"
            echo -e "\033[32m""Madsonic is now started, use the link below to access it. Don't forget to set path to FULL path to you music folder in the gui.""\e[0m"
            sleep 1
            echo
            echo -e "Madsonic is accessible at:" "\033[32m""https://$(hostname -f)/$(whoami)/madsonic/""\e[0m"
            echo -e "It may take a minute or two to load properly."
            echo
            echo -e "Madsonic started at PID:" "\033[31m""$(cat ~/private/madsonic/madsonic.sh.PID 2> /dev/null)""\e[0m"
            echo
            bash
            exit 1
        else
            echo "You chose to quit and exit the script"
            echo
            exit 1
        fi
    fi
#
############################
##### User Script End  #####
############################
#
else
    echo -e "You chose to exit after updating the scripts."
    echo
    exit 1
    cd && bash
fi
#
############################
##### Core Script Ends #####
############################
#