local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local options = require("gotask").options

local M = {}

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
local function get_gotask_list_all_output()
	local obj = vim.system({ options.task_binary, "--list-all", "--json" }, { text = true }):wait()
	-- TODO: set a timeout and error message here
	return vim.fn.json_decode(obj.stdout)
end

--- @return GoTaskJson[]
local function get_gotasks()
	return get_gotask_list_all_output().tasks
end

function M.finder()
	return finders.new_table({
		results = get_gotasks(),
		entry_maker = function(task)
			return {
				value = task,
				display = task.name,
				ordinal = task.name,
				path = task.location.taskfile,
				lnum = task.location.line,
			}
		end,
	})
end

function M.telescope(opts)
	pickers
		.new(opts, {
			results_title = "Gotask",
			prompt_title = "Gotask tasks",
			finder = M.finder(),
			sorter = conf.generic_sorter(opts),
			previewer = conf.grep_previewer(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					---@type GoTaskJson
					local task = action_state.get_selected_entry().value
					vim.cmd("terminal " .. options.task_binary .. " " .. task.name)
				end)
				return true
			end,
		})
		:find()
end

return require("telescope").register_extension({
	exports = {
		gotask = M.telescope,
	},
})
