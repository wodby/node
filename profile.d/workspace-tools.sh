# Keep tools installed in the user's persistent home visible in login shells.
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
case ":$PATH:" in
    *":$HOME/.npm-global/bin:"*) ;;
    *) export PATH="$HOME/.npm-global/bin:$PATH" ;;
esac
export PATH="$PATH:${APP_ROOT:-/usr/src/app}/node_modules/.bin"
