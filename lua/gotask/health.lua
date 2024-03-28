local options = require("gotask").options

local M = {}

local start = vim.health.start
local ok = vim.health.ok
local error = vim.health.error

function M.check()
	start("gotask.nvim")
	if vim.fn.executable(options.task_binary) == 1 then
		local task_version_output = vim.system({ options.task_binary, "--version" }):wait().stdout
		if task_version_output ~= nil and task_version_output:find("^Task version: v") then
			local task_version = task_version_output:gsub("Task version: v", "")
			ok("Gotask binary found. Version: " .. task_version)
		else
			error(
				"Found binary named ["
					.. options.task_binary
					.. "] in path, but it does not appear to be a Task binary."
			)
		end
	else
		error("Could not find task binary named [" .. options.task_binary .. "] in path")
	end
end

return M
