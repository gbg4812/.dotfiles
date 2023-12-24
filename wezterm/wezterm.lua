local wezterm = require('wezterm')
local colors = require('lua/rose-pine').colors()
local window_frame = require('lua/rose-pine').window_frame()
local config = {}

config.colors = colors
config.window_frame = window_frame

config.font = wezterm.font('Monaspace Neon')
config.harfbuzz_features =
{ 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'calt', 'dlig' }

config.enable_tab_bar = false

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
        key = 'F',
        mods = 'CTRL',
        action = wezterm.action.SendString('cdf\n')
    },
    {
        key = 'A',
        mods = 'CTRL',
        action = wezterm.action.SendString('tmux attach\n')
    },
}

return config
