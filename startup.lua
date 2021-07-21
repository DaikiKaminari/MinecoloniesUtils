--- LOADING LIBS ---
local visitors = require("visitors")

--- GLOBAL VARIABLES ---
local colony -- colony peripheral
local chatbox -- chatbox peripheral
local chatbox_side = "left" -- side where the sidebox is
local monitors = {} -- monitors peripherals
local seconds = 10 -- refresh rate


--- INIT ---
local function init()
    term.clear()
    colony = peripheral.find("colony")
    assert(colony, "No colony peripheral found.")
    chatbox = peripheral.wrap(chatbox_side)
    if not chatbox then
        print("Warning : no chatbox peripheral found on side " .. chatbox_side)
    end
    local names = peripheral.getNames()
    local m
    for _,name in ipairs(names) do
        if string.sub(name, 1, 7) == "monitor" then
            m = peripheral.wrap(name)
            table.insert(monitors, m)
            m.setTextScale(0.5)
        end
    end
    print(tostring(#monitors) .. " monitor(s) detected.")
end

--- METHODS ---
local function displayVisitors(visitors_infos)
    local i = 1
    for name, infos in pairs(visitors_infos) do
        term.redirect(monitors[i])
        term.clear()

        print(name .. "\n\n" .. infos)
        i = i + 1
        if i > #monitors then
            term.redirect(term.native())
            print("Warning : not enough monitors to display all visitors.")
            return
        end
    end
end

--- MAIN CALL ---
local function main()
    while true do
        for _, monitor in ipairs(monitors) do
            monitor.clear()
        end
        local visitors_infos = visitors.getSkillsAndCost(colony, chatbox)
        if monitors[1] then -- if we have at least 1 monitor
            displayVisitors(visitors_infos)
        end
        sleep(seconds) -- actualize every X seconds
    end
end

init()
main()