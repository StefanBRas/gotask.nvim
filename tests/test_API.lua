local child = MiniTest.new_child_neovim()
local eq = MiniTest.expect.equality

local T = MiniTest.new_set({
	hooks = {
		-- This will be executed before every (even nested) case
		pre_case = function()
			-- Restart child process with custom 'init.lua' script
			child.restart({ "-u", "scripts/minimal_init.lua" })
		end,
		-- This will be executed one after all tests from this set are finished
		post_once = child.stop,
	},
})

-- Tests related to the `setup` method.
T["gotask"] = MiniTest.new_set({
	hooks = {
		-- This will be executed before every (even nested) case
		pre_case = function()
			child.lua([[Gotask = require('gotask')]])
		end,
		-- This will be executed one after all tests from this set are finished
	},
})

T["gotask"]["Has default options loaded"] = function()
	eq(child.lua("return Gotask.options.task_binary"), "task")
end

T["gotask"]["setup overrides default"] = function()
	child.lua("require('gotask').setup({task_binary = 'custom'})")
	eq(child.lua("return Gotask.options.task_binary"), "custom")
end

T["telescope"] = MiniTest.new_set()

-- No idea how to test this with mini.test yet
T["telescope"]["Does not break when run"] = function()
	child.lua([[require('telescope._extensions.gotask')]])
	child.cmd("Telescope gotask")
end

return T
