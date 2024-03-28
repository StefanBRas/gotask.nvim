<p align="center">
  <h1 align="center">gotask.nvim</h1>
</p>

Plugin to help with [gotask](https://taskfile.dev).
For now, it's just a Telescope extension that lets you pick a task to run.

It's very much alpha and it's my first plugin, so don't expect too much.

Feel free to open issues or PRs.

![screenshot](screenshots/telescope.png)


## Dependencies

- telescope.nvim

## ⚙ Configuration


```lua
require("gotask").setup({
  task_binary = "task", -- the binary to use
})
```

