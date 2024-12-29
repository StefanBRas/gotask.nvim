local M = {}
local options = require("gotask").options

---@class ListAllOutputTaskLocation
---@field line number The line number of the task.
---@field column number The column number of the task.
---@field taskfile string The path to the task file.

---@class GoTaskJson
---@field name string The name of the task.
---@field desc string The description of the task.
---@field summary string The summary of the task.
---@field up_to_date boolean Whether the task is up to date.
---@field location ListAllOutputTaskLocation The location of the task.

---@class ListAllOutput
---@field tasks GoTaskJson[] Array of tasks.
---@field location string The path to the task file.

--- @return ListAllOutput
function M.get_gotask_list_all_output()
	local obj = vim.system({ "gotask", "--list-all", "--json" }, { text = true }):wait()
	return vim.fn.json_decode(obj.stdout)
end

--- @return GoTaskJson[]
function M.get_gotasks()
	return M.get_gotask_list_all_output().tasks
end

--- @param task_name string: The name of the task to run
function M.run_task_in_terminal(task_name)
	vim.cmd("terminal " .. options.task_binary .. " " .. task_name)
end

return M
