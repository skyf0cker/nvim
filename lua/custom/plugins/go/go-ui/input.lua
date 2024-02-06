local input = {}

local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local default_theme = {
	position = "50%",
	size = {
		width = 30,
	},
	border = {
		style = "single",
		text = {
			top = "[package]",
			top_align = "center",
		},
	},
	win_options = {
		winhighlight = "Normal:Normal,FloatBorder:Normal",
	},
}

function input.ask(opts)
	opts = opts or {}
	opts.themes = vim.tbl_deep_extend("keep", opts.themes, default_theme) or default_theme

	local i = Input(opts.themes, {
		prompt = opts.prompt,
		on_submit = opts.on_submit,
		on_close = opts.on_close,
	})

	i:mount()

	-- unmount component when cursor leaves buffer
	i:on(event.BufLeave, function()
		i:unmount()
	end)
end

return input
