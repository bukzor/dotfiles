local M = {}

-- see ~/.local/state/nvim/mason.log
local mason_log_level = vim.log.levels.DEBUG;

-- mason is in charge of installing various tools
M.mason_install = {
  -- LSP servers, registered with mason-lspconfig
  -- full list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  lspconfig = {
    "rust_analyzer", -- rust
    "lua_ls",        -- lua
    "pyright",       -- python
    "jsonls",        -- json
    "jsonnet_ls",    -- jsonnet
    "tflint",        -- terraform
    "terraformls",   -- terraform-ls: terraform
    "ts_ls",         -- typescript
    "vimls",         -- vim
    "clangd",        -- c/c++
    "gopls",         -- golang
  },
  -- Formatters, driven by conform.nvim, installed via mason-tool-installer.
  -- Mason package names; see https://mason-registry.dev/registry/list.
  formatters = {
    "black",      -- python
    "isort",      -- python imports
    "prettierd",  -- js/ts/css/html/json/jsonc/markdown/yaml/...
    -- gofmt ships with the go toolchain itself, not a mason package.
  },
  -- Linters, driven by nvim-lint, installed via mason-tool-installer.
  linters = {
    "shellcheck",     -- sh/bash
    "dotenv-linter",  -- .env files
    "gitlint",        -- git commit messages
    "tfsec",          -- terraform security scan
    -- fish/zsh use the system shell binaries themselves (`-n` syntax check).
    -- glslc would require shader-stage-aware invocation; deferred.
  },
}

-- conform.nvim formatter pipeline per filetype (run in list order).
M.conform_formatters_by_ft = {
  python = { "isort", "black" },
  javascript = { "prettierd" },
  javascriptreact = { "prettierd" },
  typescript = { "prettierd" },
  typescriptreact = { "prettierd" },
  vue = { "prettierd" },
  svelte = { "prettierd" },
  css = { "prettierd" },
  scss = { "prettierd" },
  less = { "prettierd" },
  html = { "prettierd" },
  json = { "prettierd" },
  jsonc = { "prettierd" },
  yaml = { "prettierd" },
  markdown = { "prettierd" },
  go = { "gofmt" },
}

-- nvim-lint linters per filetype. Linter names match nvim-lint's internal
-- module names (underscores), not mason package names (dashes).
M.lint_linters_by_ft = {
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  fish = { "fish" },
  zsh = { "zsh" },
  dotenv = { "dotenv_linter" },
  gitcommit = { "gitlint" },
  terraform = { "tfsec" },
}

M.au_format = "BukzorLspFormat"
M.au_loclist = "BukzorLspLocList"
M.au_lint = "BukzorLint"
M.lsp_attached = nil

function M.log(...)
  require("mason-core.log").fmt_debug(...)
end

function M.init()
  vim.api.nvim_create_augroup(M.au_format, { clear = true })
  vim.api.nvim_create_augroup(M.au_loclist, { clear = true })
  vim.api.nvim_create_augroup(M.au_lint, { clear = true })

  M.lsp_attached = {}
end

function M.setup()
  M.unload()
  M.init()

  vim.cmd("hi link LspInlayHint Comment")
  M.setup_mason()
  M.setup_lspconfig()
  M.setup_mason_lspconfig()
  M.setup_mason_tool_installer()
  M.setup_conform()
  M.setup_nvim_lint()
end

function M.unload()
  for _, group in ipairs({ M.au_format, M.au_loclist, M.au_lint }) do
    local ok, err = pcall(vim.api.nvim_del_augroup_by_name, group)
    if not ok and err ~= nil and not vim.startswith(err, "Vim:E367: No such group: ") then
      error(err)
    end
  end
  M.lsp_attached = {}
end

function M.setup_mason()
  require("mason").setup({
    log_level = mason_log_level,
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })
end

function M.show_loclist()
  vim.diagnostic.setloclist({ open = false })
  vim.cmd("bo lw 5")
end

function M.setup_lspconfig()
  vim.cmd(":runtime plugin/lspconfig.lua") -- surely there's a better way?
end

function M.on_attach_lspconfig(client, bufnr)
  if client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- prevent jittery rendering by just always showing the sign column
  vim.opt_local.signcolumn = "yes:1"

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
  vim.bo[bufnr].formatexpr = ""
end

function M.setup_mason_lspconfig()
  -- mason-lspconfig 2.0+ replaced setup_handlers with vim.lsp.config + automatic_enable.
  -- Default config applied to every server.
  vim.lsp.config("*", {
    on_attach = M.on_attach_lspconfig,
  })

  vim.lsp.config("rust_analyzer", {
    settings = {
      ["rust-analyzer"] = { diagnostics = { disabled = { "inactive-code" } } },
    },
  })

  for _, server_name in ipairs(M.mason_install.lspconfig) do
    M.lsp_attached[server_name] = "lspconfig"
    M.log("lspconfig handler: %s", server_name)
  end

  require("mason-lspconfig").setup({
    ensure_installed = M.mason_install.lspconfig,
    -- automatic_enable defaults to true: installed servers get vim.lsp.enable()'d.
  })
end

function M.setup_mason_tool_installer()
  local tools = {}
  for _, name in ipairs(M.mason_install.formatters) do
    table.insert(tools, name)
  end
  for _, name in ipairs(M.mason_install.linters) do
    table.insert(tools, name)
  end
  require("mason-tool-installer").setup({
    ensure_installed = tools,
    auto_update = false,
    run_on_start = true,
  })
end

function M.setup_conform()
  require("conform").setup({
    formatters_by_ft = M.conform_formatters_by_ft,
    -- Format on save: use conform's formatters; fall back to attached LSP
    -- formatter (e.g. rust_analyzer for rust, gopls for go-the-LSP, lua_ls).
    format_on_save = function(bufnr)
      if vim.bo[bufnr].readonly or not vim.bo[bufnr].modifiable then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
  })
end

function M.setup_nvim_lint()
  local lint = require("lint")

  -- Custom syntax-only linters for shells whose own binaries do the checking.
  lint.linters.fish = {
    cmd = "fish",
    args = { "--no-execute" },
    stdin = false,
    append_fname = true,
    stream = "stderr",
    ignore_exitcode = true,
    parser = require("lint.parser").from_pattern(
      "([^%s]+) %(line (%d+)%): (.+)",
      { "file", "lnum", "message" },
      nil,
      { source = "fish", severity = vim.diagnostic.severity.ERROR }
    ),
  }
  lint.linters.zsh = {
    cmd = "zsh",
    args = { "-n" },
    stdin = false,
    append_fname = true,
    stream = "stderr",
    ignore_exitcode = true,
    parser = require("lint.parser").from_pattern(
      "([^:]+):(%d+): (.+)",
      { "file", "lnum", "message" },
      nil,
      { source = "zsh", severity = vim.diagnostic.severity.ERROR }
    ),
  }

  lint.linters_by_ft = M.lint_linters_by_ft

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = M.au_lint,
    callback = function()
      require("lint").try_lint()
    end,
    desc = "nvim-lint: try_lint on save / read / leave-insert",
  })
end

function M.update_loclist_if_visible()
  local loclist = vim.fn.getloclist(0, { winid = 0 })
  if loclist.winid ~= 0 then
    vim.diagnostic.setloclist()
  end
end

return M
