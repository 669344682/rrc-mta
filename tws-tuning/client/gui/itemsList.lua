itemsList = {}

local visibleItems = 5
local listItem = {
	space = 5,
	height = 30
}

local itemsTable = {}
local selectedItem = 1
local itemsOffsetTargetY = 0
local itemsOffsetY = 0

local mainSectionName = ""
local subsectionName = ""

function itemsList.start(y, width, sectionName, itemID)
	itemsList.stop()
	
	itemsList.started = true
	itemsList.y = y
	itemsList.width = width
	itemsList.height = (listItem.height + listItem.space) * visibleItems - listItem.space
	itemsList.x = (screenWidth - itemsList.width) / 2

	listItem.width = itemsList.width

	bindKey("arrow_u", "down", itemsList.prev)
	bindKey("arrow_d", "down", itemsList.next)
	bindKey("enter", "down", itemsList.select)

	mainSectionName = sectionName
end

function itemsList.stop()
	itemsList.setItems()
	unbindKey("arrow_u", "down", itemsList.prev)
	unbindKey("arrow_d", "down", itemsList.next)
	unbindKey("enter", "down", itemsList.select)
	itemsList.started = false
end

function itemsList.draw(fade)
	if #itemsTable == 0 then
		return
	end

	local fadeOffset = -fade * itemsList.y * 3

	itemsOffsetY = itemsOffsetY + (itemsOffsetTargetY - itemsOffsetY) * 0.2

	x = itemsList.x 
	y = itemsList.y
	local myMoney = localPlayer:getData("tws-money")
	for i = math.max(1, selectedItem - 2), math.min(selectedItem + 2, #itemsTable) do
		local item = itemsTable[i]
		local alpha = 1 - math.abs(item.y + itemsOffsetY + listItem.height / 2 - (itemsList.y + itemsList.height/2)) / itemsList.height * 3
		if alpha > 0 then
			if not item.price then
				item.price = 0
			end
			local textColor = getColor(colors.white, 200 * alpha)
			local priceTextColor = getColor(colors.white, 200 * alpha)
			local backgroundColor = getColor(colors.black, 150 * alpha)
			if myMoney < item.price then
				textColor = getColor(colors.white, 30 * alpha)
				priceTextColor = tocolor(255, 0, 0, 200 * alpha)
			end
			dxDrawRoundRectangle(x, fadeOffset + item.y + itemsOffsetY, listItem.width, listItem.height, backgroundColor, 10)
			dxDrawText(item.text, x, fadeOffset + item.y + itemsOffsetY, x + listItem.width, fadeOffset + item.y + listItem.height + itemsOffsetY, textColor, 1.2 * mainScale, "default-bold", "center", "center")
			if myMoney < item.price then
				dxDrawImage(x + listItem.width / 2 - 8, fadeOffset + item.y + itemsOffsetY + listItem.height / 2 - 8, 16, 16, "images/lock.png")
			end		
			-- Цена
			local priceText = item.price
			local priceX = x + itemsList.width + 10 * mainScale
			dxDrawRoundRectangle(priceX, fadeOffset + item.y + itemsOffsetY, listItem.width / 3, listItem.height, getColor(colors.black, 150 * alpha), 10)
			dxDrawText("$" .. tostring(priceText), priceX, fadeOffset + item.y + itemsOffsetY, priceX + listItem.width / 3, fadeOffset + item.y + listItem.height + itemsOffsetY, priceTextColor, 1.2 * mainScale, "default-bold", "center", "center")
		end
	end	

	-- Arrows
	listArrow.draw(itemsList.x + (itemsList.width - listArrow.size) / 2, fadeOffset + itemsList.y - listItem.height / 2, 270, "arrow_u")
	listArrow.draw(itemsList.x + (itemsList.width - listArrow.size) / 2, fadeOffset + itemsList.y + itemsList.height - listArrow.size + listItem.height / 2, 90, "arrow_d")
end

function itemsList.setItems(items, sectionName)
	itemsTable = {}
	tuningUpgrades.hide(mainSectionName .. "-" .. subsectionName)
	if not items then
		return
	end
	local y = itemsList.y
	for i, item in ipairs(items) do
		local newItem = {y = y, text = item.text, name = item.name, price = item.price}
		if not newItem.price then
			newItem.price = 0
		end
		table.insert(itemsTable, newItem)
		y = y + listItem.height + listItem.space
	end
	subsectionName = sectionName

	local currentUpgrade = tuningUpgrades.getUpgrade(mainSectionName .. "-" .. subsectionName)
	selectedItem = currentUpgrade
	itemsList.setSelectedItem(currentUpgrade)	
end

function itemsList.setSelectedItem(index)
	if not itemsTable or #itemsTable == 0 then
		return
	end
	if index < 1 then
		index = 1
	elseif index > #itemsTable then
		index = #itemsTable
	end
	selectedItem = index
	itemsOffsetTargetY = -itemsTable[selectedItem].y + itemsList.y + itemsList.height / 2 - listItem.height / 2

	if itemsTable[selectedItem].name then
		tuningUpgrades.show(mainSectionName .. "-" .. subsectionName, itemsTable[selectedItem].name)
	end
end

function itemsList.prev()
	if isMTAWindowActive() then
		return
	end
	itemsList.setSelectedItem(selectedItem - 1)
	playSoundFrontEnd(tuningConfig.sounds.select_items)
end

function itemsList.next()
	if isMTAWindowActive() then
		return
	end
	itemsList.setSelectedItem(selectedItem + 1)
	playSoundFrontEnd(tuningConfig.sounds.select_items)
end

function itemsList.select()
	if itemsTable and #itemsTable > 0 then
		tuningUpgrades.buy(mainSectionName .. "-" .. subsectionName, itemsTable[selectedItem].name, itemsTable[selectedItem].price, selectedItem)
	end
end