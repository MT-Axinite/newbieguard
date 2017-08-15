-- newbieguard - a mode for Minetest
-- (C) 2017 Tai "DuCake" Kedzierski
-- Provided under the terms of the GNU Lesser General Public License v3.0, or later versions thereof.

newplayers = {}

local defense_age = tonumber(minetest.setting_get("newbieguard.defense_age") or 20) * 60 -- 20 minutes default
local step_period = tonumber(minetest.setting_get("newbieguard.step_period") or 2) -- default, increment every 2 seconds

local join_message = minetest.setting_get("newbieguard.onjoin") or "Welcome ! You are immune to PvP as a newbie."
local warn_message = minetest.setting_get("newbieguard.warning") or "Beware ! You are no logner immune to PvP !"

local step_increment = 0
local save_increment = 0

local newbiesfile = minetest.get_worldpath().."/newbies.ser"

local function save_newbies()
        local serdata = minetest.serialize(newplayers)
        if not serdata then
                minetest.log("info", "[newbies] serialization failed")
                return
        end
        local file, err = io.open(newbiesfile, "w")
        if err then
                return err
        end
        file:write(serdata)
        file:close()
end

local function load_newbies()
        local file, err = io.open(newbiesfile, "r")
        if err then
                minetest.log("info", "[newbies] No newbies file found")
                return
        end
        newplayers = minetest.deserialize(file:read("*a"))
        file:close()
end

load_newbies()

-- =====================
-- Guard system

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)

	if not hitter:is_player() then return end

	local playername = player:get_player_name()
	local newbie_stats = newplayers[playername]

	if newbie_stats and newbie_stats.age < defense_age then
		minetest.debug("Not hitting "..playername.." - age is "..tostring(newbie_stats.age))
		return true
	end
end)

-- =====================
-- Global timers

minetest.register_globalstep(function(dtime)
	step_increment = step_increment + dtime

	if step_increment > step_period then

		for _,player_o in pairs(minetest.get_connected_players() ) do
			local playername = player_o:get_player_name()
			local player_stats = newplayers[playername]

			if player_stats then
				if player_stats.age > defense_age then
					newplayers[playername] = nil
					minetest.chat_send_player(playername, warn_message)
				else
					newplayers[playername].age = player_stats.age + step_increment
				end
			end
		end

		step_increment = 0
	end
end)

minetest.register_globalstep(function(dtime)
	save_increment = save_increment + dtime

	if save_increment > 10 then
		save_newbies()
	end
end)

-- =============
-- Joining and advising

local function time_remaining(playername)
	local time_s = defense_age - math.ceil(newplayers[playername].age)

	remain_s = time_s % 60
	local remain_m = (time_s - remain_s ) / 60

	local str_remain = tostring(remain_m).."min, "..tostring(remain_s).."sec"

	return str_remain
end

local function advise_newbie(playername)
	if newplayers[playername] then
		minetest.chat_send_player(playername, "Immune Newbie Time: "..time_remaining(playername))
	end
end

minetest.register_on_newplayer(function(player)
	local playername = player:get_player_name()

	newplayers[playername] = {age = 0}

	minetest.chat_send_player(playername, join_message)
	advise_newbie(playername)
end)

minetest.register_on_joinplayer(function(player)
	local playername = player:get_player_name()

	advise_newbie(playername)
end)
