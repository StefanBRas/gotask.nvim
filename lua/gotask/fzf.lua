local utils = require("gotask.utils")
local fzf = require("fzf-lua")
local fzf_actions = require("fzf-lua.actions")
local builtin_previewer = require("fzf-lua.previewer.builtin")

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

function M.search()
	local tasks = utils.get_gotask_list_all_output().tasks
	local tasks_dict = {}
	local task_names = {}

	for i, task in ipairs(tasks) do
		task_names[i] = task.name
		tasks_dict[task.name] = task
	end

	fzf.fzf_exec(task_names, {
		actions = {
			["default"] = function(selected, opts)
				utils.run_task_in_terminal(selected[1])
			end,
			["ctrl-g"] = function(selected, opts)
				local task = tasks_dict[selected[1]]
				fzf_actions.file_edit({ task.location.taskfile .. ":" .. task.location.line }, opts)
			end,
		},
		previewer = TaskPreviewer,
		tasks_dict = tasks_dict, -- add it here to make it available in the previewer
	})
end

return M
