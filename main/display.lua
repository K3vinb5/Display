---@diagnostic disable: undefined-field

function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

if file_exists("Display/args.txt") then
    local arguments_handler = fs.open("Display/args.txt", "r")
    label = arguments_handler.readLine()
    side = arguments_handler.readLine()
    modem = arguments_handler.readLine()
    arguments_handler.close()

else
    error("You haven't run setDisplay yet")
end

local api = require("/GuiH") --Imports GUI
monitor = peripheral.wrap(side)
term.redirect(monitor)
local gui = api.create_gui(term.current())


--local write = io.write

function s_print(...)
    local n = select("#", ...)
    for i = 1, n do
        local v = tostring(select(i, ...))
        write(v)
        if i ~= n then
            write '\t'
        end
    end
end

function shutdown()
    gui.gui.text.coordinates.visible = false
    gui.gui.text.label.visible = false
    gui.gui.text.credits.visible = false
    gui.gui.text.fuel_level.visible = false
    gui.gui.text.progress_level.visible = false

    gui.gui.progressbar.progress_bar_0.visible = false
    gui.gui.progressbar.progress_bar_1.visible = false

    gui.gui.button.button_0.visible = false
    gui.gui.button.button_1.visible = false

    os.shutdown()
end

function reboot()
    gui.gui.text.coordinates.visible = false
    gui.gui.text.label.visible = false
    gui.gui.text.credits.visible = false
    gui.gui.text.fuel_level.visible = false
    gui.gui.text.progress_level.visible = false

    gui.gui.progressbar.progress_bar_0.visible = false
    gui.gui.progressbar.progress_bar_1.visible = false

    gui.gui.button.button_0.visible = false
    gui.gui.button.button_1.visible = false

    os.reboot()
end

function execute_function(function_name)
    function_name()
end

function new_button(name_arg, x_arg, y_arg, width_arg, height_arg, color_arg, text_arg, function_name_arg)

    gui.create.button({
        name = name_arg,
        x = x_arg,
        y = y_arg,
        width = width_arg,
        height = height_arg,
        background_color = color_arg,
        text = gui.text {
            text = text_arg,
            centered = true,
            transparent = true
        },
        visible = true,
        on_click = function(object)
            execute_function(function_name_arg)
        end
    })
end

function new_text(name_arg, text_arg, x_arg, y_arg)
    gui.create.text({
        name = name_arg,
        visible = true,
        text = gui.text {
            text = text_arg,
            centered = false,
            x = x_arg,
            y = y_arg,
            transparent = true
        }
    })
end

function new_progress_bar(name_arg, x_arg, y_arg, width_arg, height_arg, value_arg)
    gui.create.progressbar({
        name = name_arg,
        x = x_arg,
        y = y_arg,
        width = width_arg,
        height = height_arg,
        visible = true,
        fg = colors.green,
        bg = colors.gray,
        value = value_arg,
        direction = "left-right"
    })
end

local function updateGui()

        gui.gui.text.label.text.text = label

        gui.gui.text.coordinates.visible = false
        gui.gui.text.coordinates.visible = true

        repeat
            event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        until channel == os.getComputerID()

        gui.gui.text.coordinates.text.text =
            "Current Coordinates: " .. message[1] .. " " .. message[2] .. " " .. message[3]
        gui.gui.progressbar.progress_bar_1.value = message[4]
        gui.gui.progressbar.progress_bar_0.value = message[5]

    os.sleep(0.5)
end

local function main()

    local modem = peripheral.wrap(modem)
    modem.open(os.getComputerID())

    gui.gui.text.label.text.text = "Waiting Message...\nMy id is: " .. os.getComputerID()

    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == os.getComputerID()

    while true do
        updateGui()
    end

end

-- Buttons:
new_button("button_0", 31, 16, 8, 3, colors.red, " Off", shutdown)
new_button("button_1", 31, 12, 8, 3, colors.green, "Reboot", reboot)

-- Texts:
new_text("coordinates", "Current Coordinates: ", 2, 6)
new_text("label", "Name", 16, 2)
new_text("credits", "Made by Kevinb5", 1, 19)

-- ProgressBars:
new_progress_bar("progress_bar_0", 2, 10, 24, 3, 0)
new_text("fuel_level", "Fuel", 12, 11)

new_progress_bar("progress_bar_1", 2, 14, 24, 3, 0)
new_text("progress_level", "Progress", 10, 15)

print("My id is: " .. os.getComputerID())

    gui.execute(main)

