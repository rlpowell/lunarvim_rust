. "$HOME/.cargo/env"
source /root/.cargo/env

set -o vi
export PATH=/root/.local/bin:/root/.cargo/bin:/usr/local/cargo/bin:/usr/local/rustup/toolchains/beta-x86_64-unknown-linux-gnu/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
echo "doing lua reload"
lvim -c "lua require('lvim.core.log'):set_level([[info]])" -c 'autocmd User PackerComplete quitall' -c 'LvimCacheReset' -c 'PackerSync'
echo
echo
