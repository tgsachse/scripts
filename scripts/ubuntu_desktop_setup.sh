# Full desktop installation script for Ubuntu systems
# Written by Tiger Sachse

### FUNCTIONS ###
function procedure_check {
    echo
    echo "Next process: $1"
    echo "Proceed? (Yes/No/Skip)"
    
    read command
    
    case $command in
        Y|y|yes|Yes)
            echo "Proceeding..."
            return 0
            ;;
        S|s|skip|Skip)
            echo "Skipping..."
            return 1
            ;;
        *)
            echo "Goodbye!"
            exit 0
            ;;
    esac
}


### SCRIPT DIRECTORY ###
D_SCRIPTS="$HOME/.scripts"


### SETUP ###
# install git to clone the scripts repo
if procedure_check "install git";
then
    sudo apt install git -y
    git config --global user.email "tgsachse@gmail.com"
    git config --global user.name "Tiger Sachse"
fi

# Clone script repository
if procedure_check "prepare for installation";
then
    if [ -d $D_SCRIPTS ];
    then
        sudo rm -r $D_SCRIPTS
    fi
    git clone https://www.github.com/tgsachse/scripts.git $D_SCRIPTS
fi

# Check that system is up to date
if procedure_check "update system";
then
    sudo apt update
    sudo apt upgrade -y
fi


### UTILITIES ###
# Install useful terminal utilities, UCF VPN, and goofy stuff
if procedure_check "install utilities and goofy stuff";
then
    sudo apt install -y neovim vpnc network-manager-vpnc tree zsh fish gcc
    sudo apt install -y fortune cowsay lolcat
fi

# Run SpOnGe install script
if procedure_check "run SpOnGe script";
then
    bash $D_SCRIPTS/scripts/install_sponge.sh
fi

if procedure_check "enable firewall";
then
    sudo ufw enable
fi


### CUSTOMIZATION ###
#
if procedure_check "configure home folder";
then
    rm -r $HOME/Music $HOME/Pictures $HOME/Public
    rm -r $HOME/Downloads $HOME/Templates $HOME/Videos
    rm -r $HOME/Desktop $HOME/Documents
    mkdir $HOME/Bin $HOME/Slate
fi

# Install dotfiles from GitHub
if procedure_check "install dotfiles";
then
    bash $D_SCRIPTS/dots/install_dots.sh
fi

# Install icon theme, GTK theme and enable shell themes
if procedure_check "install themes";
then
    sudo add-apt-repository ppa:tista/adapta
    sudo add-apt-repository ppa:papirus/papirus
    sudo apt update
    sudo apt install -y gnome-shell-extensions gnome-tweak-tool
    sudo apt install -y adapta-gtk-theme papirus-icon-theme
    sudo apt install -y chrome-gnome-shell
    gsettings set org.gnome.desktop.interface gtk-theme Adapta
    gsettings set org.gnome.desktop.interface icon-theme Papirus-Adapta
    echo
    echo "You'll need to restart and then use the tweak tool to change the shell theme."
    echo
fi


### DEVELOPMENT TOOLS ###
# Install Java10
if procedure_check "install Java";
then
    sudo add-apt-repository ppa:linuxuprising/java
    sudo apt update
    sudo apt install -y oracle-java10-installer
fi

# Install Python tools and projects
if procedure_check "install pip and python stuff";
then
    sudo apt install -y python3-pip
    /usr/bin/yes | sudo pip3 install selenium enigmamachine
fi


### SOFTWARE ###
# Install Google Chrome
if procedure_check "install Chrome";
then
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
fi

# Install Dropbox
if procedure_check "install and autostart Dropbox";
then
    sudo apt install -y nautilus-dropbox
    dropbox autostart y
fi


### GAMING ###
# Install Discord
if procedure_check "install Discord";
then
    wget -O /tmp/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo apt install libgconf-2-4 libc++1
    sudo apt --fix-broken install
    sudo dpkg -i /tmp/discord.deb
fi

# Install Minecraft
if procedure_check "install Minecraft";
then
    bash $D_INSTALL/scripts/install_minecraft.sh
fi
