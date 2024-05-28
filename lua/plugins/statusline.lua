return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local tokyo_pallete = require("tokyonight.colors").setup() -- pass in any of the config options as explained above
		local colors = {
			bg = tokyo_pallete.bg_statusline,
			fg = tokyo_pallete.fg_dark,

			left_sep = tokyo_pallete.cyan,
			right_sep = tokyo_pallete.cyan,

			normal_mode = tokyo_pallete.blue,
			insert_mode = tokyo_pallete.purple,
			terminal_mode = tokyo_pallete.green,
			virtual_mode = tokyo_pallete.magenta,
			visual_block_mode = tokyo_pallete.magenta2,
			file_name = tokyo_pallete.fg,

			diag_error = tokyo_pallete.error,
			diag_warn = tokyo_pallete.warning,
			diag_info = tokyo_pallete.info,

			diff_add = tokyo_pallete.info,
			diff_modified = tokyo_pallete.warning,
			diff_remove = tokyo_pallete.error,

			branch = tokyo_pallete.fg,

			final = tokyo_pallete.border,
		}

		local config = {
			options = {
				-- Disable sections and component separators
				component_separators = "",
				section_separators = "",
				theme = {
					-- We are going to use lualine_c an lualine_x as left and
					-- right section. Both are highlighted by c theme .  So we
					-- are just setting default looks o statusline
					normal = { c = { fg = colors.fg, bg = colors.bg } },
					inactive = { c = { fg = colors.fg, bg = colors.bg } },
				},
			},
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
			extensions = { "nvim-tree" }, -- Ensure you have this line to integrate Lualine with nvim-tree
		}

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x at right section
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		ins_left({
			function()
				return "▊"
			end,
			color = { fg = colors.left_sep }, -- Sets highlighting of component
			padding = { left = 0, right = 1 }, -- We don't need space before this
		})

		ins_left({
			-- mode component
			function()
				return "󰻷"
			end,
			color = function()
				-- auto change color according to neovims mode
				local mode_color = {
					n = colors.normal_mode,
					i = colors.insert_mode,
					v = colors.visual_mode,
					[""] = colors.visual_block_mode,
					t = colors.terminal_mode,
				}

				local color = mode_color[vim.fn.mode()]
				if not color then
					color = colors.final
				end

				return { fg = color }
			end,
			padding = { right = 1 },
		})

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		ins_left({
			"filename",
			cond = conditions.buffer_not_empty,
			color = { fg = colors.yellow, gui = "bold" },
		})

		ins_left({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				color_error = { fg = colors.diag_error },
				color_warn = { fg = colors.diag_warn },
				color_info = { fg = colors.diag_info },
			},
		})

		ins_left({
			function()
				return "%="
			end,
		})

		ins_right({
			"branch",
			icon = "",
			color = { fg = colors.branch, gui = "bold" },
		})

		ins_right({
			"diff",
			symbols = { added = " ", modified = "󱓻 ", removed = " " },
			diff_color = {
				added = { fg = colors.diff_add },
				modified = { fg = colors.diff_modified },
				removed = { fg = colors.diff_remove },
			},
			cond = conditions.hide_in_width,
		})

		ins_right({
			function()
				return "▊"
			end,
			color = { fg = colors.right_sep },
			padding = { left = 1 },
		})

		require("lualine").setup(config)
	end,
}
