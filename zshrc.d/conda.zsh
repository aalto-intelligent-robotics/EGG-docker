#conda stuffs
alias deactivate_conda="conda deactivate"

activate_conda() {
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/home/ros/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/home/ros/conda/etc/profile.d/conda.sh" ]; then
          . "/home/ros/conda/etc/profile.d/conda.sh"
      else
          export PATH="/home/ros/conda/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
  compinit conda
}
