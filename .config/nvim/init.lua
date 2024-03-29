-- 便利関数
function read_file(path)
  local file = io.open(path, "r") -- ファイルを読み込みモードで開く
  if not file then return nil end -- ファイルが開けなかった場合はnilを返す
  local content = file:read("*a") -- 全ての内容を読み込む
  file:close() -- ファイルを閉じる
  return content
end

function endswith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

-- folke/lazy.nvimの設定
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup {
				sort_by = "case_sensitive", view = {
					width = 30,
				},
				renderer = {
					group_empty = true,
					highlight_opened_files = "icon",
				},
				filters = {
					dotfiles = true,
				},
			}
			vim.g.loaded_netrw = 1 -- nvim-treeを使うためnetrwは無効化
			vim.g.loaded_netrwPlugin = 1
		end,
		keys = {
			{'<Space>e', ':NvimTreeToggle<CR>', desc = 'NvimTreeToggle: エクスプローラーON, OFF'},
			{'<Space>E', ':NvimTreeFindFile<CR>', desc = 'NvimTreeToggle: エクスプローラーON, OFF, カレントファイルを開く'},
		}
	},
	{
		'nvim-telescope/telescope.nvim', branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			"nvim-telescope/telescope-live-grep-args.nvim",
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
			},
		},
		lazy = false,
		keys = {
			{'<Space>p', ':Telescope find_files<CR>', desc = 'Telescope: ファイル名検索, file name search'},
			{'<Space>F', ':Telescope live_grep search=<CR>', desc = 'Telescope: ファイル内検索, full text search'},
			{'<Space>f', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", desc = 'Telescope: ファイル内検索+引数, full text search'},
			{'<Space>a', ":lua require('telescope').extensions.live_grep_args.live_grep_args({vimgrep_arguments = {'ag', '--vimgrep', '--column'}})<CR>", desc = 'Telescope: ファイル内検索+引数+ag, full text search'},
			{'<Space>P', ':Telescope keymaps<CR>', desc = 'Telescope: コマンドパレット, command pallet'},
			{'<Space>b', ':Telescope buffers<CR>', desc = 'Telescope: 開いてるファイル, buffers'},
			{'<Space>tgs', ':Telescope git_status<CR>', desc = 'Telescope: 編集済み, git status'},
			{'gr', ':Telescope lsp_references<CR>', desc = 'Telescope: 使用箇所'},
			{'gi', ':Telescope lsp_implementations<CR>', desc = 'Telescope: 実装ジャンプ'}, -- 例えばReactだと、コンポーネントの実装箇所に飛べる
			{'gd', ':Telescope lsp_definitions<CR>', desc = 'Telescope: 定義ジャンプ'}, -- 例えばReactだと、コンポーネントの定義箇所(FunctionComponent)に飛べる
			{'<Space>gt', ':Telescope lsp_type_definitions<CR>', desc = 'Telescope: 型定義ジャンプ'},
			{'ge', ':Telescope diagnostics<CR>', desc = 'Telescope: エラー一覧'},
		},
		config = function()
			require("telescope").setup {
				pickers = {
					buffers = {
						show_all_buffers = true,
						sort_lastused = true,
						sort_mru = true,
						theme = "dropdown",
						previewer = false,
						mappings = {
							i = {
								["<c-d>"] = "delete_buffer",
							},
							n = {
								["d"] = "delete_buffer",
							}
						}
					}
				}
			}
			require('telescope').load_extension('fzf')
			require("telescope").load_extension("live_grep_args")
		end
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup {
				signs      = {
					add          = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
					change       = { hl = 'GitSignsChange', text = '+', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
					delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
					topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
					changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
					untracked    = { hl = 'GitSignsAdd', text = '┆', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map('n', ']c', function()
						if vim.wo.diff then return ']c' end
						vim.schedule(function() gs.next_hunk() end)
						return '<Ignore>'
					end, {expr=true, desc = 'Gitsigns: next hunk'})

					map('n', '[c', function()
						if vim.wo.diff then return '[c' end
						vim.schedule(function() gs.prev_hunk() end)
						return '<Ignore>'
					end, {expr=true, desc = 'Gitsigns: prev hunk'})

					-- Actions
					map('n', '<Space>hs', gs.stage_hunk, {desc = 'Gitsigns: git add hunk'})
					map('n', '<Space>hr', gs.reset_hunk, {desc = 'Gitsigns: discard change'})
					map('v', '<Space>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Gitsigns: git add'})
					map('v', '<Space>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Gitsigns: discard change'})
					map('n', '<Space>hS', gs.stage_buffer, {desc = 'Gitsigns: git add [current buffer]'})
					map('n', '<Space>hu', gs.undo_stage_hunk, {desc= 'Gitsigns: undo last hunk'})
					map('n', '<Space>hR', gs.reset_buffer, {desc = 'Gitsigns: undo hunk [in buffer]'})
					map('n', '<Space>hp', gs.preview_hunk, {desc = 'Gitsigns: preview hunk VSCodeの差分の緑赤'})
					map('n', '<Space>hd', gs.diffthis, {desc = 'Gitsigns: 差分をみながら編集. 左側を:q'})
					map('n', '<Space>gb', gs.toggle_current_line_blame, {desc = 'Gitsigns: ブレームをトグル, toggle current line blame'})
				end
			}
		end
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'neovim/nvim-lspconfig',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup {
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "copilot", group_index = 2 },
					{ name = "nvim_lsp", group_index = 2 },
					{ name = "path", group_index = 2 },
					{ name = "luasnip", group_index = 2 },
				}, {
					{ name = 'buffer', keyword_length = 2 },
				})
			}
			cmp.setup.filetype('gitcommit', {
				sources = cmp.config.sources({
					{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
				}, {
					{ name = 'buffer' },
				})
			})
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{ name = 'cmdline' }
				})
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = true,
	},
	{ 'sheerun/vim-polyglot' },
	{
		'echasnovski/mini.clue',
		version = '*',
		config = function()
			local miniclue = require('mini.clue')
			miniclue.setup {
				window = {
					delay = 500,
					config = {
						width = "auto"
					},
				},
				triggers = {
					{ mode = 'n', keys = '<Space>' },
				},
				clues = {
					{ mode = 'n', keys = '<Space>g', desc = '+git' },
					{ mode = 'n', keys = '<Space>h', desc = '+hunk' },
					{ mode = 'n', keys = '<Space>i', desc = '+indent' },
					-- Enhance this by adding descriptions for <Leader> mapping groups
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
			}
		end
	},
	{
		"sindrets/diffview.nvim",
		keys = {
			{'<Space>gh', ':DiffviewFileHistory -n=20000 %<CR>', desc = 'DiffviewFileHistory: Git File History'},
			{'<Space>gs', ':DiffviewOpen<CR>', desc = 'DiffviewOpen: VSCode source control'},
			{'<Space>gc', ':DiffviewFileHistory<CR>', desc = 'DiffviewFileHistory: VSCode commits'},
			{'<Space>gC', ':DiffviewFileHistory -n=20000<CR>', desc = 'DiffviewFileHistory: VSCode commits more'},
		},
		lazy = false,
	},
	{
		"ruifm/gitlinker.nvim",
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {
			opts = {
				action_callback = function(url)
					if enabled_osc52() then
						require("osc52").copy(url)
					else
						require("gitlinker.actions").copy_to_clipboard(url)
					end
				end,
				mappings = nil,
			}
		},
		keys = {
			{ '<Space>gl', '<cmd>lua require"gitlinker".get_buf_range_url("n")<CR>', desc = 'GitLinker: コピーpermalink', mode = 'n'},
			{ '<Space>gl', '<cmd>lua require"gitlinker".get_buf_range_url("v")<CR>', desc = 'GitLinker: コピーpermalink', mode = 'v'},
		},
	},
	{
		"zbirenbaum/copilot.lua",
		config = function()
			local ostype = vim.loop.os_uname().sysname
			local node_absolute_path = 'node'
			if ostype == 'Linux' then
				node_absolute_path = '/home/kajiri/.nvm/versions/node/v20.10.0/bin/node' --linux
			elseif ostype == 'Darwin' then
				node_absolute_path = '/Users/kajiri/.nvm/versions/node/v20.10.0/bin/node' --mac
			else
				node_absolute_path = 'node'
			end
			require("copilot").setup {
				suggestion = {
					enabled = false, -- copilot-cmpを使っているので無効化
					auto_trigger = true,
					keymap = {
						accept = "¬", -- alt + l
						accept_word = "Ò", -- alt + L
						accept_line = false,
						next = "‘", -- alt + ]
						prev = "“", -- alt + [
						dismiss = "<C-]>",
					},
				},
				panel = {
					enabled = false, -- copilot-cmpを使っているので無効化
				},
				copilot_node_command = node_absolute_path
			}
		end
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "neovim/nvim-lspconfig" },
		},
		config = function()
			local lspconfig = require("lspconfig")
			require("mason-lspconfig").setup_handlers({
					function(server_name)
						local opts = {
							capabilities = require('cmp_nvim_lsp').default_capabilities(),
						}
						lspconfig[server_name].setup(opts)
					end,
				})
			vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(_)
						vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>', {desc = 'LSP: フォーマット'})
						vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {desc = 'LSP: 宣言ジャンプ'})
					end
				})

			vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
				vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
				)
		end
	},
	{
		'ojroques/nvim-osc52',
    enabled = enabled_osc52,
		init = function()
			local au_copy = function()
				if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
					require("osc52").copy_register("+")
				end
				if vim.v.event.operator == "y" and vim.v.event.regname == "" then
					require("osc52").copy_register("")
				end
			end
			vim.api.nvim_create_autocmd("TextYankPost", { callback = au_copy })
		end,
		opts = {
			silent = true,
		}
	},
	--{
	--	"folke/tokyonight.nvim",
	--	lazy = false,
	--	priority = 1000,
	--	config = function()
	--		vim.cmd.colorscheme "tokyonight"
	--	end
	--},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme "kanagawa-wave"
		end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ':TSUpdate',
	},
	{
		"nvimdev/lspsaga.nvim",
	    config = function()
				require('lspsaga').setup({
						ui = {
							code_action = "💡",
						},
						lightbulb = {
							enable = false,
						}
					})
				local function show_documentation()
					local ft = vim.opt.filetype._value
					if ft == 'vim' or ft == 'help' then
						vim.cmd([[execute 'h ' . expand('<cword>') ]])
					else
						vim.cmd('Lspsaga hover_doc')
					end
				end
				vim.keymap.set('n', 'K', show_documentation)
				vim.keymap.set('n', 'g]', '<cmd>Lspsaga diagnostic_jump_next<CR>')
				vim.keymap.set('n', 'g[', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
			end,
			dependencies = {
				'nvim-treesitter/nvim-treesitter',
				'nvim-tree/nvim-web-devicons',
			}
	},
	{
		"okuuva/auto-save.nvim",
		opts = {
			enabled = true,
			trigger_events = { -- See :h events
				immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
				defer_save = {}, -- { "InsertLeave", "TextChanged" } 元々は入力モードを抜けると保存されていたが、それだと追加の変更を行うつもりの時に困る。特に、GatsbyとかのHotReloadが有効になっていると、勝手に保存されて構文エラーで落ちる。非常に面倒であったため、無効にした。
				cancel_defered_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
			},
		},
	},
	{
		'smoka7/hop.nvim',
		version = "*",
		config = function()
			require('hop').setup()
			local hop = require('hop')
			local directions = require('hop.hint').HintDirection
			vim.keymap.set('', 'f', function()
				hop.hint_char1()
			end, {remap=true})
		end
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			vim.opt.listchars:append "eol:↴"
			vim.opt.list = true

			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require "ibl.hooks"
			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			require("ibl").setup { indent = { highlight = highlight }, enabled = false }
			vim.keymap.set("n", "<Space>it", ':IBLToggle<CR>', {desc = 'IBL: インデントガイドラインON, OFF'})
		end,
	},
	{
		"rebelot/heirline.nvim",
		config = function()
			local utils = require("heirline.utils")
			local colors = {
				bright_bg = utils.get_highlight("Folded").bg,
				bright_fg = utils.get_highlight("Folded").fg,
				red = utils.get_highlight("DiagnosticError").fg,
				dark_red = utils.get_highlight("DiffDelete").bg,
				green = utils.get_highlight("String").fg,
				blue = utils.get_highlight("Function").fg,
				gray = utils.get_highlight("NonText").fg,
				orange = utils.get_highlight("Constant").fg,
				purple = utils.get_highlight("Statement").fg,
				cyan = utils.get_highlight("Special").fg,
				diag_warn = utils.get_highlight("DiagnosticWarn").fg,
				diag_error = utils.get_highlight("DiagnosticError").fg,
				diag_hint = utils.get_highlight("DiagnosticHint").fg,
				diag_info = utils.get_highlight("DiagnosticInfo").fg,
				git_del = utils.get_highlight("diffDeleted").fg,
				git_add = utils.get_highlight("diffAdded").fg,
				git_change = utils.get_highlight("diffChanged").fg,
			}
			local conditions = require("heirline.conditions")
			local GitDir = {
				{
					init = function(self)
						local handle = io.popen("basename -s .git $(dirname $(git config --get remote.origin.url 2>/dev/null) 2>/dev/null) 2>/dev/null")
						local owner = handle:read("*a"):gsub("\n", "") or ""
						handle:close()

						local handle = io.popen("basename -s .git $(git config --get remote.origin.url) 2>/dev/null")
						local repository = handle:read("*a"):gsub("\n", "") or ""
						handle:close()

						local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
						local branch = handle:read("*a"):gsub("\n", "") or ""
						handle:close()
						
						local git = ""
						if owner ~= "" and repository ~= "" then
							git = owner .. "/" .. repository
							if branch ~= "" then
								-- gitsigns_status_dictがnilの場合またはgit_signs_status_dict.headがcwdのbranchと異なる場合は、cwdのgitのbranchを追加
								if vim.b.gitsigns_status_dict == nil or vim.b.gitsigns_status_dict.head ~= branch then
									git = git .. "  " .. branch
								end
							end
						end
						git = git .. " "
						self.git = git
					end,

					hl = { fg = colors.gray },

					provider = function(self)
						return self.git
					end,
				}
			}
			local GitFile = {
				condition = conditions.is_git_repo,

				init = function(self)
					self.status_dict = vim.b.gitsigns_status_dict
					self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
				end,

				hl = { fg = colors.gray },


				{   -- git branch name
					provider = function(self)
						return " " .. self.status_dict.head
					end,
					hl = { bold = true }
				},
				-- You could handle delimiters, icons and counts similar to Diagnostics
				{
					condition = function(self)
						return self.has_changes
					end,
					provider = "("
				},
				{
					provider = function(self)
						local count = self.status_dict.added or 0
						return count > 0 and ("+" .. count)
					end,
					hl = { fg = colors.git_add },
				},
				{
					provider = function(self)
						local count = self.status_dict.removed or 0
						return count > 0 and ("-" .. count)
					end,
					hl = { fg = colors.git_del },
				},
				{
					provider = function(self)
						local count = self.status_dict.changed or 0
						return count > 0 and ("~" .. count)
					end,
					hl = { fg = colors.git_change },
				},
				{
					condition = function(self)
						return self.has_changes
					end,
					provider = ")",
				},
			}
			require("heirline").setup({
					statusline = {GitDir, GitFile},
				})
			vim.opt.laststatus = 3
		end
	},
	{
		"https://tpope.io/vim/fugitive.git",
	},
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		config = function()
			require("toggleterm").setup {
				size = 20,
				open_mapping = [[<c-j>]],
				shading_factor = 1,
			}
		end
	},
	{
		'kajirikajiri/git-modified-search.nvim',
		config = true
	},
	{
		'wakatime/vim-wakatime',
		event = "VeryLazy"
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
					sources = {
						null_ls.builtins.formatting.stylua,
						null_ls.builtins.diagnostics.eslint,
						null_ls.builtins.completion.spell,
					},
				})
		end,

		-- 
		enabled = function()
			local dirnames = read_file(os.getenv("HOME") .. "/ghq/github.com/kajirikajiri/env/nvim/folke/lazy.nvim/nvimtools/none-ls.nvim/enabled.env") or ""
			for dirname in string.gmatch(dirnames, "[^\r\n]+") do
				if dirname == "" then -- 空文字は無視
					return false
				end
				if endswith(vim.fn.getcwd(), dirname) then
					return true
				end
			end
			
			return false
		end
	},
})


-- vimの設定
vim.opt.termguicolors = true -- set termguicolors to enable highlight groups
vim.opt.clipboard = 'unnamedplus' -- クリップボードをOSと共有
vim.opt.cursorline = true -- カーソル行をハイライト
vim.opt.signcolumn = "yes:1"
vim.wo.number = true -- 行番号を表示


-- 関数の定義
function _G.search_in_git_diff(commit1, commit2, search_query)
	local diff_output = vim.fn.systemlist('git diff --color=never -U0 ' .. commit1 .. ' ' .. commit2)
	local results = {}
	local current_file = ""
	local current_line = 0
	for _, line in ipairs(diff_output) do
		if line:match('^%+%+%+ b/.+') then
			current_file = line:match('^%+%+%+ b/(.+)')
		elseif line:match('^@@ %+%d+') then
			current_line = line:match('^@@ %+(%d+)')
		elseif line:match('^%+') then
			local match_line = line:sub(2)
			if match_line:find(search_query) then
				table.insert(results, {filename = current_file, lnum = current_line, text = match_line})
			end
			current_line = current_line + 1
		end
	end
	vim.fn.setqflist(results)
	vim.cmd('copen')
end

function enabled_osc52()
	local is_remote = vim.env.SSH_CLIENT
	return is_remote and (vim.env.DISPLAY == nil or vim.env.DISPLAY == "")
end

