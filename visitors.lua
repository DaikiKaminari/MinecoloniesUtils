--- LOADING LIBS ---
local v = {}

--- GLOBAL VARIABLES ---
local skill_level_list = {}
local min_level = 30 -- filters visitors minimum best skill level to be selected
local notify_level = 45 -- visitors with high levels will be notified by private message to a list of users
local players_to_notify = { -- players to notify when a high stat visitor is here
    "Ciliste",
    "DaikiKaminari"
}
local id_notified_visitors = {} -- keep track of already notified visitors to avoid chat spamming

--- METHODS UTILS ----
local function superior(a, b)
    return a > b
end

local function byval(a, b)
    return skill_level_list[a] > skill_level_list[b]
end

local function contains(table, value)
    for _, v in pairs(table) do
        if value == v then
            return true
        end
    end
    return false
end


--- METHODS ----
-- notify a list of players of the presence of a visitor
local function notifyPlayers(chatbox, visitor_id, skill_name, skill_level, visitor_name, cost_resource, cost_number, coords)
    if contains(id_notified_visitors, visitor_id) then return end
    local msg = "Visitor [" .. visitor_name .. "] is LVL " .. tostring(skill_level) .. " in " .. skill_name .. ".\n"
    msg = msg .. "Cost : " .. tostring(cost_number) .. " " .. cost_resource .. ". "
    msg = msg .. "Coords : " .. tostring(coords["x"]) .. " " .. tostring(coords["y"]) .. " " .. tostring(coords["z"])
    for _, player in pairs(players_to_notify) do
        chatbox.sendMessageToPlayer(msg, player)
        sleep(1)
    end
    id_notified_visitors[#id_notified_visitors+1] = visitor_id
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
            if values["level"] >= notify_level then
                notifyPlayers(chatbox, visitor["id"], skill_name, values["level"], visitor["name"], visitor["cost"]["displayName"], visitor["cost"]["count"], visitor["location"])
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