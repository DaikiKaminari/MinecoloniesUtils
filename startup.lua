--- LOADING LIBS ---
local visitors = require("visitors")

--- GLOBAL VARIABLES ---
local colony -- colony peripheral
local monitor -- monitor peripheral

local function init()
    colony = peripheral.find("colony")
    assert(colony, "No colony peripheral found.")
    monitor = peripheral.find("monitor")
    assert(monitor, "No monitor found.")
    term.redirect(monitor)
    term.clear()
end

local function main()
    local visitors_infos = visitors.getSkillsAndCost(colony)
    for name, infos in visitors_infos do
        print("--- " .. name .. " ---")
        print(infos)
        print()
    end
end

init()
main()