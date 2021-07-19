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
end

local function main()
    for _, m in ipairs(monitors) do
        m.clear()
        m.setCursorPos(1, 1)
        m.setTextScale(0.5)
    end

    local visitors_infos = visitors.getSkillsAndCost(colony)
    local i = 1
    for name, infos in pairs(visitors_infos) do
        term.redirect(monitors[i])
        print("--- " .. name .. " ---" .. "\n" .. infos)
        i = i + 1
        if i > #monitors then
            term.redirect(term.native())
            print("Warning : not enough monitors to display all visitors.")
            i = 1
        end
    end
end

init()
main()