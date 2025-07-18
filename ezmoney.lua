local message_display = true
local message_timer = 0
local message_duration = 10000 -- 10 seconds
local last_chat_time = 0
local chat_interval = 500 -- Send chat message every 500ms
local rainbow_timer = 0

-- Rainbow color function
local function get_rainbow_color()
    local time = util.current_time_millis() / 100 -- Fast color change
    local r = math.sin(time) * 0.5 + 0.5
    local g = math.sin(time + 2) * 0.5 + 0.5
    local b = math.sin(time + 4) * 0.5 + 0.5
    return {r = r, g = g, b = b, a = 1.0}
end

-- Main loop
util.create_tick_handler(function()
    local current_time = util.current_time_millis()
    
    -- Start timer when script first loads
    if message_timer == 0 then
        message_timer = current_time
        last_chat_time = current_time
        util.toast("im gay")
        util.log("Gay message script started!")
    end
    
    -- Send continuous chat messages
    if current_time - last_chat_time >= chat_interval then
        chat.send_message("im gay", false, true, true)
        last_chat_time = current_time
    end
    
    -- Display big rainbow text in center of screen
    if message_display then
        -- Check if message should still be displayed
        if current_time - message_timer < message_duration then
            local color = get_rainbow_color()
            -- Draw big rainbow text in center of screen
            directx.draw_text(0.5, 0.45, "IM GAY", ALIGN_CENTRE, 3.0, color)
        else
            -- Hide message after duration
            message_display = false
        end
    end
end)

util.log("Gay message script loaded. Message will be sent automatically!")