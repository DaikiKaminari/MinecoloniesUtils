--- LOADING LIBS ---
local v = {}

--- GLOBAL VARIABLES ---
local skill_level_list = {}
local min_level = 30 -- filters visitors minimum best skill level to be selected

--- METHODS UTILS ----
local function superior(a, b)
    return a > b
end

local function byval(a, b)
    return skill_level_list[a] > skill_level_list[b]
end


--- METHODS ----
-- returns a table associating a visitor name and a string of his skills and cost
local function getSkillsAndCost(colony)
    local visitorsSkills = {}
    local skills
    local visitors = colony.getVisitors()
    for _, visitor in pairs(visitors) do
        infos = "Cost : " .. visitor["cost"]["displayName"] .. " (" .. tostring(visitor["cost"]["count"]) ..")\n\n"
        infos = infos .. "Coords :\n" .. tostring(visitor["location"]["x"]) .. " ".. tostring(visitor["location"]["y"]) .. " " .. tostring(visitor["location"]["z"]) .. "\n\n"
        local list = {}
        for skill_name, values in pairs(visitor["skills"]) do
            skill_level_list[skill_name] = values["level"]
            list[#list+1] = skill_name
        end
        table.sort(list, byval)
        for k=1, #list do
            infos = infos .. list[k] ..  string.rep(" ", 13-string.len(list[k])) .. tostring(skill_level_list[list[k]]) .. "\n"
        end
        if skill_level_list[list[1]] >= min_level then
            visitorsSkills[visitor["name"]] = infos
        end
    end
    return visitorsSkills
end
v.getSkillsAndCost = getSkillsAndCost

return v