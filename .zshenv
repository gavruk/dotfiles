#! sh

# This file is sourced into all Bourne compatible shells.

ENV="$HOME/.shrc"
BASH_ENV="$HOME/.shenv"
export ENV BASH_ENV

for dir in /usr/local/bin "$HOME/.rbenv/bin" "$HOME/.rbenv/shims" "$HOME/bin"; do
  if [ -d "$dir" ]; then
    PATH="""${dir}:`echo "$PATH"|sed -e "s#${dir}:##"`"
  fi
done

PATH=".git/safe/../../bin:`echo "$PATH"|sed -e 's,\.git/[^:]*bin:,,g'`"

for dir in /usr/lib/surfraw /var/lib/gems/1.9.1/bin /var/lib/gems/1.8/bin /usr/sbin /sbin; do
  if [ -d "$dir" ]; then
    case ":$PATH:" in
      *:"$dir":*) ;;
      *) PATH="$PATH:$dir" ;;
    esac
  fi
done

unset dir
export PATH

if [ -z "$LANG" -a -z "$LC_ALL" -a -f "$HOME/.locale" ]; then
  LANG=`cat "$HOME/.locale"`
  export LANG
fi

if [ -z "$CLASSPATH" ]; then
  CLASSPATH=.
  [ -d "$HOME/.java" ] && CLASSPATH="$CLASSPATH:$HOME/.java/*"
  export CLASSPATH
fi

export RUBYLIB RUBYOPT

if [ -z "$PERL5LIB" ]; then
  for dir in "$HOME/.perl5" "$HOME/perl5" "$HOME/.perl" "$HOME/perl"; do
    case ":$PERL5LIB:" in
      *:"$dir":*) ;;
      *) [ ! -d "$dir" ] || PERL5LIB="$PERL5LIB:$dir"
    esac
  done
  PERL5LIB="`echo "$PERL5LIB"|sed -e 's/^://'`"
  export PERL5LIB
fi

if [ -t 1 ]; then
  RSYNC_RSH='ssh -ax'
else
  RSYNC_RSH='ssh -axqoBatchmode=yes'
fi
LYNX_CFG="$HOME/.lynx.cfg"
export RSYNC_RSH LYNX_CFG

ulim="ulimit -S -u"
$ulim >/dev/null 2>/dev/null || ulim="ulimit -S -p"
unum=2048
[ -z "$CRON" ] || unum=1536
cunum="`$ulim 2>/dev/null`"
case "$cunum" in [0-9]*) ;; *) cunum=65535 ;; esac
[ "$unum" -ge "$cunum" ] || $ulim "$unum" 2>/dev/null
unset ulim unum cunum
