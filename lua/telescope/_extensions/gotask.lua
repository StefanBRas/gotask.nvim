local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("gotask.utils")

local M = {}

function M.finder()
	return finders.new_table({
		results = utils.get_gotasks(),
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
			results_title = "Gotask eyy",
			prompt_title = "Gotask tasks",
			prompt_prefix = "(<CR> to run task, <S-CR> to go to taskfile): ",
			finder = M.finder(),
			sorter = conf.generic_sorter(opts),
			previewer = conf.grep_previewer(opts),
			attach_mappings = function(prompt_bufnr, map)
				map("i", "<S-CR>", function()
					actions.select_default(prompt_bufnr)
				end)
				map("i", "<CR>", function()
					actions.close(prompt_bufnr)
					---@type GoTaskJson
					local task = action_state.get_selected_entry().value
					utils.run_task_in_terminal(task.name)
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
