set -lx prefix "[steal-lxc-image]"
set -lx mirror "https://mirrors.bfsu.edu.cn"
set -lx logger "info"
argparse -i -n $prefix 'm/mirror=' 'l/logger=' -- $argv
if set -q _flag_mirror
    set mirror $_flag_mirror
end
if set -q _flag_logger
    set logger $_flag_logger
end
switch $argv[1]
case steal
    steal
case '*'
    help_echo
end
