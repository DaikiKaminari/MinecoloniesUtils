--- LOADING LIBS ---
local v = {}

local function superior(a, b)
    return a > b
end

-- returns a table associating a visitor name and a string of his skills and cost
local function getSkillsAndCost(colony)
    local visitorsSkills = {}
    local skills
    local visitors = colony.getVisitors()
    for _, visitor in pairs(visitors) do
        infos = "Cost : " .. visitor["cost"]["displayName"] .. " (" .. tostring(visitor["cost"]["count"]) ..")\n"
        local reversed_table = {}
        for skill_name, values in pairs(visitor["skills"]) do
            reversed_table[values["level"]] = skill_name
        end
        table.sort(reversed_table, superior)
        for level, skill_name in pairs(reversed_table) do
            infos = infos .. skill_name .. " : " .. string.rep(" ", 16-string.len(skill_name)) .. tostring(level) .. "\n"
        end
        visitorsSkills[visitor["name"]] = infos
    end
    return visitorsSkills
end
v.getSkillsAndCost = getSkillsAndCost

return v