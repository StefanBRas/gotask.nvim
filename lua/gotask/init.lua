---@class GotaskOptions
---@field task_binary string The binary name of the task runner.

---@class Gotask
---@field options GotaskOptions
---@field setup fun(opts: GotaskOptions): GotaskOptions
local Gotask = {}

Gotask.options = {
	task_binary = "task",
}

local defaults = vim.deepcopy(Gotask.options)

local function register_commands()
	vim.api.nvim_create_user_command("GotaskFzf", function()
		require("gotask.fzf").search()
	end, { desc = "Search for tasks using fzf" })

	vim.api.nvim_create_user_command("GotaskTelescope", function()
		vim.cmd("Telescope gotask")
	end, { desc = "Search for tasks using Telescope" })
end

function Gotask.setup(opts)
	Gotask.options = vim.deepcopy(vim.tbl_deep_extend("keep", opts or {}, defaults))
	register_commands()
	return Gotask.options
end

return Gotask
