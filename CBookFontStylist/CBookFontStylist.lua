--
-- Calamath's BookFont Stylist [CBFS]
--
-- Copyright (c) 2020 Calamath
--
-- This software is released under the Artistic License 2.0
-- https://opensource.org/licenses/Artistic-2.0
--
-- Note :
-- This addon works that uses the library LibMediaProvider-1.0 by Seerah, released under the LGPL-2.1 license.
-- This addon works that uses the library LibAddonMenu-2.0 by sirinsidiator, Seerah, released under the Artistic License 2.0
-- You will need to obtain the above libraries separately.
--

-- ---------------------------------------------------------------------------------------
-- Checking dependencies
-- ---------------------------------------------------------------------------------------
local _EXTERNAL_DEPENDENCIES = {
	"LibMediaProvider", 
	"LibAddonMenu2", 
}
for _, objectName in pairs(_EXTERNAL_DEPENDENCIES) do
	assert(_G[objectName], "[CBookFontStylist] Fatal Error: " .. objectName .. " not found.")
end


-- ---------------------------------------------------------------------------------------
-- CT_SimpleAddonFramework: Simple Add-on Framework Template Class              rel.1.0.11
-- ---------------------------------------------------------------------------------------
local CT_SimpleAddonFramework = ZO_Object:Subclass()
function CT_SimpleAddonFramework:New(...)
	local newObject = setmetatable({}, self)
	newObject:Initialize(...)
	newObject:OnInitialized(...)
	return newObject
end
function CT_SimpleAddonFramework:Initialize(name, attributes)
	if type(name) ~= "string" or name == "" then return end
	self._name = name
	self._isInitialized = false
	if type(attributes) == "table" then
		for k, v in pairs(attributes) do
			if self[k] == nil then
				self[k] = v
			end
		end
	end
	self.authority = self.authority or {}
	self._class = {}
	self._shared = nil
	self._external = {
		name = self.name or self._name, 
		version = self.version, 
		author = self.author, 
		RegisterClassObject = function(_, ...) self:RegisterClassObject(...) end, 
	}
	assert(not _G[name], name .. " is already loaded.")
	_G[name] = self._external
	self:ConfigDebug()
	EVENT_MANAGER:RegisterForEvent(self._name, EVENT_ADD_ON_LOADED, function(event, addonName)
		if addonName ~= self._name then return end
		EVENT_MANAGER:UnregisterForEvent(self._name, EVENT_ADD_ON_LOADED)
		self:OnAddOnLoaded(event, addonName)
		self._isInitialized = true
	end)
end
function CT_SimpleAddonFramework:ConfigDebug(arg)
	local debugMode = false
	local key = HashString(GetDisplayName())
	if LibDebugLogger then
		for _, v in pairs(arg or self.authority or {}) do
			if key == v then debugMode = true end
		end
	end
	if debugMode then
		self._logger = self._logger or LibDebugLogger(self._name)
		self.LDL = self._logger
	else
		self.LDL = {
			Verbose = function() end, 
			Debug = function() end, 
			Info = function() end, 
			Warn = function() end, 
			Error = function() end, 
		}
	end
	self._isDebugMode = debugMode
end
function CT_SimpleAddonFramework:RegisterClassObject(className, classObject)
	if className and classObject and not self._class[className] then
		self._class[className] = classObject
		return true
	else
		return false
	end
end
function CT_SimpleAddonFramework:HasAvailableClass(className)
	if className then
		return self._class[className] ~= nil
	end
end
function CT_SimpleAddonFramework:CreateClassObject(className, ...)
	if className and self._class[className] then
		return self._class[className]:New(...)
	end
end
function CT_SimpleAddonFramework:OnInitialized(name, attributes)
--  Available when overridden in an inherited class
end
function CT_SimpleAddonFramework:OnAddOnLoaded(event, addonName)
--  Should be Overridden
end

-- ---------------------------------------------------------------------------------------
-- CT_AddonFramework: Add-on Framework Template Class for multiple modules      rel.1.0.11
-- ---------------------------------------------------------------------------------------
local CT_AddonFramework = CT_SimpleAddonFramework:Subclass()
function CT_AddonFramework:Initialize(name, attributes)
	CT_SimpleAddonFramework.Initialize(self, name, attributes)
	if not self._external then return end
	self._shared = {
		name = self._name, 
		version = self.version, 
		author = self.author, 
		LDL = self.LDL, 
		HasAvailableClass = function(_, ...) return self:HasAvailableClass(...) end, 
		CreateClassObject = function(_, ...) return self:CreateClassObject(...) end, 
		RegisterGlobalObject = function(_, ...) return self:RegisterGlobalObject(...) end, 
		RegisterSharedObject = function(_, ...) return self:RegisterSharedObject(...) end, 
		RegisterCallback = function(_, ...) return self:RegisterCallback(...) end, 
		UnregisterCallback = function(_, ...) return self:UnregisterCallback(...) end, 
		FireCallbacks = function(_, ...) return self:FireCallbacks(...) end, 
	}
	self._external.SetSharedEnvironment = function()
		-- This method is intended to be called in the main chunk and should not be called inside functions.
		self:EnableCustomEnvironment(self._env, 3)	-- [Main Chunk]: self._external:SetSharedEnvironment() -> self:EnableCustomEnvironment(t, 3) -> setfenv(3, t)
		return self._shared
	end
	self._external.FireCallbacks = function(_, ...) return self:FireCallbacks(...) end 
	if self._enableCallback then
		self._callbackObject = ZO_CallbackObject:New()
		self.RegisterCallback = function(self, ...)
			return self._callbackObject:RegisterCallback(...)
		end
		self.UnregisterCallback = function(self, ...)
			return self._callbackObject:UnregisterCallback(...)
		end
		self.FireCallbacks = function(self, ...)
			return self._callbackObject:FireCallbacks(...)
		end
	end
	if self._enableEnvironment then
		self:EnableCustomEnvironment(self._env, 4)	-- [Main Chunk]: self:New() -> self:Initialize() -> EnableCustomEnvironment(t, 4) -> setfenv(4, t)
	end
end
function CT_AddonFramework:ConfigDebug(arg)
	CT_SimpleAddonFramework.ConfigDebug(self, arg)
	if self._shared then
		self._shared.LDL = self.LDL
	end
end
function CT_AddonFramework:CreateCustomEnvironment(t, parent)	-- helper function
-- This method is intended to be called in the main chunk and should not be called inside functions.
	return setmetatable(type(t) == "table" and t or {}, { __index = type(parent) == "table" and parent or getfenv and type(getfenv) == "function" and getfenv(2) or _ENV or _G, })
end
function CT_AddonFramework:EnableCustomEnvironment(t, stackLevel)	-- helper function
	local stackLevel = type(stackLevel) == "number" and stackLevel > 1 and stackLevel or type(ZO_GetCallstackFunctionNames) == "function" and #(ZO_GetCallstackFunctionNames()) + 1 or 2
	local env = type(t) == "table" and t or type(self._env) == "table" and self._env
	if env then
		if setfenv and type(setfenv) == "function" then
			setfenv(stackLevel, env)
		else
			_ENV = env
		end
	end
end
function CT_AddonFramework:RegisterGlobalObject(objectName, globalObject)
	if objectName and globalObject and _G[objectName] == nil then
		_G[objectName] = globalObject
		return true
	else
		return false
	end
end
function CT_AddonFramework:RegisterSharedObject(objectName, sharedObject)
	if objectName and sharedObject and self._env and not self._env[objectName] then
		self._env[objectName] = sharedObject
		return true
	else
		return false
	end
end
function CT_AddonFramework:RegisterCallback(...)
-- stub: Method name reserved
end
function CT_AddonFramework:UnregisterCallback(...)
-- stub: Method name reserved
end
function CT_AddonFramework:FireCallbacks(...)
-- stub: Method name reserved
end


-- ---------------------------------------------------------------------------------------
-- CBookFontStylist
-- ---------------------------------------------------------------------------------------
local _SHARED_DEFINITIONS = {
	BMID_NONE				= 0, 
	BMID_YELLOWED_PAPER 	= 1, 
	BMID_ANIMAL_SKIN		= 2, 
	BMID_RUBBING_PAPER		= 3, 
	BMID_LETTER 			= 4, 
	BMID_NOTE				= 5, 
	BMID_SCROLL 			= 6, 
	BMID_STONE_TABLET		= 7, 
	BMID_METAL				= 8, 
	BMID_METAL_TABLET		= 9, 
	BMID_ELVEN_SCROLL		= 10, 
	BMID_ANTIQUITY_CODEX	= 99, 
	CBFS_NORMAL_MODE		= 1, 
	BOOK_MEDIUM_ELVEN_SCROLL = BOOK_MEDIUM_ELVEN_SCROLL or 10, -- for live server
}
local _ENV = CT_AddonFramework:CreateCustomEnvironment(_SHARED_DEFINITIONS)
local CBFS = CT_AddonFramework:New("CBookFontStylist", {
	name = "CBookFontStylist", 
	version = "4.1.0", 
	author = "Calamath", 
	savedVars = "CBookFontStylistDB", 
	savedVarsVersion = 1, 
	authority = {2973583419,210970542},  
	maxPreset = 1, 
	_env = _ENV, 
	_enableEnvironment = true, 
})
-- ---------------------------------------------------------------------------------------
local CBFS_DB_DEFAULT = {
	config = {
	}, 
	window = {
		x = 300, 
		y = 1275, 
		width = 400, 
		height = 600, 
	}
}

function CBFS:OnAddOnLoaded()
	self.lang = GetCVar("Language.2")
	self.isGamepad = IsInGamepadPreferredMode()
	self.isFirstTimePlayerActivated = true
	self.fontManager = GetFontManager()

	-- CBookFontStylist Config
	self.db = ZO_SavedVars:NewAccountWide(self.savedVars, 1, nil, CBFS_DB_DEFAULT)
	self:ValidateConfigData()	-- NOTE: we create savedata field on first boot in each language mode.

	-- LAM setting panel
	self.fontPreviewWindow = self:CreateClassObject("CBFS_FontPreviewWindow", CBFS_UI_PreviewWindow, self.db.window)
	self.settingPanel = self:CreateClassObject("CBFS_LAMSettingPanel", "CBookFontStylist_Options", self.db, self.db, CBFS_DB_DEFAULT)
	self.settingPanel:RegisterFontPreviewWindow(self.fontPreviewWindow)

--[[
	ZO_PreHookHandler(ZO_LoreReader, "OnShow", function()
		self.LDL:Debug("(TLW)ZO_LoreReader:OnShow :")
	end)
	ZO_PreHookHandler(ZO_LoreReader, "OnHide", function()
		self.LDL:Debug("(TLW)ZO_LoreReader:OnHide :")
	end)
]]

	-- for lore books
	-- NOTE: We hook LORE_READER to be more inclusive rather than adding callbacks to individual lore reader scenes since future updates may add a new custom lore reader scene.
	ZO_PreHook(LORE_READER, "OnHide", function()
--		self.LDL:Debug("LORE_READER:OnHide :")
		self:RevertBookFontToDefault()
	end)
	ZO_PreHook(LORE_READER, "SetupBook", function(LORE_READER_self, title, body, medium, showTitle, isGamepad, ...)
--		self.LDL:Debug("LORE_READER:SetupBook :")
		local bmid = GetBMID(medium)
--[[
		self.LDL:Debug("title =", tostring(title))
		self.LDL:Debug("body =", tostring(body))
		self.LDL:Debug("medium =", tostring(medium))
		self.LDL:Debug("showTitle =", tostring(showTitle))
		self.LDL:Debug("isGamepad =", tostring(isGamepad))
]]
		self:CustomizeBookFont(bmid)
	end)

	-- for antiquity codex
	-- NOTE: We could not access the lore dialog displayed when you discovered an antiquity codex, because its scene belongs in the internal Antiquity Digging mini-game.
	--       Here you can customize the font when reading the codex from the journal scene.
	if SCENE_MANAGER:GetScene("antiquityLoreKeyboard") then
		SCENE_MANAGER:GetScene("antiquityLoreKeyboard"):RegisterCallback("StateChange", function(oldState, newState)
			if (newState == SCENE_HIDDEN) then
--				self.LDL:Debug("SCENE[antiquityLoreKeyboard] state change : %s to %s", tostring(oldState), tostring(newState))
				self:RevertBookFontToDefault()
			end
		end)
		ZO_PreHook(ANTIQUITY_LORE_KEYBOARD, "Refresh", function()
--			self.LDL:Debug("ANTIQUITY_LORE_KEYBOARD:Refresh :")
			self:CustomizeBookFont(BMID_ANTIQUITY_CODEX)
		end)
	end
	if SCENE_MANAGER:GetScene("gamepad_antiquity_lore") then
		SCENE_MANAGER:GetScene("gamepad_antiquity_lore"):RegisterCallback("StateChange", function(oldState, newState)
			if (newState == SCENE_HIDDEN) then
--				self.LDL:Debug("SCENE[gamepad_antiquity_lore] state change : %s to %s", tostring(oldState), tostring(newState))
				self:RevertBookFontToDefault()
			end
		end)
		ZO_PreHook(ANTIQUITY_LORE_GAMEPAD, "RefreshLoreList", function()
--			self.LDL:Debug("ANTIQUITY_LORE_GAMEPAD:RefreshLoreList :")
			self:CustomizeBookFont(BMID_ANTIQUITY_CODEX)
		end)
	end

	-- register in-game events
	EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED, function(_, gamepadPreferred)
		self.isGamepad = gamepadPreferred
	end)
	EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED, function(event, initial)
		self:OnPlayerActivated(event, initial)
	end)
--	self.LDL:Debug("Initialized")
end

function CBFS:OnPlayerActivated(event, initial)
	self.LDL:Debug("EVENT_PLAYER_ACTIVATED : initial =", initial, ", isFirstTime =", self.isFirstTimePlayerActivated)
	if self.isFirstTimePlayerActivated then
		self.isFirstTimePlayerActivated = false

		-- UI initialization
		self.settingPanel:InitializeSettingPanel()
	end
end

function CBFS:ValidateConfigData()
	if not self.db.config[self.lang] then
		self.db.config[self.lang] = {}
	end
	if not self.db.config[self.lang][CBFS_NORMAL_MODE] then
		self.db.config[self.lang][CBFS_NORMAL_MODE] = {}
	end
	local normalModeConfig = self.db.config[self.lang][CBFS_NORMAL_MODE]
	for bmid in BookMediumIdIterator() do
		local bodyFont = GetBookMediumBodyFont(bmid, self.isGamepad)
		local titleFont = GetBookMediumTitleFont(bmid, self.isGamepad)
		if not normalModeConfig[bmid] then
			normalModeConfig[bmid] = {}
		end
		if normalModeConfig[bmid].bodyStyle == nil			then normalModeConfig[bmid].bodyStyle		= self.fontManager:GetDefaultFontStyle(bodyFont)		end
		if normalModeConfig[bmid].bodySize == nil			then normalModeConfig[bmid].bodySize		= self.fontManager:GetDefaultFontSize(bodyFont)			end
		if normalModeConfig[bmid].bodyWeight == nil			then normalModeConfig[bmid].bodyWeight		= self.fontManager:GetDefaultFontWeight(bodyFont)		end
		if normalModeConfig[bmid].titleStyle == nil			then normalModeConfig[bmid].titleStyle		= self.fontManager:GetDefaultFontStyle(titleFont)		end
		if normalModeConfig[bmid].titleSize == nil			then normalModeConfig[bmid].titleSize		= self.fontManager:GetDefaultFontSize(titleFont)		end
		if normalModeConfig[bmid].titleWeight == nil		then normalModeConfig[bmid].titleWeight		= self.fontManager:GetDefaultFontWeight(titleFont)		end
		if normalModeConfig[bmid].titleAuto == nil			then normalModeConfig[bmid].titleAuto		= false													end
		if normalModeConfig[bmid].bodyWeight == "" then
 			normalModeConfig[bmid].bodyWeight = "normal"
		end
		if normalModeConfig[bmid].titleWeight == "" then
			normalModeConfig[bmid].titleWeight = "normal"
		end
	end
end

function CBFS:CustomizeBookFont(bmid)
	local customFontData = self.db.config[self.lang][CBFS_NORMAL_MODE][bmid]
	if customFontData then
		local bodyFont = GetBookMediumBodyFont(bmid, self.isGamepad)
		local customBodyFontDescriptor = self.fontManager:MakeFontDescriptorByLMP(customFontData.bodyStyle, customFontData.bodySize, customFontData.bodyWeight)
		if customBodyFontDescriptor then
			self.fontManager:CustomizeFont(bodyFont, customBodyFontDescriptor)
		end

		local titleFont = GetBookMediumTitleFont(bmid, self.isGamepad)
		local customTitleFontDescriptor = self.fontManager:MakeFontDescriptorByLMP(customFontData.titleStyle, customFontData.titleSize, customFontData.titleWeight)
		if customTitleFontDescriptor then
			self.fontManager:CustomizeFont(titleFont, customTitleFontDescriptor)
		end
	end
end

function CBFS:RevertBookFontToDefault()
	self.fontManager:RevertAllFontsToDefault()
end

-- ------------------------------------------------

SLASH_COMMANDS["/cbfs.debug"] = function(arg) if arg ~= "" then CBFS:ConfigDebug({tonumber(arg)}) end end
--[[
SLASH_COMMANDS["/cbfs.test"] = function(arg)
	CBFS.LDL:Debug("BOOK_MEDIUM_ITERATION_BEGIN = ", BOOK_MEDIUM_ITERATION_BEGIN)
	CBFS.LDL:Debug("BOOK_MEDIUM_ITERATION_END = ", BOOK_MEDIUM_ITERATION_END)
end
]]
