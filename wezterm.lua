-- These are the basic's for using wezterm.
-- Mux is the mutliplexes for windows etc inside of the terminal
-- Action is to perform actions on the terminal
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

-- These are vars to put things in later (i dont use em all yet)
local config = {}
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

-- This is for newer wezterm vertions to use the config builder 
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Default config settings
-- These are the default config settins needed to use Wezterm
-- Just add this and return config and that's all the basics you need

-- Color scheme, Wezterm has 100s of them you can see here:
-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = 'Catppuccin Macchiato (Gogh)'
-- This is my chosen font, we will get into installing fonts on windows later
config.font = wezterm.font('Maple Mono NF')
config.font_size = 11
config.launch_menu = launch_menu
-- makes my cursor blink 
config.default_cursor_style = 'BlinkingBar'
-- config.disable_default_key_bindings = true
-- this adds the ability to use ctrl+v to paste the system clipboard 
config.keys = {
    { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    -- This will create a new split and run the `top` program inside it
    {
      key = '+',
      mods = 'ALT|SHIFT',
      action = wezterm.action.SplitVertical {

      },
    },
        -- This will create a new split and run the `top` program inside it
    {
        key = '-',
        mods = 'ALT|SHIFT',
        action = wezterm.action.SplitHorizontal {
        },
    },

}

config.mouse_bindings = mouse_bindings

-- There are mouse binding to mimc Windows Terminal and let you copy
-- To copy just highlight something and right click. Simple
mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
 {
  event = { Down = { streak = 1, button = "Right" } },
  mods = "NONE",
  action = wezterm.action_callback(function(window, pane)
   local has_selection = window:get_selection_text_for_pane(pane) ~= ""
   if has_selection then
    window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
    window:perform_action(act.ClearSelection, pane)
   else
    window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
   end
  end),
 },
}

-- This is used to make my foreground (text, etc) brighter than my background
config.foreground_text_hsb = {
  hue = 1.0,
  saturation = 1.2,
  brightness = 1.5,
}

-- This is used to set an image as my background 
-- config.background = {
--     {
--         source = { File = {path = 'C:/Users/someuserboi/Pictures/Backgrounds/theone.gif', speed = 0.2}},
--         opacity = 0.9,
--         width = "100%",
--         hsb = {brightness = 0.5},
--     }
-- }

-- IMPORTANT: Sets WSL2 UBUNTU-22.04 as the defualt when opening Wezterm
config.default_domain = 'WSL:Ubuntu'

config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.window_close_confirmation = "NeverPrompt"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
-- config.initial_rows = 40
-- config.initial_cols = 160

wezterm.on("gui-startup", function(cmd)
  local screen            = wezterm.gui.screens().active
  local ratio             = 0.7
  local width, height     = screen.width * ratio, screen.height * ratio
  local tab, pane, window = wezterm.mux.spawn_window {
    position = {
      x = (screen.width - width) / 2,
      y = (screen.height - height) / 2,
      origin = 'ActiveScreen' }
  }
  -- window:gui_window():maximize()
  window:gui_window():set_inner_size(width, height)
end)

return config