local addonName, addon = ...
LibStub('AceAddon-3.0'):NewAddon(addon, addonName, 'AceConsole-3.0')

-- required API to do tooltip scanning
if not C_TooltipInfo or not C_TooltipInfo.GetOwnedItemByID then
  return
end

local bb = LibStub('AceAddon-3.0'):GetAddon("BetterBags")
local categories = bb:GetModule('Categories')
local L = bb:GetModule('Localization')

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

]]-- 

categories:RegisterCategoryFunction("ShadowlandsFilter", function (data)

  -- addon:Print("Candidate for SL category " .. data.itemInfo.itemName)

  local tooltipInfo = C_TooltipInfo.GetOwnedItemByID(data.itemInfo.itemID)
  
  for k,v in pairs(tooltipInfo.lines) do
    if v.type == 0 then
    local text = extractColoredText(v.leftText)
      -- addon:Print(data.itemInfo.itemName .. " tooltip line: " .. text)
      if text then

        -- this stuff isn't tagged by expansion so we have to catch it first
        if string.find(v.leftText, "Companions") then
          return L:G("Consumable - Champion Equipment")
        end

        if data.itemInfo.expacID ~= LE_EXPANSION_SHADOWLANDS then
          return nil
        end

        -- generic category for expansion's "farm" stuff
        local farm = "|cff00c0ffFarm|r"

        if "Anima" == text then
          return L:G("Consumable - Anima")
        end
        if "Korthian Relics" == text then
          return L:G("Consumable - Korthian Relics")
        end
        if string.find(v.leftText, "Conduit") then
          return L:G("Consumable - Conduits")
        end
        if string.find(v.leftText, "Use: Gain %d+ Stygia") then
          return L:G("Consumable - Stygia")
        end
        -- Ardenweald farming
        if string.find(v.leftText, "Queen's Conservatory") then
          return L:G(farm)
        end
        -- Maldraxus farming
        if string.find(v.leftText, "Butchers Block") then
          return L:G(farm)
        end
        if string.find(v.leftText, "Abominable Stitching") then
          return L:G(farm)
        end
        -- addon:Print(data.itemInfo.itemName .. " NOMATCH: " .. v.leftText)
      end
    end
  end

  return nil
end)
