#!/not/executable/sh
# Single-user Nix (buck-win10 today; inert where it isn't installed). Ported
# from the installer's line in wsl-buck-win10's .profile. nix.sh isn't
# idempotent (it prepends PATH and appends XDG_DATA_DIRS unconditionally), and
# env.d is re-sourced by .bashrc/.zshenv, so skip once its NIX_PROFILES export
# is inherited. Numbered below 900-path.sh so ~/bin and friends still win.
if [ -z "${NIX_PROFILES:-}" ]; then
  trysource "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
