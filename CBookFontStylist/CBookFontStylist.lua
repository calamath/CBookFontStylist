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
CBookFontStylist.version = "1.08"
CBookFontStylist.author = "Calamath"
CBookFontStylist.savedVars = "CBookFontStylistDB"
CBookFontStylist.savedVarsVersion = 1
CBookFontStylist.authority = {2973583419,210970542} 
CBookFontStylist.maxPreset = 1

CBookFontStylist.bookMediumID = {
	BMID_NONE			= 0, 
	BMID_YELLOWED_PAPER = 1, 
	BMID_ANIMAL_SKIN	= 2, 
	BMID_RUBBING_PAPER	= 3, 
	BMID_LETTER 		= 4, 
	BMID_NOTE			= 5, 
	BMID_SCROLL 		= 6, 
	BMID_STONE_TABLET	= 7, 
	BMID_METAL			= 8, 
	BMID_METAL_TABLET	= 9, 
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

local cbfsCtrlTbl = {
	[BMID_YELLOWED_PAPER]	= { body = "ZoFontBookPaper",	title = "ZoFontBookPaperTitle", 	isChanged = false, }, 
	[BMID_ANIMAL_SKIN]		= { body = "ZoFontBookSkin",	title = "ZoFontBookSkinTitle",		isChanged = false, }, 
	[BMID_RUBBING_PAPER]	= { body = "ZoFontBookRubbing", title = "ZoFontBookRubbingTitle",	isChanged = false, }, 
	[BMID_LETTER]			= { body = "ZoFontBookLetter",	title = "ZoFontBookLetterTitle",	isChanged = false, }, 
	[BMID_NOTE] 			= { body = "ZoFontBookNote",	title = "ZoFontBookNoteTitle",		isChanged = false, }, 
	[BMID_SCROLL]			= { body = "ZoFontBookScroll",	title = "ZoFontBookScrollTitle",	isChanged = false, }, 
	[BMID_STONE_TABLET] 	= { body = "ZoFontBookTablet",	title = "ZoFontBookTabletTitle",	isChanged = false, }, 
	[BMID_METAL]			= { body = "ZoFontBookMetal",	title = "ZoFontBookMetalTitle", 	isChanged = false, }, 
	[BMID_METAL_TABLET] 	= { body = "ZoFontBookMetal",	title = "ZoFontBookMetalTitle", 	isChanged = false, }, 
}
setmetatable(cbfsCtrlTbl, { __index = function(self, k) d("[CBFS] Error : illegal BMID access") return self[BMID_YELLOWED_PAPER] end, })

local cbfsCtrlTblGamepadDifferences = {
	[BMID_YELLOWED_PAPER]	= { body = "ZoFontGamepadBookPaper",	title = "ZoFontGamepadBookPaperTitle",		}, 
	[BMID_ANIMAL_SKIN]		= { body = "ZoFontGamepadBookSkin", 	title = "ZoFontGamepadBookSkinTitle",		}, 
	[BMID_RUBBING_PAPER]	= { body = "ZoFontGamepadBookRubbing",	title = "ZoFontGamepadBookRubbingTitle",	}, 
	[BMID_LETTER]			= { body = "ZoFontGamepadBookLetter",	title = "ZoFontGamepadBookLetterTitle", 	}, 
	[BMID_NOTE] 			= { body = "ZoFontGamepadBookNote", 	title = "ZoFontGamepadBookNoteTitle",		}, 
	[BMID_SCROLL]			= { body = "ZoFontGamepadBookScroll",	title = "ZoFontGamepadBookScrollTitle", 	}, 
	[BMID_STONE_TABLET] 	= { body = "ZoFontGamepadBookTablet",	title = "ZoFontGamepadBookTabletTitle", 	}, 
	[BMID_METAL]			= { body = "ZoFontGamepadBookMetal",	title = "ZoFontGamepadBookMetalTitle",		}, 
	[BMID_METAL_TABLET] 	= { body = "ZoFontGamepadBookMetal",	title = "ZoFontGamepadBookMetalTitle",		}, 
}



-- CBookFontStylist savedata (default)
local cbfs_db_default = {
	config = {}, 
}

-- ------------------------------------------------

local function cbfsGetBodyFontObjName(bmid)
	return cbfsCtrlTbl[bmid].body
end
CBFS.GetBodyFontObjName = cbfsGetBodyFontObjName

local function cbfsGetTitleFontObjName(bmid)
	return cbfsCtrlTbl[bmid].title
end
CBFS.GetTitleFontObjName = cbfsGetTitleFontObjName

local function cbfsSetupBookFonts(bmid, isGamepad)
	local lang = CBFS.lang
	local preset = CBFS.preset
	local u = CBFS.db.config[lang][preset][bmid]

	local objNameBody = cbfsGetBodyFontObjName(bmid)
	local objNameTitle = cbfsGetTitleFontObjName(bmid)

	if not LMP:IsValid("font", u.bodyStyle) then return end
	if not LMP:IsValid("font", u.titleStyle) then return end

	LCFM:SetToNewFontLMP(objNameBody, u.bodyStyle, u.bodySize, u.bodyWeight)
	LCFM:SetToNewFontLMP(objNameTitle, u.titleStyle, u.titleSize, u.titleWeight)
	cbfsCtrlTbl[bmid].isChanged = true

--	CBFS.LDL:Debug("Changed: ", objNameBody, "->", tostring(LCFM:MakeFontDescriptorLMP(u.bodyStyle, u.bodySize, u.bodyWeight)))
--	CBFS.LDL:Debug("Changed: ", objNameTitle, "->", tostring(LCFM:MakeFontDescriptorLMP(u.titleStyle, u.titleSize, u.titleWeight)))
end

local function cbfsRestoreBookFonts(bmid)
	local objNameBody = cbfsGetBodyFontObjName(bmid)
	local objNameTitle = cbfsGetTitleFontObjName(bmid)

	LCFM:RestoreToDefaultFont(objNameBody)
	LCFM:RestoreToDefaultFont(objNameTitle)

	cbfsCtrlTbl[bmid].isChanged = false
--	CBFS.LDL:Debug("Restored:", objNameBody)
--	CBFS.LDL:Debug("Restored:", objNameTitle)
end


-- ------------------------------------------------

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
	for bmid, v in pairs(cbfsCtrlTbl) do
		if v.isChanged then
			cbfsRestoreBookFonts(bmid)
		end
	end
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
--	CBFS.LDL:Debug("isGamePad =", isGamepad)

	cbfsSetupBookFonts(bmid, isGamepad)
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


local function cbfsInitializeConfigData(lang, preset)
	CBFS.db.config[lang] = CBFS.db.config[lang] or {}
	preset = preset or 1

	if not CBFS.db.config[lang][preset] then
		CBFS.db.config[lang][preset] ={}
	end

	for k, v in pairs(cbfsCtrlTbl) do
		local tbl = {}
		tbl.bodyStyle, tbl.bodySize, tbl.bodyWeight = LCFM:GetDefaultFontInfoLMP(v.body)
		tbl.titleStyle, tbl.titleSize, tbl.titleWeight = LCFM:GetDefaultFontInfoLMP(v.title)
		tbl.titleAuto = false
		CBFS.db.config[lang][preset][k] = tbl
	end
end
CBFS.InitializeConfigData = cbfsInitializeConfigData


local function cbfsInitialize()
	local lang = GetCVar("Language.2")
	local isGamepad = IsInGamepadPreferredMode()
	local preset = 1

	CBFS.lang = lang
	CBFS.isGamepad = isGamepad
	CBFS.preset = preset
	if isGamepad then
		for bmid, v in pairs(cbfsCtrlTblGamepadDifferences) do
			cbfsCtrlTbl[bmid].body, cbfsCtrlTbl[bmid].title = v.body, v.title
		end
	end

	CBFS.db = ZO_SavedVars:NewAccountWide(CBFS.savedVars, CBFS.savedVarsVersion, nil, cbfs_db_default)
	-- create savedata field on first boot in each language mode.
	if not CBFS.db.config[lang] then
		cbfsInitializeConfigData(lang, preset)
	end

	-- backend
	ZO_PreHookHandler(ZO_LoreReader, "OnShow", LORE_READER_OnShow_prehook)
	ZO_PreHook(LORE_READER, "OnHide", LORE_READER_OnHide_prehook)
	ZO_PreHook(LORE_READER, "SetupBook", LORE_READER_SetupBook_prehook)

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
