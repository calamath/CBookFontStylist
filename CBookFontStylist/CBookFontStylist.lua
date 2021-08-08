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


-- CBookFontStylist global definitions
CBookFontStylist = CBookFontStylist or {}

CBookFontStylist.name = "CBookFontStylist"
CBookFontStylist.version = "2.03"
CBookFontStylist.author = "Calamath"
CBookFontStylist.savedVars = "CBookFontStylistDB"
CBookFontStylist.savedVarsVersion = 1
CBookFontStylist.authority = {2973583419,210970542} 
CBookFontStylist.maxPreset = 1

CBookFontStylist.bookMediumID = {
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
	BMID_ANTIQUITY_CODEX	= 99, 
}

-- Library
local LMP = LibMediaProvider
if not LMP then d("[CBFS] Error : 'LibMediaProvider' not found.") return end
local LCFM = LibCFontManager
if not LCFM then d("[CBFS] Error : 'LibCFontManager' not found.") return end
local LAM = LibAddonMenu2
if not LAM then d("[CBFS] Error : 'LibAddonMenu-2.0' not found.") return end

-- ------------------------------------------------


-- CBookFontStylist local definitions
local CBFS = CBookFontStylist
local BMID_NONE 			= CBFS.bookMediumID["BMID_NONE"]
local BMID_YELLOWED_PAPER	= CBFS.bookMediumID["BMID_YELLOWED_PAPER"]
local BMID_ANIMAL_SKIN		= CBFS.bookMediumID["BMID_ANIMAL_SKIN"]
local BMID_RUBBING_PAPER	= CBFS.bookMediumID["BMID_RUBBING_PAPER"]
local BMID_LETTER			= CBFS.bookMediumID["BMID_LETTER"]
local BMID_NOTE 			= CBFS.bookMediumID["BMID_NOTE"]
local BMID_SCROLL			= CBFS.bookMediumID["BMID_SCROLL"]
local BMID_STONE_TABLET 	= CBFS.bookMediumID["BMID_STONE_TABLET"]
local BMID_METAL			= CBFS.bookMediumID["BMID_METAL"]
local BMID_METAL_TABLET 	= CBFS.bookMediumID["BMID_METAL_TABLET"]
local BMID_ANTIQUITY_CODEX 	= CBFS.bookMediumID["BMID_ANTIQUITY_CODEX"]

local zosBookMediumToBMID = {
	[BOOK_MEDIUM_NONE]			 = BMID_NONE			, 
	[BOOK_MEDIUM_YELLOWED_PAPER] = BMID_YELLOWED_PAPER	, 
	[BOOK_MEDIUM_ANIMAL_SKIN]	 = BMID_ANIMAL_SKIN 	, 
	[BOOK_MEDIUM_RUBBING_PAPER]  = BMID_RUBBING_PAPER	, 
	[BOOK_MEDIUM_LETTER]		 = BMID_LETTER			, 
	[BOOK_MEDIUM_NOTE]			 = BMID_NOTE			, 
	[BOOK_MEDIUM_SCROLL]		 = BMID_SCROLL			, 
	[BOOK_MEDIUM_STONE_TABLET]	 = BMID_STONE_TABLET	, 
	[BOOK_MEDIUM_METAL] 		 = BMID_METAL			, 
	[BOOK_MEDIUM_METAL_TABLET]	 = BMID_METAL_TABLET	, 
}
setmetatable(zosBookMediumToBMID, { __index = function(self, k) return self[BOOK_MEDIUM_YELLOWED_PAPER] end, })

local cbfsCtrlTbl = {
	[BMID_YELLOWED_PAPER] = {
		keyboard = {
			body	= "ZoFontBookPaper", 
			title	= "ZoFontBookPaperTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookPaper", 
			title	= "ZoFontGamepadBookPaperTitle", 
		}, 
		isChanged = false, 
	}, 
	[BMID_ANIMAL_SKIN] = {
		keyboard = {
			body	= "ZoFontBookSkin",
			title	= "ZoFontBookSkinTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookSkin", 
			title	= "ZoFontGamepadBookSkinTitle", 
		}, 
		isChanged = false, 
	}, 
	[BMID_RUBBING_PAPER] = {
		keyboard = {
			body	= "ZoFontBookRubbing", 
			title	= "ZoFontBookRubbingTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookRubbing", 
			title	= "ZoFontGamepadBookRubbingTitle", 
		}, 
		isChanged = false, 
	}, 
	[BMID_LETTER] = {
		keyboard = {
			body	= "ZoFontBookLetter", 
			title	= "ZoFontBookLetterTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookLetter", 
			title	= "ZoFontGamepadBookLetterTitle", 
		}, 
		isChanged = false, 
	}, 
	[BMID_NOTE] = {
		keyboard = {
			body	= "ZoFontBookNote", 
			title	= "ZoFontBookNoteTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookNote", 
			title	= "ZoFontGamepadBookNoteTitle", 
		}, 
		isChanged = false, 
	}, 
	[BMID_SCROLL] = {
		keyboard = {
			body	= "ZoFontBookScroll", 
			title	= "ZoFontBookScrollTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookScroll", 
			title	= "ZoFontGamepadBookScrollTitle", 
		}, 
		isChanged = false, 
	}, 
	[BMID_STONE_TABLET] = {
		keyboard = {
			body	= "ZoFontBookTablet", 
			title	= "ZoFontBookTabletTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookTablet", 
			title	= "ZoFontGamepadBookTabletTitle", 
		}, 
		isChanged = false, 
	}, 
	[BMID_METAL] = {
		keyboard = {
			body	= "ZoFontBookMetal", 
			title	= "ZoFontBookMetalTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookMetal", 
			title	= "ZoFontGamepadBookMetalTitle", 
		}, 
		isChanged = false, 
	}, 
	[BMID_METAL_TABLET] = {
		keyboard = {
			body	= "ZoFontBookMetal", 
			title	= "ZoFontBookMetalTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookMetal", 
			title	= "ZoFontGamepadBookMetalTitle", 
		}, 
		isChanged = false, 
	}, 
	[BMID_ANTIQUITY_CODEX] = {
		keyboard = {
			body	= "ZoFontBookScroll", 
			title	= "ZoFontBookScrollTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookScroll", 
			title	= "ZoFontGamepadBookScrollTitle", 
		}, 
		isChanged = false, 
	}, 
}
setmetatable(cbfsCtrlTbl, { __index = function(self, k) d("[CBFS] Error : illegal BMID access") return self[BMID_YELLOWED_PAPER] end, })


-- CBookFontStylist savedata (default)
local cbfs_db_default = {
	config = {}, 
}

-- ------------------------------------------------

local function cbfsGetBodyFontObjName(bmid, isGamepad)
	if isGamepad then
		return cbfsCtrlTbl[bmid].gamepad.body
	else
		return cbfsCtrlTbl[bmid].keyboard.body
	end
end
CBFS.GetBodyFontObjName = cbfsGetBodyFontObjName

local function cbfsGetTitleFontObjName(bmid, isGamepad)
	if isGamepad then
		return cbfsCtrlTbl[bmid].gamepad.title
	else
		return cbfsCtrlTbl[bmid].keyboard.title
	end
end
CBFS.GetTitleFontObjName = cbfsGetTitleFontObjName

local function cbfsSetupBookFonts(bmid)
	local lang = CBFS.lang
	local preset = CBFS.preset
	local u = CBFS.db.config[lang][preset][bmid]
	if not u then return end

	local objNameKeyboardBody = cbfsGetBodyFontObjName(bmid, false)
	local objNameKeyboardTitle = cbfsGetTitleFontObjName(bmid, false)
	local objNameGamepadBody = cbfsGetBodyFontObjName(bmid, true)
	local objNameGamepadTitle = cbfsGetTitleFontObjName(bmid, true)

	if not LMP:IsValid("font", u.bodyStyle) then return end
	if not LMP:IsValid("font", u.titleStyle) then return end

	LCFM:SetToNewFontLMP(objNameKeyboardBody, u.bodyStyle, u.bodySize, u.bodyWeight)
	LCFM:SetToNewFontLMP(objNameKeyboardTitle, u.titleStyle, u.titleSize, u.titleWeight)
	LCFM:SetToNewFontLMP(objNameGamepadBody, u.bodyStyle, u.bodySize, u.bodyWeight)
	LCFM:SetToNewFontLMP(objNameGamepadTitle, u.titleStyle, u.titleSize, u.titleWeight)
	cbfsCtrlTbl[bmid].isChanged = true

--	CBFS.LDL:Debug("Changed: ", objNameKeyboardBody, "->", tostring(LCFM:MakeFontDescriptorLMP(u.bodyStyle, u.bodySize, u.bodyWeight)))
--	CBFS.LDL:Debug("Changed: ", objNameKeyboardTitle, "->", tostring(LCFM:MakeFontDescriptorLMP(u.titleStyle, u.titleSize, u.titleWeight)))
--	CBFS.LDL:Debug("Changed: ", objNameGamepadBody, "->", tostring(LCFM:MakeFontDescriptorLMP(u.bodyStyle, u.bodySize, u.bodyWeight)))
--	CBFS.LDL:Debug("Changed: ", objNameGamepadTitle, "->", tostring(LCFM:MakeFontDescriptorLMP(u.titleStyle, u.titleSize, u.titleWeight)))
end

local function cbfsRestoreBookFonts(bmid)
	local objNameKeyboardBody = cbfsGetBodyFontObjName(bmid, false)
	local objNameKeyboardTitle = cbfsGetTitleFontObjName(bmid, false)
	local objNameGamepadBody = cbfsGetBodyFontObjName(bmid, true)
	local objNameGamepadTitle = cbfsGetTitleFontObjName(bmid, true)

	LCFM:RestoreToDefaultFont(objNameKeyboardBody)
	LCFM:RestoreToDefaultFont(objNameKeyboardTitle)
	LCFM:RestoreToDefaultFont(objNameGamepadBody)
	LCFM:RestoreToDefaultFont(objNameGamepadTitle)
	cbfsCtrlTbl[bmid].isChanged = false
--	CBFS.LDL:Debug("Restored:", objNameKeyboardBody)
--	CBFS.LDL:Debug("Restored:", objNameKeyboardTitle)
--	CBFS.LDL:Debug("Restored:", objNameGamepadBody)
--	CBFS.LDL:Debug("Restored:", objNameGamepadTitle)
end

local function cbfsRestoreAllBookFontsAsNeeded()
	for bmid, v in pairs(cbfsCtrlTbl) do
		if v.isChanged then
			cbfsRestoreBookFonts(bmid)
		end
	end
end


-- ------------------------------------------------

-- ------------------------------------
-- for lore books
-- ------------------------------------
--[[
-- override version skeleton
do
	local orgLORE_READER_SetupBook = LORE_READER.SetupBook
	function LORE_READER:SetupBook(title, body, medium, showTitle, isGamepad, ...)

		CBFS.LDL:Debug("LORE_READER:SetupBook (override)")

		return orgLORE_READER_SetupBook(self, title, body, medium, showTitle, isGamepad, ...)
	end
end
]]

local function LORE_READER_OnShow_prehook()
--	CBFS.LDL:Debug("LORE_READER:OnShow (ZOPreHook)")
end

local function LORE_READER_OnHide_prehook()
--	CBFS.LDL:Debug("LORE_READER:OnHide (ZOPreHook)")
	cbfsRestoreAllBookFontsAsNeeded()
	if CBFS.uiPreviewMode then	-- When the LORE_READER is closed in the CBFS preview mode, the scene is forcibly moved to the CBFS addon panel.
		CBFS.uiPreviewMode = false
		LAM:OpenToPanel(CBFS.uiPanel)
	end
end

local function LORE_READER_SetupBook_prehook(LORE_READER_self, title, body, medium, showTitle, isGamepad, ...)
--	CBFS.LDL:Debug("LORE_READER:SetupBook (ZoPreHook)")

	local bmid = zosBookMediumToBMID[medium]

--	if title == nil then CBFS.LDL:Warn("Warning : title is nil ! ") end
--	if title == LORE_READER.self then CBFS.LDL:Warn("Warning : title is LORE_READER.self ! ") end
--	if self == nil then CBFS.LDL:Warn("Warning : self is nil ! ") end
--	if self == LORE_READER then CBFS.LDL:Warn("Warning : self is LORE_READER.self ! ") end
--	CBFS.LDL:Debug("title =", title)
--	CBFS.LDL:Debug("body =", body)
--	CBFS.LDL:Debug("medium =", medium)
--	CBFS.LDL:Debug("showTitle =", showTitle)
--	CBFS.LDL:Debug("isGamepad =", isGamepad)

	cbfsSetupBookFonts(bmid)
end

--[[
local function OnShowBook()
	CBFS.LDL:Debug("EVENT_SHOW_BOOK")
end
EVENT_MANAGER:RegisterForEvent(CBFS.name, EVENT_SHOW_BOOK, OnShowBook)

local function OnHideBook(event)
	CBFS.LDL:Debug("EVENT_HIDE_BOOK")
end
EVENT_MANAGER:RegisterForEvent(CBFS.name, EVENT_HIDE_BOOK, OnHideBook)
]]

-- ------------------------------------
-- for antiquity codex
-- ------------------------------------
local function OnSceneStateChange_antiquityLoreKeyboard(oldState, newState)
	if (newState == SCENE_HIDDEN) then
--		CBFS.LDL:Debug("SCENE[antiquityLoreKeyboard] state change : %s to %s", tostring(oldState), tostring(newState))
		cbfsRestoreAllBookFontsAsNeeded()
		if CBFS.uiPreviewMode then	-- When the antiquityLoreKeyboard is closed in the CBFS preview mode, the scene is forcibly moved to the CBFS addon panel.
			CBFS.uiPreviewMode = false
			LAM:OpenToPanel(CBFS.uiPanel)
		end
	end
end

local function ANTIQUITY_LORE_KEYBOARD_Refresh_prehook()
--	CBFS.LDL:Debug("ANTIQUITY_LORE_KEYBOARD:Refresh (ZoPreHook)")
	cbfsSetupBookFonts(BMID_ANTIQUITY_CODEX)
end

local function OnSceneStateChange_gamepad_antiquity_lore(oldState, newState)
	if (newState == SCENE_HIDDEN) then
--		CBFS.LDL:Debug("SCENE[gamepad_antiquity_lore] state change : %s to %s", tostring(oldState), tostring(newState))
		cbfsRestoreAllBookFontsAsNeeded()
		if CBFS.uiPreviewMode then	-- When the gamepad_antiquity_lore is closed in the CBFS preview mode, the scene is forcibly moved to the CBFS addon panel.
			CBFS.uiPreviewMode = false
			LAM:OpenToPanel(CBFS.uiPanel)
		end
	end
end

local function ANTIQUITY_LORE_GAMEPAD_RefreshLoreList_prehook()
--	CBFS.LDL:Debug("ANTIQUITY_LORE_GAMEPAD:RefreshLoreList (ZoPreHook)")
	cbfsSetupBookFonts(BMID_ANTIQUITY_CODEX)
end


-- ------------------------------------------------

local function cbfsInitializeConfigData(lang, preset, isGamepad)
	CBFS.db.config[lang] = CBFS.db.config[lang] or {}
	preset = preset or 1

	if not CBFS.db.config[lang][preset] then
		CBFS.db.config[lang][preset] ={}
	end

	-- forcibly initialize the configuration data of all book medium
	for k, v in pairs(cbfsCtrlTbl) do
		local tbl = {}
		tbl.bodyStyle, tbl.bodySize, tbl.bodyWeight = LCFM:GetDefaultFontInfoLMP(cbfsGetBodyFontObjName(k, isGamepad))
		tbl.titleStyle, tbl.titleSize, tbl.titleWeight = LCFM:GetDefaultFontInfoLMP(cbfsGetTitleFontObjName(k, isGamepad))
		tbl.titleAuto = false
		CBFS.db.config[lang][preset][k] = tbl
	end
end
CBFS.InitializeConfigData = cbfsInitializeConfigData


local function cbfsValidateConfigData(lang, preset, isGamepad)
	lang = lang or "en"
	preset = preset or 1

	if not CBFS.db.config[lang][preset] then
		CBFS.db.config[lang][preset] ={}
	end

	for k, v in pairs(cbfsCtrlTbl) do
		-- initialize only the configuration data of the book medium that does not exist in the save data.
		if not CBFS.db.config[lang][preset][k] then
			local tbl = {}
			tbl.bodyStyle, tbl.bodySize, tbl.bodyWeight = LCFM:GetDefaultFontInfoLMP(cbfsGetBodyFontObjName(k, isGamepad))
			tbl.titleStyle, tbl.titleSize, tbl.titleWeight = LCFM:GetDefaultFontInfoLMP(cbfsGetTitleFontObjName(k, isGamepad))
			tbl.titleAuto = false
			CBFS.db.config[lang][preset][k] = tbl
		end
	end
end


local function cbfsInitialize()
	local lang = GetCVar("Language.2")
	local isGamepad = IsInGamepadPreferredMode()
	local preset = 1

	CBFS.lang = lang
	CBFS.isGamepad = isGamepad
	CBFS.preset = preset

	CBFS.db = ZO_SavedVars:NewAccountWide(CBFS.savedVars, CBFS.savedVarsVersion, nil, cbfs_db_default)
	-- create savedata field on first boot in each language mode.
	if not CBFS.db.config[lang] then
		cbfsInitializeConfigData(lang, preset, isGamepad)
	else
		cbfsValidateConfigData(lang, preset, isGamepad)
	end

	-- backend
	ZO_PreHookHandler(ZO_LoreReader, "OnShow", LORE_READER_OnShow_prehook)
	ZO_PreHook(LORE_READER, "OnHide", LORE_READER_OnHide_prehook)
	ZO_PreHook(LORE_READER, "SetupBook", LORE_READER_SetupBook_prehook)

	if SCENE_MANAGER:GetScene("antiquityLoreKeyboard") then
		SCENE_MANAGER:GetScene("antiquityLoreKeyboard"):RegisterCallback("StateChange", OnSceneStateChange_antiquityLoreKeyboard)
		ZO_PreHook(ANTIQUITY_LORE_KEYBOARD, "Refresh", ANTIQUITY_LORE_KEYBOARD_Refresh_prehook)
	end
	if SCENE_MANAGER:GetScene("gamepad_antiquity_lore") then
		SCENE_MANAGER:GetScene("gamepad_antiquity_lore"):RegisterCallback("StateChange", OnSceneStateChange_gamepad_antiquity_lore)
		ZO_PreHook(ANTIQUITY_LORE_GAMEPAD, "RefreshLoreList", ANTIQUITY_LORE_GAMEPAD_RefreshLoreList_prehook)
	end

--	CBFS.LDL:Debug("Initialized")
end


local function cbfsConfigDebug(arg)
	local debugMode = false
	local key = HashString(GetDisplayName())
	local dummy = function() end
	if LibDebugLogger then
		for _, v in pairs(arg or CBFS.authority or {}) do
			if key == v then debugMode = true end
		end
	end
	if debugMode then
		CBookFontStylist.LDL = LibDebugLogger(CBFS.name)
	else
		CBookFontStylist.LDL = { Verbose = dummy, Debug = dummy, Info = dummy, Warn = dummy, Error = dummy, }
	end
end


local function OnPlayerActivated(event, initial)
--	CBFS.LDL:Debug("EVENT_PLAYER_ACTIVATED")
	EVENT_MANAGER:UnregisterForEvent(CBFS.name, EVENT_PLAYER_ACTIVATED)		-- Only after the first login/reloadUI.

	-- UI initialization
	CBFS.uiPanel = CBFS.CreateSettingsWindow()
end
EVENT_MANAGER:RegisterForEvent(CBFS.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)


local function OnAddOnLoaded(event, addonName)
	if addonName ~= CBFS.name then return end
	EVENT_MANAGER:UnregisterForEvent(CBFS.name, EVENT_ADD_ON_LOADED)

	cbfsConfigDebug()
	cbfsInitialize()
end
EVENT_MANAGER:RegisterForEvent(CBFS.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)


-- ------------------------------------------------
--[[
SLASH_COMMANDS["/cbfs.on"] = function(arg)
	CBFS_UI_PreviewWindow:SetHidden(false)
end

SLASH_COMMANDS["/cbfs.off"] = function(arg)
	CBFS_UI_PreviewWindow:SetHidden(true)
end
]]
SLASH_COMMANDS["/cbfs.debug"] = function(arg) if arg ~= "" then cbfsConfigDebug({tonumber(arg)}) end end
SLASH_COMMANDS["/cbfs.test"] = function(arg)
	CBFS.LDL:Debug("BOOK_MEDIUM_ITERATION_BEGIN =", BOOK_MEDIUM_ITERATION_BEGIN)
	CBFS.LDL:Debug("BOOK_MEDIUM_ITERATION_END =", BOOK_MEDIUM_ITERATION_END)
	for k, v in pairs(cbfsCtrlTbl) do
		CBFS.LDL:Debug("cbfsCtrlTbl[%d] flag = %s", tostring(k), tostring(v.isChanged))
	end
--	CBFS.LDL:Verbose("hoge")
--	CBFS.LDL:Debug("hoge")
--	CBFS.LDL:Info("hoge")
--	CBFS.LDL:Warn("hoge")
--	CBFS.LDL:Error("hoge")
end
