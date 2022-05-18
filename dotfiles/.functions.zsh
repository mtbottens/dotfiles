download_latest_rubymine() {
  echo "Installing latest RubyMine"

  RM_VERSION_LINK=$(curl -s https://data.services.jetbrains.com/products\?code\=RM\&release.type\=eap%2Crc%2Crelease\&fields\=distributions%2Clink%2Cname%2Creleases | python3 -c "import sys, json; print(json.load(sys.stdin)[0]['releases'][0]['downloads']['linux']['link'])")
  mkdir -p /home/spin/.cache/rubymine
  curl -L $RM_VERSION_LINK --output /tmp/rubymine.tar.gz
  tar -zxf /tmp/rubymine.tar.gz -C /home/spin/.cache/rubymine
  ~/.cache/rubymine/*/bin/remote-dev-server.sh registerBackendLocationForGateway
}

install_latest_rubymine() {
  download_latest_rubymine

  ERROR_CODE=$?
  if [[ $ERROR_CODE -ne 0 ]]; then
    echo "Error installing RubyMine"
  fi
}

register_spin_with_jetbrains() {
  ~/dotfiles/ruby/update-jetbrains-ssh-connections.rb
}

if [[ $SPIN ]]; then
  # todo: latest needs to be replaced with version of extracted rubymine archive, can get this value from curl request
  if [[ ! -d ~/home/spin/.cache/rubymine ]]; then
    install_latest_rubymine
  fi
fi

if which spin > /dev/null; then
  # register spin domains with JetBrains IDE's
  register_spin_with_jetbrains
fi
