# ===== 基础设置 =====
# 编辑器
export EDITOR='vim'
export VISUAL='vim'

# 目录行为
setopt AUTO_CD

# 历史记录设置
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# 路径设置
export PATH="$HOME/.local/bin:$PATH"

# ===== 插件管理 =====
# 定义 zinit 安装路径
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"

# 检查 zinit 是否已安装
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  # 加载 zinit
  source "${ZINIT_HOME}/zinit.zsh"
  
  # 加载补全系统
  autoload -Uz compinit && compinit

  # 立即加载的核心插件
  # powerlevel10k 主题
  zinit ice depth=1 time-limit=15
  zinit light romkatv/powerlevel10k
  
  # zsh-vi-mode: vi 模式需要优先加载
  zinit ice depth=1 time-limit=15
  zinit light jeffreytse/zsh-vi-mode
  
  # 延迟加载的插件
  # zsh-completions: 补全定义
  zinit ice wait lucid time-limit=15
  zinit light zsh-users/zsh-completions
  
  # fzf-tab: fzf 补全增强
  zinit ice wait lucid time-limit=15
  zinit light Aloxaf/fzf-tab
  
  # zsh-autosuggestions: 自动补全建议
  zinit ice wait lucid atload'!_zsh_autosuggest_start' time-limit=15
  zinit light zsh-users/zsh-autosuggestions
  
  # zsh-history-substring-search: 历史搜索
  zinit ice wait lucid time-limit=15
  zinit light zsh-users/zsh-history-substring-search
  
  # fast-syntax-highlighting: 语法高亮（最后加载）
  zinit ice wait lucid atinit'zpcompinit; zpcdreplay' time-limit=15
  zinit light zdharma-continuum/fast-syntax-highlighting
else
  echo "\033[33m警告: zinit 未安装，部分功能不可用\033[0m"
  autoload -Uz compinit && compinit
fi

# ===== Vim 模式设置 =====
bindkey -v
export KEYTIMEOUT=1
ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL

# ===== 按键绑定 =====
# 历史搜索绑定
bindkey '^[[A' history-substring-search-up 2>/dev/null || bindkey '^[[A' up-line-or-history
bindkey '^[[B' history-substring-search-down 2>/dev/null || bindkey '^[[B' down-line-or-history
bindkey -M vicmd 'k' history-substring-search-up 2>/dev/null || bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' history-substring-search-down 2>/dev/null || bindkey -M vicmd 'j' down-line-or-history

# ===== 别名设置 =====
# 常用别名
alias vi='vim'
alias lg='lazygit'
# 检查 trash 命令是否存在
if command -v trash &>/dev/null; then
  alias rm='trash'
  alias tl='trash-list'
  alias tr='trash-restore'
  alias te='trash-empty'
fi

# git 别名
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# tmux 别名
alias tn='tmux new -s'
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'

# 目录导航
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ===== 工具初始化 =====
# zoxide 初始化
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# P10K 主题配置
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh