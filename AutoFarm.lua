local DataStoreService = game:GetService("DataStoreService")
local moneyStore = DataStoreService:GetDataStore("PlayerMoney")
local interval = 10 -- Intervalle de temps en secondes pour l'autofarm
local saveInterval = 30 -- Sauvegarde toutes les 30 secondes

local function saveMoney(player)
	local success, err = pcall(function()
		moneyStore:SetAsync(player.UserId, player.leaderstats.Money.Value)
	end)
	if not success then
		warn("Impossible de sauvegarder l'argent pour le joueur: "..player.Name..": "..err)
	end
end

local function autoFarm()
	while true do
		for _, player in pairs(game.Players:GetPlayers()) do
			if player and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money") then
				player.leaderstats.Money.Value = player.leaderstats.Money.Value + 10 -- Change la valeur ajoutée si besoin
			end
		end
		wait(interval)
	end
end

local function periodicSave()
	while true do
		for _, player in pairs(game.Players:GetPlayers()) do
			if player and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money") then
				saveMoney(player)
			end
		end
		wait(saveInterval)
	end
end

spawn(autoFarm)
spawn(periodicSave)
