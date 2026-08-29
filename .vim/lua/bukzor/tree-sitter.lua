local M = {}

M.treesitter_dir = vim.fn.stdpath("data") .. "/tree-sitters"

M.ensure_installed = {
  "lua",
  "rust",
  "python",
  "terraform",
  "vim",
  "query", -- tree-sitter query.scm files
  "bash",
  "markdown",
  "markdown_inline",
  "latex",
}

M.au_highlight = "BukzorTreesitterHighlight"

local max_filesize = 100 * 1024 -- 100 KB

local function too_big(bufnr)
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  return ok and stats and stats.size > max_filesize
end

-- TODO: register a local jinja2 parser once one exists, e.g.:
-- vim.api.nvim_create_autocmd("User", { pattern = "TSUpdate", callback = function()
--   require("nvim-treesitter.parsers").jinja2 = {
--     install_info = { path = "~/projects/tree-sitter-jinja2" },
--   }
-- end })

-- Auto-install a missing parser (mirrors the old `auto_install = true`) and
-- turn on highlighting for any filetype with an available tree-sitter parser
-- (mirrors the old blanket `highlight.enable = true`).
local function on_filetype(args)
  if too_big(args.buf) then return end

  local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
  local ts = require("nvim-treesitter")

  if not vim.tbl_contains(ts.get_installed("parsers"), lang) then
    if not vim.tbl_contains(ts.get_available(), lang) then return end
    ts.install(lang):wait(120000)
  end

  pcall(vim.treesitter.start, args.buf)
end

function M.init()
  vim.opt.runtimepath:append(M.treesitter_dir)
  require("nvim-treesitter").setup({ install_dir = M.treesitter_dir })

  vim.api.nvim_create_augroup(M.au_highlight, { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = M.au_highlight,
    pattern = "*",
    callback = on_filetype,
  })
end

function M.unload()
  local ok, err = pcall(vim.api.nvim_del_augroup_by_name, M.au_highlight)
  if not ok and err ~= nil and not vim.startswith(err, "Vim:E367: No such group: ") then
    error(err)
  end
end

function M.setup()
  M.unload()
  M.init()
  require("nvim-treesitter").install(M.ensure_installed)
end

return M
