local DataStoreService = game:GetService("DataStoreService")
local moneyStore = DataStoreService:GetDataStore("PlayerStats")
local ClickDetector = script.Parent:WaitForChild("ClickDetector")
local generatorCost = 100 -- Définir le coût du générateur

local function saveStats(player)
	local success, err = pcall(function()
		local stats = {
			Money = player.leaderstats.Money.Value,
			EXP = player.leaderstats.EXP.Value,
			Level = player.leaderstats.Level.Value,
			HasGenerator = player:GetAttribute("HasGenerator") or false
		}
		moneyStore:SetAsync(player.UserId, stats)
	end)
	if not success then
		warn("Impossible de sauvegarder les stats pour le joueur: "..player.Name..": "..err)
	end
end

local function loadStats(player)
	local success, err = pcall(function()
		local stats = moneyStore:GetAsync(player.UserId)
		if type(stats) == "table" then
			player.leaderstats.Money.Value = stats.Money or 0
			player.leaderstats.EXP.Value = stats.EXP or 0
			player.leaderstats.Level.Value = stats.Level or 1
			player:SetAttribute("HasGenerator", stats.HasGenerator or false)
		else
			warn("Données invalides pour le joueur: "..player.Name)
		end
	end)
	if not success then
		warn("Impossible de charger les stats pour le joueur: "..player.Name..": "..err)
	end
end

game.Players.PlayerAdded:Connect(function(player)
	player:SetAttribute("HasGenerator", false) -- Valeur par défaut
	loadStats(player)

	-- Désactive le ClickDetector si le joueur a déjà un générateur
	if player:GetAttribute("HasGenerator") then
		ClickDetector.MaxActivationDistance = 0
	end
end)

ClickDetector.MouseClick:Connect(function(player)
	if player:GetAttribute("HasGenerator") then
		warn(player.Name.." possède déjà un générateur.")
		return -- Si le joueur a déjà un générateur, il ne peut pas en acheter un autre
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local money = leaderstats:FindFirstChild("Money")
		if money and money.Value >= generatorCost then
			money.Value = money.Value - generatorCost
			player:SetAttribute("HasGenerator", true)
			ClickDetector.MaxActivationDistance = 0 -- Désactive le ClickDetector après l'achat
		end 
	end 
end)
