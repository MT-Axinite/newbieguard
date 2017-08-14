newplayers = {}

local defense_age = tonumber(minetest.setting_get("newbieguard.defense_age")) * 60 or  60 * 20 -- 20 minutes default
local step_period = tonumber(minetest.setting_get("newbieguard.step_period")) or 2 -- default, increment every 2 seconds

local step_increment = 0
local save_increment = 0

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)

	if not hitter:is_player() then return end

	local playername = player:get_player_name()
	local newbie_stats = newplayers[playername]

	if newbie_stats and newbie_stats.age < defense_age then
		return true
	end
end)

local function save_newbies()
	-- TODO - save to file
end

minetest.register_globalstep(function(dtime)
	step_increment += dtime

	if dtime > step_period then

		for playername,player_stats in pairs(newplayers) do
			if player_stats.age > defense_age then
				newplayers[playername] = nil
			else
				newplayers[playername].age += step_increment
			end
		end

		step_increment = 0
	end
end)

minetest.register_globalstep(function(dtime)
	save_increment += dtime

	if save_increment > 10 then
		save_newbies()
	end
end)

minetest.register_on_newplayer(function(player)
	local playername = player:get_player_name()

	newplayers[playername] = {age = 0}
end)
