-- use nvimtree for browsing directories (not netrw, nor lir)
lvim.builtin.lir.active = false

-- use nvimtree for DirOpen
lvim.builtin.nvimtree.setup = vim.tbl_extend(
  "force",
  lvim.builtin.nvimtree.setup,
  {
    disable_netrw = true,
    hijack_netrw = true,
    hijack_directories = {
      enable = true,
      auto_open = true,
    },
    change_dir = { enable = false },
    sort = {
      sorter = "name",
      folders_first = true,
    },
    update_focused_file = {
      enable = true,
      update_cwd = false,
      update_root = false,
    },
    actions = {
      open_file = {
        window_picker = {
          exclude = {
            buftype = { "nofile" },
          },
        },
      },
    },
  }
)
