-- Arch-Hyprland rice, translated for Fedora 45 / Hyprland 0.57 (Lua config)
-- Source: github.com/binnewbs/arch-hyprland
-- ThinkPad customizations: TrackPoint, touchpad gestures, TrackPoint red + cherry blossom pink accents.

---------------------------------------------------------------------
---- COLORS (ThinkPad carbon + TrackPoint red) ----
---------------------------------------------------------------------
-- matugen rewrites colors.lua when the wallpaper changes.
local c = require("colors")

local image            = c.image
local background       = c.background
local on_background    = c.on_background
local surface          = c.surface
local surface_dim      = c.surface_dim
local surface_variant  = c.surface_variant
local on_surface       = c.on_surface
local on_surface_variant = c.on_surface_variant
local inverse_surface  = c.inverse_surface
local inverse_primary  = c.inverse_primary
local primary          = c.primary
local primary_container = c.primary_container
local on_primary       = c.on_primary
local secondary        = c.secondary
local on_secondary_container = c.on_secondary_container
local tertiary         = c.tertiary
local error            = c.error
local outline          = c.outline
local outline_variant  = c.outline_variant

---------------------------------------------------------------------
---- PROGRAMS ----
---------------------------------------------------------------------
local terminal    = "kitty --single-instance"
local fileManager = "nautilus"
local menu        = "rofi -show drun"
local wallpaper   = image

---------------------------------------------------------------------
---- MONITOR ----
---------------------------------------------------------------------
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

---------------------------------------------------------------------
---- ENVIRONMENT ----
---------------------------------------------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

---------------------------------------------------------------------
---- AUTOSTART ----
---------------------------------------------------------------------
hl.on("hyprland.start", function()
    -- Only the panel, wallpaper, and polkit agent are needed for an interactive session.
    -- --no-cache avoids restoring a previous wallpaper before setting ours; a short
    -- deferred start keeps applets/idle handling off the critical startup path.
    hl.exec_cmd("swww-daemon --quiet --no-cache; swww img " .. wallpaper .. " --transition-type none")
    hl.exec_cmd("waybar")
    hl.exec_cmd("/usr/libexec/hyprpolkitagent")

    local function deferred(seconds, cmd)
        hl.exec_cmd("sleep " .. seconds .. " && " .. cmd)
    end

    deferred(3, "nm-applet")
    deferred(4, "swaync")
    deferred(5, "hypridle")
end)

---------------------------------------------------------------------
---- LOOK AND FEEL ----
---------------------------------------------------------------------
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border   = primary,   -- ThinkPad TrackPoint red
            inactive_border = secondary, -- cherry blossom pink
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding        = 10,
        rounding_power  = 2,
        active_opacity  = 1.0,
        inactive_opacity = 0.8,
        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
        blur = {
            enabled            = true,
            size               = 5,
            passes             = 3,
            ignore_opacity     = true,
            new_optimizations  = true,
            special            = false,
            popups             = true,
            xray               = true,
            vibrancy           = 0.1696,
        },
    },

    dwindle = { preserve_split = true },
    master  = { new_status = "master" },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        vrr                     = true,
    },
    render = { new_render_scheduling = true },
    animations = { enabled = true },
})

---------------------------------------------------------------------
---- ANIMATIONS ----
---------------------------------------------------------------------
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("been",     { type = "bezier", points = { {0.24, 0.9}, {0.25, 0.91} } })
hl.curve("wind",     { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("linear",   { type = "bezier", points = { {0.0, 0.0}, {1.0, 1.0} } })
hl.curve("slow",     { type = "bezier", points = { {0.0, 0.85}, {0.3, 1.0} } })
hl.curve("overshot", { type = "bezier", points = { {0.7, 0.6}, {0.1, 1.1} } })
hl.curve("bounce",   { type = "bezier", points = { {1.1, 1.6}, {0.1, 0.85} } })

hl.animation({ leaf = "windowsIn",   enabled = true, speed = 5, bezier = "slow",     style = "popin" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7, bezier = "been",     style = "popin 70%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind",     style = "slide" })
hl.animation({ leaf = "border",      enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "fade",        enabled = true, speed = 5, bezier = "overshot" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5, bezier = "wind" })
hl.animation({ leaf = "windows",     enabled = true, speed = 5, bezier = "bounce",   style = "popin" })

---------------------------------------------------------------------
---- INPUT: ThinkPad touchpad + TrackPoint ----
---------------------------------------------------------------------
hl.config({
    input = {
        kb_layout   = "us",
        kb_variant  = "",
        kb_model    = "",
        kb_options  = "",
        kb_rules    = "",
        follow_mouse = 1,
        sensitivity  = 0,
        accel_profile = "flat",
        force_no_accel = true,
        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            clickfinger_behavior = true,
            middle_button_emulation = false,
            disable_while_typing = false,
            scroll_factor        = 1.0,
        },
    },
    gestures = {
        workspace_swipe_create_new = true,
        workspace_swipe_direction_lock = true,
        workspace_swipe_distance = 90,            -- smaller = more sensitive
        workspace_swipe_min_speed_to_force = 5,   -- quick swipes register sooner
        workspace_swipe_cancel_ratio = 0.25,      -- fewer swipes get cancelled
    },
})

-- Three-finger horizontal swipe changes workspaces
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Red TrackPoint nib: linear response, slightly reduced sensitivity
hl.device({ name = "TPPS/2 Elan TrackPoint", accel_profile = "linear", sensitivity = -0.3 })

-- Synaptics precision touchpad
hl.device({
    name = "SYNA8008:00 06CB:CE58 Touchpad",
    natural_scroll = true,
    tap_to_click   = true,
    clickfinger_behavior = true,
})

---------------------------------------------------------------------
---- KEYBINDINGS ----
---------------------------------------------------------------------
local mod = "SUPER"
local S = function(cmd) return hl.dsp.exec_cmd(cmd) end

hl.bind(mod .. " + Return", S(terminal))
hl.bind(mod .. " + SHIFT + Return", S(terminal))
hl.bind(mod .. " + Q", hl.dsp.window.kill())
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
hl.bind(mod .. " + E", S(fileManager))
hl.bind(mod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + D", S(menu))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + R", S(menu))
hl.bind(mod .. " + T", S(terminal))
hl.bind(mod .. " + SHIFT + R", S("~/.config/hypr/scripts/wbrestart.sh"))
hl.bind(mod .. " + B", S('xdg-open "https://"'))
hl.bind(mod .. " + L", S("~/.config/hypr/scripts/hyprlock.sh"))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + S", S("~/.config/hypr/scripts/screenshot.sh"))
hl.bind(mod .. " + W", S("~/.config/hypr/scripts/wppicker.sh"))
hl.bind(mod .. " + SHIFT + Q", S("~/.config/hypr/scripts/KillActiveProcess.sh"))
hl.bind(mod .. " + C", S("hyprpicker -a"))
hl.bind(mod .. " + CTRL + B", S("~/.config/hypr/scripts/WaybarStyles.sh"))
hl.bind(mod .. " + ALT + B", S("~/.config/hypr/scripts/WaybarLayout.sh"))
hl.bind(mod .. " + H", S("pkill -SIGUSR1 waybar"))
hl.bind(mod .. " + SHIFT + E", S("kitty -e ranger"))

-- Focus movement
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move windows
hl.bind(mod .. " + CTRL + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + CTRL + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + CTRL + down",  hl.dsp.window.move({ direction = "down" }))

-- Resize windows (repeating)
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50,  y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0, y = 50,  relative = true }), { repeating = true })

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move / resize with mouse drag
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ThinkPad media keys (work while locked)
hl.bind("XF86AudioRaiseVolume",   S("~/.config/hypr/scripts/volume.sh --inc"),       { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",   S("~/.config/hypr/scripts/volume.sh --dec"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",          S("~/.config/hypr/scripts/volume.sh --toggle"),    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",       S("~/.config/hypr/scripts/volume.sh --toggle-mic"),{ locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",    S("~/.config/hypr/scripts/brightness.sh --inc"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",  S("~/.config/hypr/scripts/brightness.sh --dec"),   { locked = true, repeating = true })

-- Media playback
hl.bind("XF86AudioNext",  S("playerctl next"),         { locked = true })
hl.bind("XF86AudioPause", S("playerctl play-pause"),   { locked = true })
hl.bind("XF86AudioPlay",  S("playerctl play-pause"),   { locked = true })
hl.bind("XF86AudioPrev",  S("playerctl previous"),     { locked = true })

---------------------------------------------------------------------
---- TAGS (window categorization) ----
---------------------------------------------------------------------
hl.window_rule({ name = "tag-media",    match = { class = "^([Mm]pv|vlc)$" }, tag = "+multimedia_video" })
hl.window_rule({ name = "tag-settings1", match = { class = "^(nm-applet|nm-connection-editor|blueman-manager|org.gnome.FileRoller)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings2", match = { class = "^(org.gnome.DiskUtility|wihotspot(-gui)?)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-viewer1",  match = { class = "^(org.gnome.SystemMonitor)$" }, tag = "+viewer" })
hl.window_rule({ name = "tag-viewer2",  match = { class = "^(org.gnome.Evince)$" }, tag = "+viewer" })
hl.window_rule({ name = "tag-viewer3",  match = { class = "^(eog|org.gnome.Loupe)$" }, tag = "+viewer" })

---------------------------------------------------------------------
---- WINDOW RULES ----
---------------------------------------------------------------------
hl.window_rule({ name = "no-blur-video", match = { tag = "multimedia_video*" }, no_blur = true, opacity = 1.0 })
hl.window_rule({ name = "op-settings",   match = { tag = "settings*" }, opacity = 0.8 })
hl.window_rule({ name = "op-nautilus",   match = { class = "^(org.gnome.Nautilus)$" }, opacity = 0.8 })
hl.window_rule({ name = "op-editors",    match = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" }, opacity = 0.9 })
hl.window_rule({ name = "op-pavucontrol",match = { class = "^(org.pulseaudio.pavucontrol)$" }, opacity = 0.9 })
hl.window_rule({ name = "op-kitty",      match = { class = "^(kitty)$" }, opacity = 0.9 })
hl.window_rule({ name = "op-chat",       match = { class = "^(discord|vesktop|org.telegram.desktop)$" }, opacity = 0.85 })
hl.window_rule({ name = "op-spotify",    match = { class = "^(Spotify)$" }, opacity = 0.8 })
hl.window_rule({ name = "op-zen",        match = { class = "^(zen)$" }, opacity = 0.9 })

hl.window_rule({ name = "float-settings", match = { tag = "settings*" }, float = true })
hl.window_rule({ name = "float-viewer",   match = { tag = "viewer*" }, float = true })
hl.window_rule({ name = "float-video",    match = { tag = "multimedia_video*" }, float = true, size = {"900", "506"} })
hl.window_rule({ name = "float-pavu",     match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true, size = {"50%", "60%"} })
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
    name = "nofocus-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

hl.window_rule({ name = "float-save-dialog", match = { title = "^(Save As|Save a File|Pick Files)$" }, float = true, size = {"50%", "60%"}, center = true })
hl.window_rule({ name = "float-open-dialog", match = { initial_title = "(Open Files)" }, float = true, size = {"70%", "60%"} })

---------------------------------------------------------------------
---- LAYER RULES ----
---------------------------------------------------------------------
hl.layer_rule({ name = "blur-waybar",         match = { namespace = "waybar" },                    blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ name = "blur-notifications",  match = { namespace = "tag:notif*" },               ignore_alpha = 0.5 })
hl.layer_rule({ name = "blur-logout",         match = { namespace = "logout_dialog" },            blur = true })
hl.layer_rule({ name = "blur-swaync-center",  match = { namespace = "swaync-control-center" },    blur = true, ignore_alpha = 0.5, xray = false })
hl.layer_rule({ name = "blur-swaync-notif",   match = { namespace = "swaync-notification-window" },blur = true, ignore_alpha = 0.5, xray = false })

-- Custom overrides: ThinkPad 1x scale & no active red border
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
hl.config({
  general = {
    border_size = 0,
  },
})
