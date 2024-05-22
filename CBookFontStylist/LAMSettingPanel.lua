--
-- Calamath's BookFont Stylist [CBFS]
--
-- Copyright (c) 2020 Calamath
--
-- This software is released under the Artistic License 2.0
-- https://opensource.org/licenses/Artistic-2.0
--

if not CBookFontStylist then return end
local CBFS = CBookFontStylist:SetSharedEnvironment()
-- ---------------------------------------------------------------------------------------
local L = GetString
local LMP = LibMediaProvider
local LAM = LibAddonMenu2

-- ---------------------------------------------------------------------------------------
-- CBookFontStylist LAMSettingPanel Class
-- ---------------------------------------------------------------------------------------
local CBFS_LAMSettingPanel = CT_LAMSettingPanelController:Subclass()
function CBFS_LAMSettingPanel:Initialize(panelId, currentSavedVars, accountWideSavedVars, defaults)
	CT_LAMSettingPanelController.Initialize(self, panelId)	-- Note: Inherit template class but not use as an initializing object.
	self.svCurrent = currentSavedVars or {}
	self.svAccount = accountWideSavedVars or {}
	self.SV_DEFAULT = defaults or {}

	self.db = accountWideSavedVars or {}

	self.fontManager = GetFontManager()
	self.uiLang = GetCVar("Language.2")
	self.uiIsGamepad = IsInGamepadPreferredMode()
	EVENT_MANAGER:RegisterForEvent(self.panelId, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED, function(_, gamepadPreferred)
		self.uiIsGamepad = gamepadPreferred
		self:RefreshGameModeDisplay()
	end)
	self.uiBMID = BMID_YELLOWED_PAPER
end

function CBFS_LAMSettingPanel:CreateSettingPanel()
	local fontChoices = LMP:List("font")
	local fontChoicesValues = fontChoices
	local fontChoicesTooltips = fontChoices

	local panelData = {
		type = "panel", 
		name = "CBookFontStylist", 
		displayName = "Calamath's BookFont Stylist", 
		author = CBFS.author, 
		version = CBFS.version, 
		website = "https://www.esoui.com/downloads/info2505-CalamathsBookFontStylist.html", 
		slashCommand = "/cbfs.settings", 
		registerForRefresh = true, 
		registerForDefaults = true, 
		resetFunc = function() self:OnPanelDefaultButtonClicked() end, 
	}
	LAM:RegisterAddonPanel(self.panelId, panelData)

	local optionsData = {}
	optionsData[#optionsData + 1] = {
		type = "description", 
		title = "", 
		text = L(SI_CBFS_UI_PANEL_HEADER1_TEXT), 
	}
	local bookMediumChoices = {
		L(SI_CBFS_BMID_YELLOWED_PAPER_NAME), 	-- "Yellowed Paper"
		L(SI_CBFS_BMID_ANIMAL_SKIN_NAME), 		-- "Animal Skin"
		L(SI_CBFS_BMID_RUBBING_PAPER_NAME),  	-- "Rubbing Paper"
		L(SI_CBFS_BMID_LETTER_NAME), 			-- "Letter"
		L(SI_CBFS_BMID_NOTE_NAME), 				-- "Note"
		L(SI_CBFS_BMID_SCROLL_NAME), 			-- "Scroll"
		L(SI_CBFS_BMID_STONE_TABLET_NAME), 		-- "Stone Tablet"
		L(SI_CBFS_BMID_METAL_NAME), 			-- "Metal"
		L(SI_CBFS_BMID_METAL_TABLET_NAME), 		-- "Metal Tablet"
		L(SI_CBFS_BMID_ELVEN_SCROLL_NAME), 		-- "Wood Elven Scroll"
		L(SI_CBFS_BMID_ANTIQUITY_CODEX_NAME), 	-- "Antiquity Codex"
	}
	local bookMediumChoicesValues = {
		BMID_YELLOWED_PAPER, 
		BMID_ANIMAL_SKIN, 
		BMID_RUBBING_PAPER, 
		BMID_LETTER, 
		BMID_NOTE, 
		BMID_SCROLL, 
		BMID_STONE_TABLET, 
		BMID_METAL, 
		BMID_METAL_TABLET, 
		BMID_ELVEN_SCROLL, 
		BMID_ANTIQUITY_CODEX, 
	}
	local bookMediumChoicesTooltips = {
		L(SI_CBFS_BMID_YELLOWED_PAPER_TIPS), 
		L(SI_CBFS_BMID_ANIMAL_SKIN_TIPS), 
		L(SI_CBFS_BMID_RUBBING_PAPER_TIPS), 
		L(SI_CBFS_BMID_LETTER_TIPS), 
		L(SI_CBFS_BMID_NOTE_TIPS), 
		L(SI_CBFS_BMID_SCROLL_TIPS), 
		L(SI_CBFS_BMID_STONE_TABLET_TIPS), 
		L(SI_CBFS_BMID_METAL_TIPS), 
		L(SI_CBFS_BMID_METAL_TABLET_TIPS), 
		L(SI_CBFS_BMID_ELVEN_SCROLL_TIPS), 
		L(SI_CBFS_BMID_ANTIQUITY_CODEX_TIPS), 
	}
	optionsData[#optionsData + 1] = {
		type = "dropdown", 
		name = L(SI_CBFS_UI_BMID_SELECT_MENU_NAME), 
		tooltip = L(SI_CBFS_UI_BMID_SELECT_MENU_TIPS), 
		choices = bookMediumChoices, 	-- If choicesValue is defined, choices table is only used for UI display!
		choicesValues = bookMediumChoicesValues, 
		choicesTooltips = bookMediumChoicesTooltips, 
		getFunc = function() return self.uiBMID end, 
		setFunc = function(newBMID) self:SetSelectedBookMedium(newBMID) end, 
--		sort = "name-up", --or "name-down", "numeric-up", "numeric-down", "value-up", "value-down", "numericvalue-up", "numericvalue-down" 
		width = "half", 
--		scrollable = true, 
		default = BMID_YELLOWED_PAPER, 
	}
	optionsData[#optionsData + 1] = {
		type = "description", 
		title = L(SI_CBFS_UI_GAMEMODE_DISPLAY_NAME), 
		text = function()
			return (self.uiIsGamepad and L(SI_CBFS_UI_GAMEMODE_GAMEPAD_NAME) or L(SI_CBFS_UI_GAMEMODE_KEYBOARD_NAME)) .. " - " .. zo_strupper(self.uiLang)
		end, 
		width = "half", 
		reference = "CBFS_UI_OptionsPanel_GameModeDisplay", 
	}
	local tabHeaderText = {
		[BMID_YELLOWED_PAPER]	= L(SI_CBFS_BMID_YELLOWED_PAPER_NAME), 
		[BMID_ANIMAL_SKIN]		= L(SI_CBFS_BMID_ANIMAL_SKIN_NAME), 
		[BMID_RUBBING_PAPER]	= L(SI_CBFS_BMID_RUBBING_PAPER_NAME), 
		[BMID_LETTER]			= L(SI_CBFS_BMID_LETTER_NAME), 
		[BMID_NOTE] 			= L(SI_CBFS_BMID_NOTE_NAME), 
		[BMID_SCROLL]			= L(SI_CBFS_BMID_SCROLL_NAME), 
		[BMID_STONE_TABLET] 	= L(SI_CBFS_BMID_STONE_TABLET_NAME), 
		[BMID_METAL]			= L(SI_CBFS_BMID_METAL_NAME), 
		[BMID_METAL_TABLET] 	= L(SI_CBFS_BMID_METAL_TABLET_NAME), 
		[BMID_ELVEN_SCROLL] 	= L(SI_CBFS_BMID_ELVEN_SCROLL_NAME), 
		[BMID_ANTIQUITY_CODEX] 	= L(SI_CBFS_BMID_ANTIQUITY_CODEX_NAME), 
	}
	optionsData[#optionsData + 1] = {
		type = "header", 
		name = function()
			return zo_strformat(L(SI_CBFS_UI_TAB_HEADER_FORMATTER), tabHeaderText[self.uiBMID])
		end, 
		reference = "CBFS_UI_OptionsPanel_TabHeader", 
	}
	optionsData[#optionsData + 1] = {
		type = "dropdown", 
		name = L(SI_CBFS_UI_BODYFONT_MENU_NAME), 
		tooltip = L(SI_CBFS_UI_BODYFONT_MENU_TIPS), 
		choices = fontChoices, 
		choicesValues = fontChoicesValues, 
		choicesTooltips = fontChoicesTooltips, 
		getFunc = function() return self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].bodyStyle end, 
		setFunc = function(styleStr)
			self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].bodyStyle = styleStr
			if self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleAuto then
				CBFS_UI_OptionsPanel_TitleFontMenu:UpdateValue(false, styleStr)
			end
			self:RefreshFontPreviewWindow()
			self:RefreshErrorMessageDisplay()
		end, 
--		sort = "name-up", --or "name-down", "numeric-up", "numeric-down", "value-up", "value-down", "numericvalue-up", "numericvalue-down" 
		scrollable = 15, 
		default = function()
			local bodyFont = GetBookMediumBodyFont(self.uiBMID, self.uiIsGamepad)
			return self.fontManager:GetDefaultFontStyle(bodyFont)
		end, 
		reference = "CBFS_UI_OptionsPanel_BodyFontMenu", 
	}
	optionsData[#optionsData + 1] = {
		type = "slider", 
		name = L(SI_CBFS_UI_BODYSIZE_MENU_NAME), 
		tooltip = L(SI_CBFS_UI_BODYSIZE_MENU_TIPS), 
		min = 8,
		max = 40,
		step = 1, 
		getFunc = function() return self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].bodySize end, 
		setFunc = function(sizeNum)
			self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].bodySize = sizeNum
			if self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleAuto then
				CBFS_UI_OptionsPanel_TitleSizeMenu:UpdateValue(false, sizeNum + 10)
			end
			self:RefreshFontPreviewWindow()
		end, 
		clampInput = false, 
		default = function()
			local bodyFont = GetBookMediumBodyFont(self.uiBMID, self.uiIsGamepad)
			return self.fontManager:GetDefaultFontSize(bodyFont)
		end, 
		reference = "CBFS_UI_OptionsPanel_BodySizeMenu", 
	}
	local fontWeightChoices = {
		L(SI_CBFS_WEIGHT_NORMAL_NAME), 				-- "normal", 
		L(SI_CBFS_WEIGHT_SHADOW_NAME), 				-- "shadow", 
		L(SI_CBFS_WEIGHT_OUTLINE_NAME), 			-- "outline", 
		L(SI_CBFS_WEIGHT_THICK_OUTLINE_NAME), 		-- "thick-outline", 
		L(SI_CBFS_WEIGHT_SOFT_SHADOW_THIN_NAME), 	-- "soft-shadow-thin", 
		L(SI_CBFS_WEIGHT_SOFT_SHADOW_THICK_NAME), 	-- "soft-shadow-thick", 
	}
	local fontWeightChoicesValues = {
		"normal", 
		"shadow", 
		"outline", 
		"thick-outline", 
		"soft-shadow-thin", 
		"soft-shadow-thick", 
	}
	local fontWeightChoicesTooltips = {
		L(SI_CBFS_WEIGHT_NORMAL_TIPS), 
		L(SI_CBFS_WEIGHT_SHADOW_TIPS), 
		L(SI_CBFS_WEIGHT_OUTLINE_TIPS), 
		L(SI_CBFS_WEIGHT_THICK_OUTLINE_TIPS), 
		L(SI_CBFS_WEIGHT_SOFT_SHADOW_THIN_TIPS), 
		L(SI_CBFS_WEIGHT_SOFT_SHADOW_THICK_TIPS), 
	}
	optionsData[#optionsData + 1] = {
		type = "dropdown", 
		name = L(SI_CBFS_UI_BODYWEIGHT_MENU_NAME), 
		tooltip = L(SI_CBFS_UI_BODYWEIGHT_MENU_TIPS), 
		choices = fontWeightChoices, 
		choicesValues = fontWeightChoicesValues, 
		choicesTooltips = fontWeightChoicesTooltips, 
		getFunc = function() return self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].bodyWeight end, 
		setFunc = function(weightStr)
			self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].bodyWeight = weightStr
			if self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleAuto then
				CBFS_UI_OptionsPanel_TitleWeightMenu:UpdateValue(false, weightStr)
			end
			self:RefreshFontPreviewWindow()
		end, 
--		sort = "name-up", --or "name-down", "numeric-up", "numeric-down", "value-up", "value-down", "numericvalue-up", "numericvalue-down" 
		default = function()
			local bodyFont = GetBookMediumBodyFont(self.uiBMID, self.uiIsGamepad)
			local defaultWeight = self.fontManager:GetDefaultFontWeight(bodyFont)
			if not defaultWeight or defaultWeight == "" then
				defaultWeight = "normal"
			end
			return defaultWeight
		end, 
		reference = "CBFS_UI_OptionsPanel_BodyWeightMenu", 
	}
	optionsData[#optionsData + 1] = {
		type = "checkbox", 
		name = L(SI_CBFS_UI_TITLEAUTO_MENU_NAME), 
		tooltip = L(SI_CBFS_UI_TITLEAUTO_MENU_TIPS), 
		getFunc = function() return self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleAuto end,
		setFunc = function(newValue)
			self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleAuto = newValue
			if newValue then		-- set to ON
				CBFS_UI_OptionsPanel_TitleFontMenu:UpdateValue(false, self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].bodyStyle)
				CBFS_UI_OptionsPanel_TitleSizeMenu:UpdateValue(false, self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].bodySize + 10)
				CBFS_UI_OptionsPanel_TitleWeightMenu:UpdateValue(false, self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].bodyWeight)
				self:RefreshFontPreviewWindow()
			end
		end, 
		default = function()
			return false
		end, 
		reference = "CBFS_UI_OptionsPanel_TitleAutoMenu", 
	}
	optionsData[#optionsData + 1] = {
		type = "dropdown", 
		name = L(SI_CBFS_UI_TITLEFONT_MENU_NAME), 
		tooltip = L(SI_CBFS_UI_TITLEFONT_MENU_TIPS), 
		choices = fontChoices, 
		choicesValues = fontChoicesValues, 
		choicesTooltips = fontChoicesTooltips, 
		getFunc = function() return self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleStyle end, 
		setFunc = function(styleStr)
			self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleStyle = styleStr
			self:RefreshFontPreviewWindow()
			self:RefreshErrorMessageDisplay()
		end, 
--		sort = "name-up", --or "name-down", "numeric-up", "numeric-down", "value-up", "value-down", "numericvalue-up", "numericvalue-down" 
		scrollable = 15, 
		disabled = function() return self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleAuto end, 
		default = function()
			local titleFont = GetBookMediumTitleFont(self.uiBMID, self.uiIsGamepad)
			return self.fontManager:GetDefaultFontStyle(titleFont)
		end, 
		reference = "CBFS_UI_OptionsPanel_TitleFontMenu", 
	}
	optionsData[#optionsData + 1] = {
		type = "slider", 
		name = L(SI_CBFS_UI_TITLESIZE_MENU_NAME), 
		tooltip = L(SI_CBFS_UI_TITLESIZE_MENU_TIPS), 
		min = 8,
		max = 50,
		step = 1, 
		getFunc = function() return self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleSize end, 
		setFunc = function(sizeNum)
			self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleSize = sizeNum
			self:RefreshFontPreviewWindow()
		end, 
		disabled = function() return self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleAuto end, 
		clampInput = false, 
		default = function()
			local titleFont = GetBookMediumTitleFont(self.uiBMID, self.uiIsGamepad)
			return self.fontManager:GetDefaultFontSize(titleFont)
		end, 
		reference = "CBFS_UI_OptionsPanel_TitleSizeMenu", 
	}
	optionsData[#optionsData + 1] = {
		type = "dropdown", 
		name = L(SI_CBFS_UI_TITLEWEIGHT_MENU_NAME), 
		tooltip = L(SI_CBFS_UI_TITLEWEIGHT_MENU_TIPS), 
		choices = fontWeightChoices, 
		choicesValues = fontWeightChoicesValues, 
		choicesTooltips = fontWeightChoicesTooltips, 
		getFunc = function() return self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleWeight end, 
		setFunc = function(weightStr)
			self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleWeight = weightStr
			self:RefreshFontPreviewWindow()
		end, 
--		sort = "name-up", --or "name-down", "numeric-up", "numeric-down", "value-up", "value-down", "numericvalue-up", "numericvalue-down" 
		disabled = function() return self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleAuto end, 
		default = function()
			local titleFont = GetBookMediumTitleFont(self.uiBMID, self.uiIsGamepad)
			local defaultWeight = self.fontManager:GetDefaultFontWeight(titleFont)
			if not defaultWeight or defaultWeight == "" then
				defaultWeight = "normal"
			end
			return defaultWeight
		end, 
		reference = "CBFS_UI_OptionsPanel_TitleWeightMenu", 
	}
	optionsData[#optionsData + 1] = {
		type = "button", 
		name = L(SI_CBFS_UI_LOAD_DEFAULT_FONT_NAME), 
		tooltip = L(SI_CBFS_UI_LOAD_DEFAULT_FONT_TIPS), 
		func = function() self:OnPanelDefaultFontButtonClicked() end, 
		width = "half", 
	}
	optionsData[#optionsData + 1] = {
		type = "button", 
		name = L(SI_CBFS_UI_SHOW_READER_WND_NAME), 
		tooltip = L(SI_CBFS_UI_SHOW_READER_WND_TIPS), 
		func = function() self:OnPanelPreviewButtonClicked() end, 
		width = "half", 
		disabled = function()
			if self.uiBMID == BMID_ELVEN_SCROLL then
				return GetAPIVersion() < 101042
			else
				return self.uiBMID == BMID_ANTIQUITY_CODEX and self.antiquityIdForPreview == 0
			end
		end, 
	}
	optionsData[#optionsData + 1] = {
		type = "description", 
		title = "", 
		text = "There is no error", 
		reference = "CBFS_UI_OptionsPanel_ErrorMessageDisplay", 
	}
	LAM:RegisterOptionControls(self.panelId, optionsData)
--	CBFS.LDL:Debug("Initalize LAM panel")
end

function CBFS_LAMSettingPanel:OnLAMPanelControlsCreated(panel)
	CBFS_UI_OptionsPanel_GameModeDisplay.desc:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
	if self.fontPreviewWindow then
		self.fontPreviewWindow:SetAnchor(LEFT, self.panel, RIGHT, 20, 0)	-- forcibly reset
		self.fontPreviewWindow:SetDimensions(400, 600)	-- forcibly reset
	end
	self:RefreshFontPreviewWindow()
	self:RefreshErrorMessageDisplay()

	self:InitializePreviewMode()
end

function CBFS_LAMSettingPanel:OnLAMPanelOpened(panel)
--	CBFS.LDL:Debug("LAM-Panel Opened")
	self.uiPreviewMode = false	-- force end of the CBFS preview mode.
	if self.fontPreviewWindow then
		self.fontPreviewWindow:Show()
	end
end

function CBFS_LAMSettingPanel:OnLAMPanelClosed(panel)
--	CBFS.LDL:Debug("LAM-Panel Closed")
	if self.fontPreviewWindow then
		self.fontPreviewWindow:Hide()
	end
end

-- ----------------------------------------------------------------------------------------
function CBFS_LAMSettingPanel:RegisterFontPreviewWindow(fontPreviewWindowClassObject)
	self.fontPreviewWindow = fontPreviewWindowClassObject
end

function CBFS_LAMSettingPanel:RefreshFontPreviewWindow()
	if self.fontPreviewWindow then
		local t = self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID]
		local bodyFont = self.fontManager:MakeFontDescriptorByLMP(t.bodyStyle, t.bodySize, t.bodyWeight)
		local titleFont = self.fontManager:MakeFontDescriptorByLMP(t.titleStyle, t.titleSize, t.titleWeight)
		self.fontPreviewWindow:SetTitleFont(titleFont)
		self.fontPreviewWindow:SetBodyFont(bodyFont)
		self.fontPreviewWindow:SetMediumBgTexture(GetBookMediumTexture(self.uiBMID))
	end
end

function CBFS_LAMSettingPanel:RefreshErrorMessageDisplay()
	if self:IsPanelInitialized() then
		local errMsg = ""
		-- font style validity check
		if not LMP:IsValid("font", self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].bodyStyle) then
			errMsg = L(SI_CBFS_UI_E1001_ERRMSG_TEXT)
		end
		if not LMP:IsValid("font", self.db.config[self.uiLang][CBFS_NORMAL_MODE][self.uiBMID].titleStyle) then
			errMsg = L(SI_CBFS_UI_E1001_ERRMSG_TEXT)
		end
		CBFS_UI_OptionsPanel_ErrorMessageDisplay.data.text = errMsg
		CBFS_UI_OptionsPanel_ErrorMessageDisplay:UpdateValue()
	end
end

function CBFS_LAMSettingPanel:RefreshGameModeDisplay()
	if self:IsPanelInitialized() then
		CBFS_UI_OptionsPanel_GameModeDisplay.data.text = (self.uiIsGamepad and L(SI_CBFS_UI_GAMEMODE_GAMEPAD_NAME) or L(SI_CBFS_UI_GAMEMODE_KEYBOARD_NAME)) .. " - " .. zo_strupper(self.uiLang) 
		CBFS_UI_OptionsPanel_GameModeDisplay:UpdateValue()
	end
end

function CBFS_LAMSettingPanel:RefreshCurrentBookMediumTab(forceDefault)
-- Setting the argument forceDefault to true means resetting the current book medium tab to its default value.
	if self:IsPanelInitialized() then
		CBFS_UI_OptionsPanel_TabHeader:UpdateValue(forceDefault)
		CBFS_UI_OptionsPanel_BodyFontMenu:UpdateValue(forceDefault)
		CBFS_UI_OptionsPanel_BodySizeMenu:UpdateValue(forceDefault)
		CBFS_UI_OptionsPanel_BodyWeightMenu:UpdateValue(forceDefault)
		CBFS_UI_OptionsPanel_TitleAutoMenu:UpdateValue(forceDefault)
		CBFS_UI_OptionsPanel_TitleFontMenu:UpdateValue(forceDefault)
		CBFS_UI_OptionsPanel_TitleSizeMenu:UpdateValue(forceDefault)
		CBFS_UI_OptionsPanel_TitleWeightMenu:UpdateValue(forceDefault)
		self:RefreshFontPreviewWindow()
		self:RefreshErrorMessageDisplay()
	end
end

function CBFS_LAMSettingPanel:SetSelectedBookMedium(newBMID)
	self.uiBMID = newBMID
	self:RefreshCurrentBookMediumTab(false)
end

function CBFS_LAMSettingPanel:OnPanelDefaultButtonClicked()
	-- By clicking the Default button in the Settings panel, we reset all book medium font settings in the current language mode to the default font.
	for bmid in BookMediumIdIterator() do
		local bodyFont = GetBookMediumBodyFont(bmid, self.uiIsGamepad)
		local titleFont = GetBookMediumTitleFont(bmid, self.uiIsGamepad)
		local t = {
			bodyStyle = self.fontManager:GetDefaultFontStyle(bodyFont), 
			bodySize = self.fontManager:GetDefaultFontSize(bodyFont), 
			bodyWeight = self.fontManager:GetDefaultFontWeight(bodyFont), 
			titleStyle = self.fontManager:GetDefaultFontStyle(titleFont),
			titleSize = self.fontManager:GetDefaultFontSize(titleFont), 
			titleWeight = self.fontManager:GetDefaultFontWeight(titleFont), 
			titleAuto = false, 
		}
		if t.bodyWeight == "" then
			t.bodyWeight = "normal"
		end
		if t.titleWeight == "" then
			t.titleWeight = "normal"
		end
		self.db.config[self.uiLang][CBFS_NORMAL_MODE][bmid] = t
	end
	self:SetSelectedBookMedium(BMID_YELLOWED_PAPER)
end

function CBFS_LAMSettingPanel:OnPanelDefaultFontButtonClicked()
	-- By clicking the Default Font button in the Settings panel, we reset only current book medium settings in the current language mode to the default.
	local RESET_TO_DEFAULT = true
	self:RefreshCurrentBookMediumTab(RESET_TO_DEFAULT)
end

function CBFS_LAMSettingPanel:InitializePreviewMode()
	-- obtain the id number of antiquity unlocked by the player.
	self.antiquityIdForPreview = 0
	for antiquityId = 1000, 1, -1 do
		if GetNumAntiquityLoreEntriesAcquired(antiquityId) > 0 then
			self.antiquityIdForPreview = antiquityId
			break
		end
	end
--	CBFS.LDL:Debug("self.antiquityIdForPreview = ", self.antiquityIdForPreview)

	local previewModeScenes = {
		"loreReaderDefault", 
		"gamepad_loreReaderDefault", 
		"antiquityLoreKeyboard", 
		"gamepad_antiquity_lore", 
	}
	local function OnPreviewModeSceneStateChange(oldState, newState)
		if newState == SCENE_HIDDEN then
--			CBFS.LDL:Debug("SCENE[%s] state change : %s to %s", tostring(SCENE_MANAGER:GetCurrentScene():GetName()), tostring(oldState), tostring(newState))
			if self.uiPreviewMode then
				self.uiPreviewMode = false
				self:OpenSettingPanel()
			end
		end
	end
	for _, sceneName in pairs(previewModeScenes) do
		if SCENE_MANAGER:GetScene(sceneName) then
			SCENE_MANAGER:GetScene(sceneName):RegisterCallback("StateChange", OnPreviewModeSceneStateChange)
		end
	end
end

function CBFS_LAMSettingPanel:OnPanelPreviewButtonClicked()
	if self.uiBMID == BMID_ANTIQUITY_CODEX then
		if self.antiquityIdForPreview ~= 0 then
			if ANTIQUITY_DATA_MANAGER.OnAntiquityShowCodexEntry then
				self.uiPreviewMode = true	-- When the antiquity lore reader scene would be hidden in CBFS preview mode, we are forced to open the CBFS settings panel.
				ANTIQUITY_DATA_MANAGER:OnAntiquityShowCodexEntry(self.antiquityIdForPreview)
				-- When you execute ANTIQUITY_DATA_MANAGER:OnAntiquityShowCodexEntry from the game menu scenes, you will be taken to either the "antiquityLoreKeyboard" or "gamepad_antiquity_lore" scene.
			end
		end
	else
		self.uiPreviewMode = true	-- When the default lore reader scene would be hidden in CBFS preview mode, we are forced to open the CBFS settings panel.
		LORE_READER:Show(L(SI_CBFS_UI_PREVIEW_BOOK_TITLE), L(SI_CBFS_UI_PREVIEW_BOOK_BODY), self.uiBMID, true)
		-- When you execute LORE_READER:Show from the game menu scenes, you will be taken to either the "loreReaderDefault" or "gamepad_loreReaderDefault" scene, not to the lore reader custom scenes.
	end
end

CBookFontStylist:RegisterClassObject("CBFS_LAMSettingPanel", CBFS_LAMSettingPanel)
