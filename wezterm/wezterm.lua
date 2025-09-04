local wezterm = require 'wezterm'

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  -- Font settings
  font = wezterm.font("Hasklig"),
  font_size = 14.0,

  -- Window size and behavior
  initial_cols = 203,
  initial_rows = 62,
  window_background_opacity = 1.0,
  window_decorations = "RESIZE",
  adjust_window_size_when_changing_font_size = false,
  window_close_confirmation = "NeverPrompt",

  -- Colors
  colors = {
    foreground = "#ffffff",
    background = "#1e1e1e",
    ansi = {
      "#1e1e1e", -- black
      "#ffffff", -- red
      "#80b028", -- green
      "#ffee80", -- yellow
      "#4c80ba", -- blue
      "#a177ef", -- magenta
      "#4ba6cb", -- cyan
      "#c5c8c6", -- white
    },
    brights = {
      "#676b71", -- bright black (gray)
      "#af5b56", -- bright red
      "#80b028", -- bright green
      "#ebb579", -- bright yellow (orange)
      "#3655b5", -- bright blue
      "#a177ef", -- bright magenta
      "#4ba6cb", -- bright cyan
      "#e9e9e9", -- bright white
    },
  },
  ssh_domains = {
    {
      -- This is the name you'll use with `wezterm connect hermes`
      name = "hermes",
      -- The actual SSH hostname
      remote_address = "hermes",
      -- Optional: force a specific username
      username = "andreas",
    },
  },
}
