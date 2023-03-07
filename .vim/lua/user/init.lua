--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below
-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key

local gs = require("gitsigns")
-----local vim = require("vim")

local plugin_disabled = { disable = true }

function highlight_uninvert(name)
	local hl = vim.api.nvim_get_hl_by_name(name, vim.o.termguicolors)
	if hl.reverse then
		hl.reverse, hl.background, hl.foreground = false, hl.foreground, hl.background
		vim.api.nvim_set_hl(0, name, hl)
	end
end

local config = {

	-- Configure AstroNvim updates
	updater = {
		remote = "origin", -- remote to use
		channel = "stable", -- "stable" or "nightly"
		version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
		branch = "main", -- branch name (NIGHTLY ONLY)
		commit = nil, -- commit hash (NIGHTLY ONLY)
		pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
		skip_prompts = false, -- skip prompts about breaking changes
		show_changelog = true, -- show the changelog after performing an update
		auto_reload = true, -- automatically reload and sync packer after a successful update
		auto_quit = false, -- automatically quit the current session after a successful update
	},

	-- Set colorscheme to use
	colorscheme = "gruvbox",

	-- Add highlight groups in any theme
	highlights = {
		-- init = { -- this table overrides highlights in all themes
		--   Normal = { bg = "#000000" },
		-- }
		-- duskfox = { -- a table of overrides/changes to the duskfox theme
		--   Normal = { bg = "#000000" },
		-- },
	},

	-- set vim options here (vim.<first_key>.<second_key> = value)
	options = {
		opt = {
			-- set to true or false etc.
			spell = false, -- sets vim.opt.spell
			-- basic display options
			number = true, -- show line numbers
			relativenumber = false, -- show *absolute* line numbers
			signcolumn = "auto", -- only show lint column on fail
			wrap = true, -- wrap long lines

			wildmode = "longest:full",
			wildmenu = true, -- a menu for resolving ambiguous tab-completion
			wildignore = "*.pyc,*.sw[pno],.*.bak,.*.tmp", -- files we never want to edit

			laststatus = 3, -- global status line
			colorcolumn = "+1,+2,+3,+4,+5", -- often I want to know when/if I've exceeded 80 columns
			scrolloff = 3, -- keep three lines visible above and below
			updatetime = 500, -- CursorHold (show type) after 0.5s (up from 0.3s)

			-- make whitespace characters visible:
			listchars = "tab:→\\ ,extends:»,precedes:«,nbsp:␠,trail:␠",
			list = true,

			-- searching {
			incsearch = true, -- search as you type
			hlsearch = true, -- highlight the search
			ignorecase = true, -- ignore case
			smartcase = true, --  ...unless the search uses uppercase letters
			-- } searching

			-- Moving left/right will wrap around to the previous/next line.
			whichwrap = "b,s,h,l,<,>,~,[,]",
			-- Backspace will delete whatever is behind your cursor.
			backspace = "indent,eol,start",

			-- multiple files {
			-- be smarter about multiple buffers / vim instances
			hidden = true,
			autoread = true, -- auto-reload files, if there's no conflict
			shortmess = vim.opt.shortmess + {
				I = true, -- no intro message
				A = true, -- no swap-file message
				F = false, -- allow for debugging echo
			},
			-- } multiple files

			clipboard = "",
		},
		g = {
			mapleader = "\\", -- sets vim.g.mapleader
			autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
			heirline_bufferline = true, -- enable new heirline based bufferline (requires :PackerSync after changing)

			clipboard = {
				name = "SendViaOSC52",
				copy = {
					["+"] = vim.fn["SendClipboardViaOSC52"],
				},
				paste = {
					["+"] = function()
						return { "Sup, bro." }
					end,
				},
				cache_enabled = 1,
			},
			-- vnoremap y y:call SendViaOSC52(getreg('"'))<cr>
			-- vnoremap <C-c> y:call SendViaOSC52(getreg('"'))<cr>

			-- suggested by :checkhealth; stop checking stuff that I don't plan to use
			loaded_perl_provider = 0,
			loaded_node_provider = 0,
			loaded_ruby_provider = 0,
		},
	},

	-- If you need more control, you can use the function()...end notation
	-- options = function(local_vim)
	--   local_vim.opt.relativenumber = true
	--   local_vim.g.mapleader = " "
	--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
	--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
	--
	--   return local_vim
	-- end,

	-- Default theme configuration
	default_theme = {
		-- enable or disable highlighting for extra plugins
		plugins = {
			aerial = true,
			beacon = false,
			bufferline = true,
			cmp = true,
			dashboard = true,
			highlighturl = true,
			hop = false,
			indent_blankline = true,
			lightspeed = false,
			["neo-tree"] = false,
			notify = true,
			["nvim-tree"] = false,
			["nvim-web-devicons"] = true,
			rainbow = true,
			symbols_outline = false,
			telescope = true,
			treesitter = true,
			vimwiki = false,
			["which-key"] = true,
		},
	},

	-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
	diagnostics = {
		virtual_text = true,
		underline = true,
		update_in_insert = false,
	},

	-- Extend LSP configuration
	lsp = {
		formatting = {
			-- control auto formatting on save
			timeout_ms = 1000, -- default format timeout
		},
		["server-settings"] = {
			--
		},
	},

	-- Mapping data with "desc" stored directly by vim.keymap.set().
	--
	-- Please use this mappings table to set keyboard mapping since this is the
	-- lower level configuration and more robust one. (which-key will
	-- automatically pick-up stored data by this setting.)
	mappings = {
		-- first key is the mode
		n = {
			-- buffer
			["//"] = false,
			["<leader>bc"] = {
				"<cmd>BufferLinePickClose<cr>",
				desc = "Pick to close",
			},
			["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
			["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
			["<leader>bd"] = { "<cmd>bn | bd#<cr>", desc = "buffer delete" },

			-- f: file
			["<leader>fd"] = { "<cmd>:e %:h<cr>", desc = "explore directory" },
			["<leader>fx"] = { "<cmd>!set -x; chmod 755 %<cr>", desc = "chmod executable" },
			["<leader>fX"] = { "<cmd>!set -x; chmod 644 %<cr>", desc = "chmod non-executable" },
			-- d: diff
			["<leader>df"] = { "<cmd>call DiffToggle()<CR>", desc = "toggle diff" },
			["<leader>dw"] = { "<cmd>call DiffToggleWhitespace()<CR>", desc = "toggle whitespace" },
			["<leader>pf"] = {
				'<cmd>put =expand(v:count ? "#" . v:count : "%")<cr>',
				desc = "paste filename",
			},
			-- l: lsp
			["<leader>lg"] = { "<cmd>vim.lsp.buf.type_definition()<cr>", desc = "Goto Definition" },
			["<leader>lh"] = { "<cmd>vim.lsp.buf.hover()<cr>", desc = "Hover" },
			-- g: git
			["<leader>ga"] = { "<cmd>!git add %<cr>", desc = "git add" },
			["<leader>gD"] = {
				function()
					gs.diffthis("~")
				end,
				desc = "git diff HEAD",
			},
			["<leader>gb"] = { gs.blame_line, desc = "git blame" },

			["<leader>gu"] = { gs.undo_stage_hunk, desc = "unstage hunk" },
			["<leader>gU"] = { gs.reset_buffer_index, desc = "unstage buffer" },

			["<leader>ga"] = { gs.stage_hunk, desc = "add hunk" },
			["<leader>gA"] = { "<cmd>silent !git -C %:h add -f %:t<cr>", desc = "add buffer" },

			["<leader>gr"] = { gs.reset_hunk, desc = "revert hunk" },
			["<leader>gR"] = { gs.reset_buffer, desc = "revert buffer" },
			-- quick buffer switching
			["<TAB>"] = {
				"<cmd>bn<cr>",
				desc = "next buffer",
			},
			["<S-TAB>"] = {
				"<cmd>bp<cr>",
				desc = "prev buffer",
			},
		},
		v = {
			["y"] = {
				'"+y',
				desc = "copy to clipboard",
			},
			["p"] = {
				"P",
				desc = "paste (without copy)",
			},
		},
		t = {
			-- setting a mapping to false will disable it
			-- ["<esc>"] = false,
		},
	},

	-- Configure plugins
	plugins = {
		init = {
			---- disabled built-in plugins

			-- gets things wrong too often
			["Darazaki/indent-o-matic"] = plugin_disabled,
			-- overly-helpful insertion of parens and quotes
			["windwp/nvim-autopairs"] = plugin_disabled,
			-- replace with maintained fork
			["p00f/nvim-ts-rainbow"] = plugin_disabled,
			["mrjones2014/nvim-ts-rainbow"] = {},

			---- syntaxen
			["bfrg/vim-jq"] = {},

			---- custom additional plugins:

			-- autoconfiguration via https://editorconfig.org/
			["editorconfig/editorconfig-vim"] = {},
			-- debugging for nvim lua
			["jbyuki/one-small-step-for-vimkind"] = {
				requires = { "nvim-dap" },
				module = "osv",
			},
			-- the One True Colorscheme
			["morhetz/gruvbox"] = {},
			-- sensible behavior for zoom (AKA ctrl-w_o, AKA :only)
			["troydm/zoomwintab.vim"] = {},

			-- movements integrated with treesitter
			["nvim-treesitter/nvim-treesitter-textobjects"] = { after = "nvim-treesitter" },

			-- We also support a key value style plugin definition similar to NvChad:
			-- ["ray-x/lsp_signature.nvim"] = {
			--   event = "BufRead",
			--   config = function()
			--     require("lsp_signature").setup()
			--   end,
			-- },
		},

		-- All other entries override the require("<key>").setup({...}) call for default plugins
		["neo-tree"] = {
			window = {
				width = 20,
				mappings = {
					-- https://github.com/AstroNvim/AstroNvim/blob/main/lua/configs/neo-tree.lua#L38
					["<space>"] = { "open" },
					["-"] = { "navigate_up" },
					["%"] = { "add" },
					["o"] = false,
				},
			},
			filesystem = {
				follow_current_file = false,
			},
		},
		["null-ls"] = function(config)
			local null_ls = require("null-ls")

			-- Check supported formatters and linters
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
			config.sources = {
				null_ls.builtins.formatting.terraform_fmt,
				null_ls.builtins.diagnostics.tfsec,
				null_ls.builtins.formatting.stylua,
				-- Set a formatter
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.black.with({
					extra_args = {
						"--skip-magic-trailing-comma",
						"--line-length=79",
					},
				}),
			}
			return config -- return final config table
		end,
		heirline = function(config)
			local statusline, winbar, bufferline = unpack(config)
			statusline[1] = astronvim.status.component.mode({ mode_text = { padding = { left = 1, right = 1 } } })

			if bufferline then
				bufferline[2] = astronvim.status.heirline.make_buflist(astronvim.status.component.tabline_file_info({
					close_button = false,
					unique_path = false,
					filename = {
						fallback = "(new)",
						fname = function(nr)
							local bufname = vim.api.nvim_buf_get_name(nr)
							if bufname == "main.tf" then
								bufname = string.format("<%s>", vim.fs.basename(vim.fs.dirname(buf.path)))
							else
								bufname = vim.fs.basename(bufname)
							end
							return bufname .. " " .. nr
						end,
						modify = false,
					},
				}))
			end

			return { statusline, winbar, bufferline }
		end,
		-- bufferline = {
		-- 	options = {
		-- 		numbers = "buffer_id",
		-- 		name_formatter = function(buf)
		-- 			if buf.name == "main.tf" then
		-- 				return string.format("<%s>", vim.fs.basename(vim.fs.dirname(buf.path)))
		-- 			end
		-- 		end,
		-- 	},
		-- },
		treesitter = { -- overrides `require("treesitter").setup(...)`
			ensure_installed = { "python", "lua", "terraform", "vim" },
			indent = { enable = true, disable = { "python" } },
			rainbow = {
				enable = true,
				disable = {}, -- list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = 99999, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			},
			textobjects = {
				select = {
					enable = true,
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
			},
		},
		-- use mason-lspconfig to configure LSP installations
		["mason-lspconfig"] = { -- overrides `require("mason-lspconfig").setup(...)`
			-- ensure_installed = { "sumneko_lua" },
			ensure_installed = { "pyright", "terraformls", "tflint", "vimls" },
		},
		-- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
		["mason-null-ls"] = { -- overrides `require("mason-null-ls").setup(...)`
			ensure_installed = { "tfsec", "terraform_fmt", "wat" },
		},
		["mason-nvim-dap"] = { -- overrides `require("mason-nvim-dap").setup(...)`
			-- ensure_installed = { "python" },
		},
	},

	-- LuaSnip Options
	luasnip = {
		-- Extend filetypes
		filetype_extend = {
			-- javascript = { "javascriptreact" },
		},
		-- Configure luasnip loaders (vscode, lua, and/or snipmate)
		vscode = {
			-- Add paths for including more VS Code style snippets in luasnip
			paths = {},
		},
	},

	-- CMP Source Priorities
	-- modify here the priorities of default cmp sources
	-- higher value == higher priority
	-- The value can also be set to a boolean for disabling default sources:
	-- false == disabled
	-- true == 1000
	cmp = {
		source_priority = {
			nvim_lsp = 1000,
			luasnip = 750,
			buffer = 500,
			path = 250,
		},
	},

	-- Customize Heirline options
	heirline = {
		-- -- Customize different separators between sections
		separators = {
			tab = { "", "" },
		},
		-- -- Customize colors for each element each element has a `_fg` and a `_bg`
		-- colors = function(colors)
		--   colors.git_branch_fg = astronvim.get_hlgroup "Conditional"
		--   return colors
		-- end,
		-- -- Customize attributes of highlighting in Heirline components
		-- attributes = {
		--   -- styling choices for each heirline element, check possible attributes with `:h attr-list`
		--   git_branch = { bold = true }, -- bold the git branch statusline component
		-- },
		-- -- Customize if icons should be highlighted
		-- icon_highlights = {
		--   breadcrumbs = false, -- LSP symbols in the breadcrumbs
		--   file_icon = {
		--     winbar = false, -- Filetype icon in the winbar inactive windows
		--     statusline = true, -- Filetype icon in the statusline
		--   },
		-- },
	},

	-- Modify which-key registration (Use this with mappings table in the above.)
	["which-key"] = {
		-- Add bindings which show up as group name
		register = {
			-- first key is the mode, n == normal mode
			n = {
				-- second key is the prefix, <leader> prefixes
				["<leader>"] = {
					-- third key is the key to bring up next level and its displayed
					-- group name in which-key top level menu
					["b"] = { name = "Buffer" },
					["d"] = { name = "Diff" },
					["p"] = { name = "Put" },
				},
			},
		},
	},

	-- This function is run last and is a good place to configuring
	-- augroups/autocommands and custom filetypes also this just pure lua so
	-- anything that doesn't fit in the normal config locations above can go here
	polish = function()
		-- stop disabling search highlight
		vim.on_key(nil, vim.api.nvim_get_namespaces()["auto_hlsearch"])

		-- todo: surely there's a better way to not fight whichkey
		vim.api.nvim_set_keymap("n", "\\", '<Cmd>lua require("which-key").show("\\\\", {mode = "n", auto = true})<CR>', {
			silent = true,
			noremap = true,
		})

		-- undo a few of the default mappings
		vim.api.nvim_del_keymap("n", "\\")
		vim.api.nvim_del_keymap("n", "\\q")
		---- print(1)
		---- print(
		---- 	"astronvim(33)",
		---- 	vim.inspect(vim.tbl_filter(function(t)
		---- 		return t.lhs == "\\"
		---- 	end, vim.api.nvim_get_keymap("n")))
		---- )
		---- print(2)
		vim.api.nvim_del_keymap("n", "\\c")
		vim.api.nvim_del_keymap("n", "\\d")
		vim.api.nvim_del_keymap("n", "Q")
		------print("astronvim", vim.inspect(astronvim))

		-- vim.api.nvim_del_keymap('n', '\\s')
		-- vim.api.nvim_del_keymap('n', '\\S')
		-- vim.api.nvim_del_keymap('n', '\\f')
		-- vim.api.nvim_del_keymap('n', '\\t')
		-- vim.api.nvim_del_keymap('n', '\\u')

		-- gruvbox's inverted highlight groups makes heirline confused
		-- highlight_uninvert("Error")
		highlight_uninvert("StatusLine")
		-- highlight_uninvert("StatusLineNC")
		-- highlight_uninvert("TabLineFill")
		-- highlight_uninvert("TabLineSel")
		-- highlight_uninvert("TabLine")

		-- -- -- vim.cmd("source /Users/buck/.vimrc")
		-- Set up custom filetypes
		vim.filetype.add({
			extension = {
				["js.tmpl"] = "javascript",
				["css.tmpl"] = "css",
				pxi = "pyrex",
				md = "markdown",
				proto = "proto",
				hcl = "terraform",
				tfvars = "terraform",
				jq = "jq",
			},
			filename = {
				[".envrc"] = "bash",
			},
			pattern = {
				-- ["~/%.config/foo/.*"] = "fooscript",
			},
		})
		vim.api.nvim_create_autocmd("DiagnosticChanged", {
			callback = function()
				vim.diagnostic.setqflist({ open = false })
			end,
		})
	end,
}

return config
