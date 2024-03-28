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

function Gotask.setup(opts)
	Gotask.options = vim.deepcopy(vim.tbl_deep_extend("keep", opts or {}, defaults))
	return Gotask.options
end

return Gotask
