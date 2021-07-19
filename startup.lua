--- LOADING LIBS ---
local visitors = require("visitors")

--- GLOBAL VARIABLES ---
local colony -- colony peripheral
local monitors = {} -- monitors peripherals

local function init()
    colony = peripheral.find("colony")
    assert(colony, "No colony peripheral found.")
    local names = peripheral.getNames()
    for _,name in ipairs(names) do
        if string.sub(name, 1, 7) == "monitor" then
            table.insert(monitors, peripheral.wrap(name))
        end
    end
    print(tostring(#monitors) .. " monitor(s) detected.")
    term.setTextScale(0.5)
end

local function displayVisitors()
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
    displayVisitors()
end

init()
main()