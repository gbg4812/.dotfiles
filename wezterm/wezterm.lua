local wezterm = require("wezterm")
local colors = require("lua/rose-pine").colors()
local window_frame = require("lua/rose-pine").window_frame()
local config = wezterm.config_builder()
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
workspace_switcher.apply_to_config(config)

-- wezterm.on('gui-startup', function(cmd)
--     local tab, pane, window = mux.spawn_window(cmd or {})
--     window:gui_window():toggle_fullscreen()
-- end)

config.color_scheme = "Catppuccin Mocha"
config.window_frame = window_frame

config.font = wezterm.font("Fira Code Nerd Font", { weight = 400 })
config.harfbuzz_features = { "ss08", "ss04", "ss03", "cv29" }
-- === :: => $ & () {}

config.enable_tab_bar = false

-- Key bindings
-- Set the leader key to Ctrl+Space
-- When you press Ctrl+Space, WezTerm will wait for the next key press
-- to execute a leader-bound action.
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }

-- Define keybindings
config.keys = {
	-- Pane Navigation (Leader + Vim keys)
	-- These actions switch focus to the neighboring pane in the specified direction.
	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },

	-- Create Vertical Split (Leader + |)
	-- This action splits the current pane vertically, creating a new pane to the right.
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
	},

	-- Create Horizontal Split (Leader + -)
	-- This action splits the current pane horizontally, creating a new pane below.
	{ key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },

	-- Create New Window (Tab) (Leader + c)
	-- This action creates a new tab (which WezTerm calls a 'window' in its multiplexer).
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	-- Go to Next Tab (Leader + n)
	-- This action activates the next tab in the current OS window.
	{ key = "n", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = 1 }) },

	-- Siwtch workspace
	{
		key = "w",
		mods = "LEADER",
		action = workspace_switcher.switch_workspace(),
	},
	{
		key = "W",
		mods = "LEADER",
		action = workspace_switcher.switch_to_prev_workspace(),
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
		end),
	},
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.state_manager.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.state_manager.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.state_manager.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
}

return config
