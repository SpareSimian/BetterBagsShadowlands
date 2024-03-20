local addonName, addon = ...
LibStub('AceAddon-3.0'):NewAddon(addon, addonName, 'AceConsole-3.0')

-- required API to do tooltip scanning
if not C_TooltipInfo or not C_TooltipInfo.GetOwnedItemByID then
  return
end

local bb = LibStub('AceAddon-3.0'):GetAddon("BetterBags")
local categories = bb:GetModule('Categories')
local L = bb:GetModule('Localization')

-- categories:AddItemToCategory(12345, L:G("My Category"))
-- categories:WipeCategory(L:G("My Category"))

local function extractColoredText(text)
  local found, _, itemString = string.find(text, "|c%x%x%x%x%x%x%x%x(.+)|r")
  if found then
    return itemString
  else
    return text
  end
end

--[[

categories to build:
Anima
Korthian Relics
Conduits
Stygia

categories shared with other expansions:
Champion Equipment
Lootable

]]-- 

categories:RegisterCategoryFunction("ShadowlandsFilter", function (data)
  if data.itemInfo.expacID ~= LE_EXPANSION_SHADOWLANDS then
    return nil
  end

  -- addon:Print("Candidate for SL category " .. data.itemInfo.itemName)

  local tooltipInfo = C_TooltipInfo.GetOwnedItemByID(data.itemInfo.itemID)
  
  local text
  for k,v in pairs(tooltipInfo.lines) do
    if v.type == 0 then
      text = extractColoredText(v.leftText)
      -- addon:Print(data.itemInfo.itemName .. " tooltip line: " .. text)
      if text then
        if "Anima" == text then
          return L:G("Anima")
        end
        if "Korthian Relics" == text then
          return L:G("Korthian Relics")
        end
        if string.find(v.leftText, "learning all Conduits") then
          return L:G("Conduits")
        end
        if string.find(v.leftText, "Discover an upgrade to a random Conduit") then
          return L:G("Conduits")
        end
        if string.find(v.leftText, "(Potency|Enhanced|Finesse) Conduit") then
          return L:G("Conduits")
        end
        if string.find(v.leftText, "Open your Companions page and use this item to grant") then
          return L:G("Champion Equipment")
        end
        if string.find(v.leftText, "Use: Gain %d+ Stygia") then
          return L:G("Stygia")
        end
        -- addon:Print(data.itemInfo.itemName .. " NOMATCH: " .. v.leftText)
      end
    end
  end

  return nil
end)
