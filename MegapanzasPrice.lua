-- ==========================================================
-- MegapanzasPrice.lua - VERSIÓN TOTAL (Sincronizada al 100%)
-- ==========================================================

if not MegapanzasPriceDB then MegapanzasPriceDB = {} end

-- Lista extraída directamente de tu Analyzer HTML (66 ítems)
local itemsToScan = {
    "Arcane Elixir", "Combat Healing Potion", "Combat Mana Potion",
    "Danonzos Tel'abim Delight", "Danonzos Tel'abim Medley", "Demonic Rune",
    "Dense Sharpening Stone", "Dreamshard Elixir", "Dreamtonic",
    "Elemental Sharpening Stone", "Elixir of Agility", "Elixir of Brute Force",
    "Elixir of Detect Lesser Invisibility", "Elixir of Fortitude", "Elixir of Giant Growth",
    "Elixir of Giants", "Elixir of Greater Defense", "Elixir of Greater Intellect",
    "Elixir of Shadow Power", "Elixir of Superior Defense", "Elixir of the Mongoose",
    "Elixir of the Sages", "Fire Protection Potion", "Flask of Supreme Power",
    "Flask of the Titans", "Free Action Potion", "Gift of Arthas",
    "Greater Arcane Elixir", "Greater Arcane Protection Potion", "Greater Fire Protection Potion",
    "Greater Mana Potion", "Gurubashi Gumbo", "Hardened Mushroom",
    "Le Fishe au Chocolat", "Limited Invulnerability Potion", "Major Healing Potion",
    "Major Mana Potion", "Mighty Rage Potion", "Nightfin Soup",
    "Potion of Quickness", "Power Mushroom", "Restorative Potion",
    "Rumsey Rum Black Label", "Thistle Tea", "Winterfall Firewater", "Wizard Oil",
    "Grilled Squid", "Smoked Desert Dumplings", "Dirge's Kickin' Chimaerok Chops",
    "Runn Tum Tubber", "Blessed Sunfruit", "Cerebral Cortex Compound",
    "Gizzard Gum", "Ground Scorpok Assay", "Lung Juice Cocktail", "R.O.I.D.S.",
    "Juju Flurry", "Juju Power", "Juju Might", "Juju Ember", "Juju Chill", "Juju Escape",
    "Rumsey Rum Dark", "Kreeg's Stout Beatdown", "Savory Deviate Delight", "Noggenfogger Elixir"
}

local currentIndex = 1
local isScanning = false
local nextStepTime = 0
local WAIT_TIME = 5.0 -- Mantenemos 5 segundos por seguridad

local frame = CreateFrame("Frame")
frame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")

local function GetTimestamp()
    return date("%Y%m%d%H%M")
end

local function ScanCurrentPage()
    if not isScanning then return end
    local batch = GetNumAuctionItems("list")
    local currentTarget = itemsToScan[currentIndex]
    local minBuyout = 0
    local foundAny = false
    
    if batch > 0 then
        for i = 1, batch do
            local name, _, stack, _, _, _, _, _, buyout = GetAuctionItemInfo("list", i)
            if name == currentTarget and buyout > 0 then
                foundAny = true
                local pricePerUnit = buyout / stack
                if minBuyout == 0 or pricePerUnit < minBuyout then
                    minBuyout = pricePerUnit
                end
            end
        end
    end
    
    -- Si no hay stock o el servidor no respondió a tiempo, marcamos -1
    local finalPrice = foundAny and math.floor(minBuyout) or -1
    MegapanzasPriceDB.prices[string.lower(currentTarget)] = finalPrice
end

frame:SetScript("OnEvent", function()
    if event == "AUCTION_ITEM_LIST_UPDATE" and isScanning then
        ScanCurrentPage()
    end
end)

frame:SetScript("OnUpdate", function()
    if isScanning then
        if GetTime() >= nextStepTime then
            if currentIndex > 0 and currentIndex <= table.getn(itemsToScan) then
                ScanCurrentPage()
            end

            currentIndex = currentIndex + 1
            
            if currentIndex <= table.getn(itemsToScan) then
                local nextItem = itemsToScan[currentIndex]
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Megapanzas:|r ["..currentIndex.."/"..table.getn(itemsToScan).."] Escaneando: " .. nextItem)
                nextStepTime = GetTime() + WAIT_TIME
                QueryAuctionItems(nextItem, nil, nil, 0, 0, 0, 0, 0, 0)
            else
                isScanning = false
                MegapanzasPriceDB.status = "complete"
                MegapanzasPriceDB.last_update = tonumber(GetTimestamp())
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Megapanzas:|r ¡ESCANEADO FINALIZADO! Status: COMPLETE.")
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Megapanzas:|r Escribe /reload para guardar antes de ir al Analyzer.")
            end
        end
    end
end)

function Megapanzas_StartScan()
    if not AuctionFrame:IsVisible() then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Megapanzas:|r Error: Abre la ventana de subasta.")
        return
    end
    
    -- Limpieza profunda para asegurar que no queden datos viejos de otras versiones
    MegapanzasPriceDB = {
        ["status"] = "incomplete",
        ["last_update"] = tonumber(GetTimestamp()),
        ["prices"] = {}
    }
    
    currentIndex = 0 
    isScanning = true
    nextStepTime = GetTime()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Megapanzas:|r Iniciando escaneo de los 66 consumibles (5s p/u)...")
end

SLASH_MEGAPANZAS1 = "/mp"
SlashCmdList["MEGAPANZAS"] = function(msg)
    Megapanzas_StartScan()
end