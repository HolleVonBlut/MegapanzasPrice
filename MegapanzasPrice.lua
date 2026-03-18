-- ==========================================================
-- MegapanzasPrice.lua - VERSIÓN TOTAL (Sincronizada al 100%)
-- ==========================================================

if not MegapanzasPriceDB then MegapanzasPriceDB = {} end

-- Lista extraída directamente de tu Analyzer HTML (66 ítems) + nuevos items
local itemsToScan = {
    "Arcane Elixir", "Combat Healing Potion", "Combat Mana Potion",
    "Danonzo's Tel'abim Delight", "Danonzo's Tel'abim Medley", "Demonic Rune",
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
    "Rumsey Rum Dark", "Kreeg's Stout Beatdown", "Savory Deviate Delight", "Noggenfogger Elixir",
    -- Greater Protection Potions
    "Greater Frost Protection Potion", "Greater Holy Protection Potion", 
    "Greater Nature Protection Potion", "Greater Shadow Protection Potion",
    -- Protection Potions
    "Arcane Protection Potion", "Frost Protection Potion", 
    "Holy Protection Potion", "Nature Protection Potion", "Shadow Protection Potion",
    -- Oils
    "Mana Oil", "Shadow Oil", "Frost Oil",
    -- Scrolls Level IV
    "Scroll of Protection IV", "Scroll of Stamina IV", "Scroll of Strength IV",
    "Scroll of Agility IV", "Scroll of Intellect IV", "Scroll of Spirit IV",
    -- Food Adicional
    "Midsummer Sausage", "Crocolisk BBQ", "Dragonbreath Chili", "Heavy Kodo Stew"
}

local currentIndex = 1
local isScanning = false
local nextStepTime = 0
local WAIT_TIME = 5.0

local frame = CreateFrame("Frame")
frame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
frame:RegisterEvent("AUCTION_HOUSE_CLOSED")

local function GetTimestamp()
    return date("%Y%m%d%H%M")
end

local function StopScan(reason)
    if isScanning then
        isScanning = false
        MegapanzasPriceDB.status = reason or "incomplete"
        if reason == "complete" then
            MegapanzasPriceDB.last_update = tonumber(GetTimestamp())
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Megapanzas:|r ¡ESCANEADO FINALIZADO! Status: COMPLETE.")
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Megapanzas:|r Escribe /reload para guardar antes de ir al Analyzer.")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Megapanzas:|r ⚠️ ESCANEO INCOMPLETO: Cerraste la subasta prematuramente. Vuelve a intentarlo.")
        end
    end
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
    
    local finalPrice = foundAny and math.floor(minBuyout) or -1
    MegapanzasPriceDB.prices[string.lower(currentTarget)] = finalPrice
end

frame:SetScript("OnEvent", function()
    if event == "AUCTION_ITEM_LIST_UPDATE" and isScanning then
        ScanCurrentPage()
    elseif event == "AUCTION_HOUSE_CLOSED" and isScanning then
        StopScan("incomplete")
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
                StopScan("complete")
            end
        end
    end
end)

function Megapanzas_StartScan()
    if not AuctionFrame:IsVisible() then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Megapanzas:|r Error: Abre la ventana de subasta.")
        return
    end
    
    MegapanzasPriceDB = {
        ["status"] = "incomplete",
        ["last_update"] = tonumber(GetTimestamp()),
        ["prices"] = {}
    }
    
    currentIndex = 0 
    isScanning = true
    nextStepTime = GetTime()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Megapanzas:|r Iniciando escaneo de los "..table.getn(itemsToScan).." consumibles (5s p/u)...")
end

SLASH_MEGAPANZAS1 = "/mp"
SlashCmdList["MEGAPANZAS"] = function(msg)
    Megapanzas_StartScan()
end