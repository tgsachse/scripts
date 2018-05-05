# Full desktop installation script for Red Hat systems
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

function quick_check {
    case $1 in
        -q|-Q|--quick)
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}


### CONSTANTS ###
D_INSTALL="$(pwd)/installation"
D_DOTFILES="$HOME/.git_dotfiles"
QUICK="$(quick_check $1)"


### SETUP ###
# Clone script repository
if procedure_check "prepare for installation";
then
    git clone https://www.github.com/tgsachse/scripts.git $D_INSTALL
fi

# Check that system is up to date
if procedure_check "update system";
then
    sudo dnf update
    sudo dnf upgrade -y
fi


### UTILITIES ###
# Install useful terminal utilities, UCF VPN, and goofy stuff
if procedure_check "install utilities and goofy stuff";
then
    sudo dnf install -y git neovim vpnc network-manager-vpnc
    sudo dnf install -y fortune cowsay lolcat
fi

# Run SpOnGe install script
if procedure_check "run SpOnGe script";
then
    bash $D_INSTALL/scripts/install_sponge.sh
fi


### CUSTOMIZATION ###
# Install dotfiles from GitHub
if procedure_check "install dotfiles";
then
    git clone https://www.github.com/tgsachse/dotfiles.git $D_DOTFILES
    bash $D_DOTFILES/install.sh
fi

# Install Cinnamon DE
if procedure_check "install Cinnamon";
then
    sudo add-dnf-repository ppa:embrosyn/cinnamon
    sudo dnf-get update
    sudo dnf-get install -y cinnamon
fi

# Install Plank
if procedure_check "install plank";
then
    sudo dnf install -y plank
fi


### DEVELOPMENT ###
# Install Java9
if procedure_check "install Java9";
then
    sudo add-apt-repository ppa:webupd8team/java
    sudo dnf update
    sudo apt install -y oracle-java9-installer oracle-java9-set-default
fi

# Install C compiler
if procedure_check "install GCC";
then
    sudo dnf install -y gcc
fi

# Install Python tools and projects
if procedure_check "install pip and python stuff";
then
    sudo dnf install -y python3-pip
    /usr/bin/yes | sudo pip3 install selenium enigmamachine
fi


### SOFTWARE ###
# Install Google Chrome
if procedure_check "install Chrome";
then
    cd $D_INSTALL
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
fi

# Install Dropbox
if procedure_check "install and autostart Dropbox";
then
    sudo dnf install -y nautilus-dropbox
    dropbox autostart y
fi


### GAMING ###
# Install Discord
if procedure_check "install Discord";
then
    cd $D_INSTALL
    wget -O discord.deb https://discordapp.com/api/download?platform=linux&format=deb
    sudo apt install libgconf-2-4 libc++1
    sudo apt --fix-broken install
    sudo dpkg -i discord.deb
fi


### CLEANUP ###
if procedure_check "finish installation";
then
    sudo rm -r $D_INSTALL
fi