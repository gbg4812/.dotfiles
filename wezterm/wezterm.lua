local wezterm = require('wezterm')
local colors = require('lua/rose-pine').colors()
local window_frame = require('lua/rose-pine').window_frame()
local mux = wezterm.mux
local config = wezterm.config_builder()

-- wezterm.on('gui-startup', function(cmd)
--     local tab, pane, window = mux.spawn_window(cmd or {})
--     window:gui_window():toggle_fullscreen()
-- end)

config.colors = colors
config.window_frame = window_frame

config.font = wezterm.font ('Monaspace Neon', { weight = 400 } )
config.harfbuzz_features =
{ 'ss02', 'ss03', 'calt', 'dlig' }

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.initial_rows = 200
config.initial_cols = 200

-- Key bindings
config.disable_default_key_bindings = true;

config.keys = {
    {
        key = 'L',
        mods = 'CTRL',
        action = wezterm.action.ShowDebugOverlay
    },
    {
        key = 'C',
        mods = 'CTRL',
        action = wezterm.action.CopyTo('ClipboardAndPrimarySelection')
    },
    {
        key = 'V',
        mods = 'CTRL',
        action = wezterm.action.PasteFrom('Clipboard')
    },
    {
        key = 'F11',
        action = wezterm.action.ToggleFullScreen,
    },
    {
        key = 't',
        mods = 'CTRL',
        action = wezterm.action_callback(function()

        end)
        -- i want to have functionality for searching paths with fzf and
        -- pasting them to the string
    },

}

return config
