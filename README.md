<p align="center">
  <h1 align="center">gotask.nvim</h1>
</p>

Plugin to help with [gotask](https://taskfile.dev).
For now, it's just a Telescope and fzf-lua extension that lets you pick a task to run or go to.

It's very much alpha and it's my first plugin, so don't expect too much.

Feel free to open issues or PRs.

![screenshot](screenshots/telescope.png)


## Dependencies
- nvim >= 0.10 (Currently the prerelease version. Only because I use vim.system - if this is a problem, feel free to suggest an alternative)
- a task binary in your PATH

### Optional dependencies
- telescope.nvim
- fzf-lua

## Usage

### Commands
- `GotaskTelescope` (or `Telescope gotask`) will show a list of tasks in your taskfile with Telescope. Selecting one will run it. Shift-enter will open the file for edit.
- `GotaskFzf` will show a list of tasks in your taskfile with fzf-lua. Selecting one will run it. ctrl-g will open the file for edit.

## ⚙ Configuration


```lua
require("gotask").setup({
  task_binary = "task", -- the binary to use
})
```

## Health check

Run `:checkhealth gotask` to see if everything is working. There will be a section called `gotask.nvim`.

