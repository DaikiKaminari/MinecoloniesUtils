--- LOADING LIBS ---
local visitors = require("visitors")

--- GLOBAL VARIABLES ---
local colony -- colony peripheral
local monitors -- monitors peripherals

local function init()
    colony = peripheral.find("colony")
    assert(colony, "No colony peripheral found.")
    local names = peripheral.getNames()
    for _,name in ipairs(peripheral) do
        if string.sub(name, 1, 7) == "monitor" then
            monitors[#monitors+1] = peripheral.wrap(name)
        end
    end
    print(tostring(#monitors) .. " monitors detected.")
end

local function main()
    for m in monitors do
        m.clear()
    end

    local visitors_infos = visitors.getSkillsAndCost(colony)
    local i = 1
    for name, infos in pairs(visitors_infos) do
        monitors[i].write("--- " .. name .. " ---" .. "\n" .. infos)
        i = i + 1
        if i > #monitors then
            print("Warning : not enough monitors to display all visitors.")
        end
    end
end

init()
main()