#!/bin/bash
create_new_user() {
  # check if user is running as sudo
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
  fi

  read -p "Enter the new user's name: " username
  read -s -p "Enter the password for $username: " password

  sudo useradd -m -G root -s /bin/bash "$username"
  echo "$username:$password" | sudo chpasswd

  su - "$username" <<'EOF'
      kdir -p ~/.config

        if [ -f /etc/os-release ]; then
            source /etc/os-release
            case $ID in
                ubuntu|debian)
                    sudo apt update
                    sudo apt install -y git curl wget vim neovim tmux zsh python3
                    ;;
                centos|rhel)
                    sudo yum install -y git curl wget vim neovim tmux zsh python3
                    ;;
            esac
        fi

        git clone https://github.com/username/dotfiles.git ~/dotfiles

        ln -s ~/dotfiles/dots/zsh/rc.zsh ~/.zshrc
        ln -s ~/dotfiles/dots/zsh/zsh_plugins.txt ~/.zsh_plugins.txt

        ln -s ~/dotfiles/dots/neovim/init.vim ~/.config/nvim/init.vim
        ln -s ~/dotfiles/dots/neovim/coc-settings.json ~/.config/nvim/coc-settings.json
EOF
}
