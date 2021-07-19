--- LOADING LIBS ---
local v = {}

--- GLOBAL VARIABLES ---
local skill_level_list = {}
local min_level = 30 -- filters visitors minimum best skill level to be selected
local notify_level = 45 -- visitors with high levels will be notified by private message to a list of users
local players_to_notify = {
    "Ciliste",
    "DaikiKaminari"
}

--- METHODS UTILS ----
local function superior(a, b)
    return a > b
end

local function byval(a, b)
    return skill_level_list[a] > skill_level_list[b]
end


--- METHODS ----
-- notify a list of players of the presence of a visitor
local function notifyPlayers(chatbox, skill_name, skill_level, visitor_name, cost_resource, cost_number, coords)
    local msg = "Visitor [" .. visitor_name .. "] is LVL " .. tostring(skill_levelà .. " in " .. skill_name .. ".\n"
    msg = msg .. "Cost : " .. tostring(cost_number) .. " " .. cost_resource .. "."
    msg = msg .. "Coord : " .. tostring(coords["x"]) .. " " .. tostring(coords["y"]) .. " " .. tostring(coords["z"])
    for _, player in players_to_notify do
        chatbox.sendMessageToPlayer(msg, player)
    end
end

-- returns a table associating a visitor name and a string of his skills and cost
local function getSkillsAndCost(colony, chatbox)
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
            if skill_level_list[list[1]] >= notify_level then
                notifyPlayers(chatbox, skill_name, values["level"], visitor["name"], visitor["cost"]["displayName"], visitor["cost"]["count"], visitor["location"])
            end
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