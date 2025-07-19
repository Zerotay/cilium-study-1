###############################################################################
# 1. vagrant
###############################################################################
vagrant up

vagrant scp k8s-ctr:config config
mv ~/.kube/config ~/.kube/config.backup
mv config ~/.kube/config
#NIC=$(ip -j a | jq -r '.[] | select(any(.addr_info[]?; .broadcast == "192.168.10.255")) | .ifname')
#ip route add 192.168.10.100 $NIC

###############################################################################
# 2. install cilium cli
###############################################################################
cilium >/dev/null 2>&1
if [ $? -ne 0 ];then

  CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
  CLI_ARCH=amd64
  if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
  curl -L --fail --remote-name-all "https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}"
  sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
  sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
  rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

  # auto completion if using zsh, oh-my-zsh
  echo $0 | grep zsh -q
  if [ $? -eq 0 ]; then
    echo "auto completion setting for zsh"
    mkdir -p ~/.oh-my-zsh/custom/plugins/cilium
    cilium completion zsh >> ~/.oh-my-zsh/custom/plugins/cilium/cilium.plugin.zsh
    # This should be tested on your zshrc for sure
    sed -i '/^plugins=/a \  cilium' ~/.zshrc
    source ~/.zshrc
  else
    echo "auto completion setting for bash"
    echo "If you want auto complete for other shell, do it your own"
    cilium completion bash >> ~/.bashrc
    source ~/.bashrc

  fi
fi

cilium version

###############################################################################
# 3. install cilium
###############################################################################
cilium install --version 1.17.5
cilium status
cilium connectivity test