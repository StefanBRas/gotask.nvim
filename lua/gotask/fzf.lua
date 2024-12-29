local utils = require("gotask.utils")
local fzf = require("fzf-lua")
local fzf_actions = require("fzf-lua.actions")
local fzf_preview = require("fzf-lua.previewer")
local builtin_previewer = require("fzf-lua.previewer.builtin")
local function get_location()
	return { utils.get_gotask_list_all_output().location }
end

-- Inherit from the "buffer_or_file" previewer
local TaskPreviewer = builtin_previewer.buffer_or_file:extend()

function TaskPreviewer:new(o, opts, fzf_win)
	TaskPreviewer.super.new(self, o, opts, fzf_win)
	setmetatable(self, TaskPreviewer)
	return self
end

function TaskPreviewer:parse_entry(entry_str)
	local task = self.opts.tasks_dict[entry_str]
	return {
		path = task.location.taskfile,
		line = task.location.line,
		col = task.location.col,
	}
end

local M = {}
function M.call()
	local tasks = utils.get_gotask_list_all_output().tasks
	local tasks_dict = {}
	local task_names = {}
	for i, task in ipairs(tasks) do
		task_names[i] = task.name
		tasks_dict[task.name] = task
	end
	fzf.fzf_exec(task_names, {
		actions = {
			-- Use fzf-lua builtin actions or your own handler
			-- ["default"] = fzf_actions.file_edit,
			["default"] = function(selected, opts)
				utils.run_task_in_terminal(selected[1])
			end,
			-- ["ctrl-y"] = function(selected, opts)
			-- 	print("selected item:", selected[1])
			-- end,
		},
		previewer = TaskPreviewer,
		tasks_dict = tasks_dict,
	})
end
return M
