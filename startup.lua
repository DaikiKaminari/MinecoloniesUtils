--- LOADING LIBS ---
local visitors = require("visitors")

--- GLOBAL VARIABLES ---
local colony -- colony peripheral
local monitors = {} -- monitors peripherals
local seconds -- refresh rate

local function init()
    term.clear()
    colony = peripheral.find("colony")
    assert(colony, "No colony peripheral found.")
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

local function displayVisitors()
    for _, monitor in ipairs(monitors) do
        monitor.clear()
    end

    local visitors_infos = visitors.getSkillsAndCost(colony)
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

local function main()
    while true do
        sleep(seconds) -- actualize every X seconds
        displayVisitors()
    end
end

init()
main()