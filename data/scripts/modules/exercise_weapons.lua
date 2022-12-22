local function initTraining(player, item, target)
	if os.time() < player:getStorageValue(PlayerStorageKeys.trainingWeaponCooldown) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Please wait a few seconds before selecting a target again.")
		return false
	end
	player:setStorageValue(PlayerStorageKeys.trainingWeaponCooldown, os.time() + 5)
	
	if target and target:isItem() then
		local itemId = target:getType():getId()
		if itemId > 31213 and itemId < 31222 then
			player:startTraining(item, target)
			return true
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You may only use it on exercise target.")
		end
	end
	
	return false
end

local function isRangedTraining(itemId)
	local t = ItemType(itemId)
	local n = t:getName():lower()
	return n:match("wand") or n:match("rod") or n:match("bow")
end

local trainingWeaponMelee = Action()
function trainingWeaponMelee.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return initTraining(player, item, target)
end

local trainingWeaponRanged = Action()
function trainingWeaponRanged.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getTopParent() ~= player then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Take up the weapon before using it.")
		return false
	end

	if player:getPosition():getDistance(target:getPosition()) > 6 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Stand closer to the target.")
		return false
	end
	
	return initTraining(player, item, target)
end

-- training
for itemId = 31196, 31201 do
	if isRangedTraining(itemId) then
		trainingWeaponRanged:id(itemId)
	else
		trainingWeaponMelee:id(itemId)
	end	
end
-- normal
for itemId = 31208, 31213 do
	if isRangedTraining(itemId) then
		trainingWeaponRanged:id(itemId)
	else
		trainingWeaponMelee:id(itemId)
	end	
end

-- durable, lasting
for itemId = 37935, 37946 do
	if isRangedTraining(itemId) then
		trainingWeaponRanged:id(itemId)
	else
		trainingWeaponMelee:id(itemId)
	end	
end

trainingWeaponRanged:allowFarUse(true)
trainingWeaponRanged:register()
trainingWeaponMelee:register()
