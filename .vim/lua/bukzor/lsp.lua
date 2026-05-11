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
    "basedpyright",  -- python; see docs/dev/adr/2026-05-08-000-replace-pyright-with-basedpyright.md
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
    "black",     -- python
    "isort",     -- python imports
    "prettierd", -- js/ts/css/html/json/jsonc/markdown/yaml/...
    -- gofmt ships with the go toolchain itself, not a mason package.
  },
  -- Linters, driven by nvim-lint, installed via mason-tool-installer.
  linters = {
    "shellcheck",    -- sh/bash
    "dotenv-linter", -- .env files
    "gitlint",       -- git commit messages
    "tfsec",         -- terraform security scan
    -- fish/zsh use the system shell binaries themselves (`-n` syntax check).
    -- glslc ships via brew `shaderc`, not mason.
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
  -- glslc infers shader stage from the on-disk extension
  -- (.vert/.frag/.comp/.geom/.tesc/.tese). A `.glsl` buffer must declare its
  -- stage with `#pragma shader_stage(<stage>)` or the lint run errors out.
  glsl = { "glslc" },
}

M.au_format = "BukzorLspFormat"
M.au_loclist = "BukzorLspLocList"
M.au_lint = "BukzorLint"
M.au_attach = "BukzorLspAttach"
M.lsp_attached = nil

function M.log(...)
  require("mason-core.log").fmt_debug(...)
end

function M.init()
  vim.api.nvim_create_augroup(M.au_format, { clear = true })
  vim.api.nvim_create_augroup(M.au_loclist, { clear = true })
  vim.api.nvim_create_augroup(M.au_lint, { clear = true })
  vim.api.nvim_create_augroup(M.au_attach, { clear = true })

  -- Per-attach setup runs from LspAttach. Pairing the autocmd with its
  -- augroup here (rather than in setup_mason_lspconfig) keeps the reset
  -- pair complete: M.unload() clears the augroup, M.init() reinstalls both
  -- the group and its handler. We can't put on_attach in
  -- vim.lsp.config("*", ...) because lspconfig ships per-server
  -- lsp/<name>.lua files (basedpyright, rust_analyzer, ts_ls, clangd) whose
  -- own on_attach silently overrides the wildcard.
  vim.api.nvim_create_autocmd("LspAttach", {
    group = M.au_attach,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then M.on_attach_lspconfig(client, args.buf) end
    end,
  })

  --hi link LspInlayHint NonText
  --vim.cmd([[
  --  hi link DiagnosticVirtualTextError Comment
  --  hi link DiagnosticVirtualTextWarn NonText
  --  hi link DiagnosticVirtualTextInfo NonText
  --  hi link DiagnosticVirtualTextHint NonText
  --]])
  vim.diagnostic.config({
    virtual_text = {
      spacing = 4,
      prefix = "●",
      severity = { min = vim.diagnostic.severity.HINT },
      -- basedpyright (and pyright, and several other servers) emit multi-line
      -- diagnostic messages where line 2+ restates a slimmer version of line
      -- 1. nvim collapses newlines into the single-line virt_text, so we get
      -- the whole brick. Keep just the first line; the float still shows the
      -- full message.
      format = function(d)
        return (d.message:match("^(.-)\n") or d.message)
      end,
    },
    signs = true,
    underline = true,
    severity_sort = true,
    update_in_insert = false,
    float = { border = "rounded", source = true, header = "" },
    jump = { float = true, wrap = true },
  })

  M.lsp_attached = {}
end

function M.setup()
  M.unload()
  M.init()

  M.setup_mason()
  M.setup_lspconfig()
  M.setup_mason_lspconfig()
  M.setup_mason_tool_installer()
  M.setup_conform()
  M.setup_nvim_lint()
end

function M.unload()
  for _, group in ipairs({ M.au_format, M.au_loclist, M.au_lint, M.au_attach }) do
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
    -- Whitelist: only enable servers we asked for. With the default `true`,
    -- mason-lspconfig enables every *installed* package (see
    -- features/automatic_enable.lua), so orphans from prior installs (e.g.
    -- pyright after the basedpyright swap) keep attaching. Passing a list
    -- gates enable_server() on membership.
    automatic_enable = M.mason_install.lspconfig,
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
