--- LOADING LIBS ---
local visitors = {}

-- returns a table associating a visitor name and a string of his skills and cost
local function getSkillsAndCost(colony)
    local visitorsSkills = {}
    local skills
    local visitors = colony.getVisitors()
    for visitor in visitors do
        infos = "Cost : " .. visitor["cost"]["displayName"] .. " (" .. tostring(visitor["cost"]["count"]) ..")\n"
        for skill_name, values in visitor["skills"] do
            infos = infos + skill_name + " : " .. string.rep(" ", 10-string.len(skill_name)) .. tostring(values["level"]) .. "\n"
        end
        visitorsSkills[visitor["name"]] = infos
    end
    return visitorsSkills
end
visitors.getSkillsAndCost = getSkillsAndCost