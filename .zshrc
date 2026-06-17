# Kích hoạt p10k (ĐÃ TẮT ĐỂ CHUYỂN SANG STARSHIP)
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="powerlevel10k/powerlevel10k" # Tắt theme p10k
ZSH_THEME="" # Starship sẽ tự động quản lý giao diện
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# --- CẤU HÌNH GỐC CỦA QUÂN ---
alias ls='ls --color=auto'
bindkey -v
export KEYTIMEOUT=1

# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # Tắt cấu hình p10k
export LS_COLORS="$(vivid generate gruvbox-dark-soft)"

# Hàm lfcd: Giúp ở lại thư mục khi thoát lf
lfcd() {
    tmp="$(mktemp)"
    command lf -last-dir-path="$tmp" "$@" 
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
alias lf="lfcd"
export EDITOR="nvim"

# --- CÔNG CỤ HIỆN ĐẠI (Học hỏi thêm) ---
# Dùng lệnh 'eza' để xem icon, 'ls' vẫn là mặc định
alias eza="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias lg="eza -la --icons --git"
alias lt="eza --tree --level=2 --icons -a -I='.git|.cache'"
alias lm="eza -l --sort=modified -r --icons"

# Dùng lệnh 'bat' để xem màu sắc, 'cat' vẫn là mặc định
alias bat="batcat --style=plain"
# Dùng lệnh 'z' để nhảy thư mục nhanh, 'cd' vẫn là mặc định
eval "$(zoxide init zsh)"

# --- LAB DEVOPS ---
swarm-up() {
    echo "🛡️  Đang kích hoạt module ảo hóa..."
    sudo modprobe kvm-intel

    echo "🚀 Đang đánh thức các node..."
    # Tắt Docker host trước để nhường tài nguyên
    if systemctl is-active --quiet docker; then
        sudo systemctl stop docker.socket && sudo systemctl stop docker
    fi
    
    multipass start --all
    echo "📋 Trạng thái các node:"
    multipass list
}

swarm-down() {
    echo "💤 Đang cho các node đi ngủ..."
    multipass stop --all
    
    # Tùy chọn: Tự động bật lại Docker host khi đóng Lab
    echo "🐳 Khởi động lại Docker trên máy host..."
    sudo systemctl start docker
}

alias sinfo="multipass list"


# --- KHỞI ĐỘNG STARSHIP ---
eval "$(starship init zsh)"

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# --- FZF PRO CONFIGURATION ---
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --margin=1 --padding=1 \
--color=bg+:#323d43,bg:#2d353b,spinner:#a7c080,hl:#e67e80 \
--color=fg:#d3c6aa,header:#a7c080,info:#dbbc7f,pointer:#a7c080 \
--color=marker:#e67e80,fg+:#d3c6aa,prompt:#d699b6,hl+:#e67e80 \
--prompt='🚀 ' --pointer='▶' --marker='✓'"

# Preview file nội dung khi tìm kiếm (Dùng batcat)
export FZF_CTRL_T_OPTS="--preview 'batcat --style=numbers --color=always --line-range :500 {}'"
# Preview thư mục khi nhảy (Dùng eza)
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons {} | head -200'"

# Tích hợp fzf-tab (Nếu bạn muốn dùng tab để chọn)
# source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null
# source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null
