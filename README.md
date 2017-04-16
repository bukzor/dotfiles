These are my dotfiles. There are many like it, but these are mine.

---

Quick setup: (copy-paste to terminal)

    git clone --no-checkout git@github.com:bukzor/dotfiles.git  tmp-dotfiles
    mv tmp-dotfiles/.git .
    rmdir tmp-dotfiles
    git checkout  -f
    git submodule update --init
