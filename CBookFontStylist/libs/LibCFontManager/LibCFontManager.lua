--
-- LibCFontManager [LCFM]
--
-- Copyright (c) 2020 Calamath
--
-- This software is released under the Artistic License 2.0
-- https://opensource.org/licenses/Artistic-2.0
--
-- Note :
-- This library addon works that uses the library LibMediaProvider-1.0 by Seerah, released under the LGPL-2.1 license.
-- You will need to obtain the above library separately.
--

if LibCFontManager then d("[LCFM] Warning : 'LibCFontManager' has always been loaded.") return end

-- Library
local LMP = LibMediaProvider
if not LMP then d("[LCFM] Error : 'LibMediaProvider' not found.") return end

local L = GetString
local tconcat = table.concat

-- Registeration of ESO bundled fonts to support Japanese language mode. These are not currently registered in LibMediaProvider.
LMP:Register("font", "JP-StdFont", "EsoUI/Common/Fonts/ESO_FWNTLGUDC70-DB.ttf") 	-- JP-ESO Standard Font
LMP:Register("font", "JP-ChatFont", "EsoUI/Common/Fonts/ESO_FWUDC_70-M.ttf")		-- JP-ESO Chat Font
LMP:Register("font", "JP-KafuPenji", "EsoUI/Common/Fonts/ESO_KafuPenji-M.ttf")		-- JP-ESO Book Font

-- -------------------------------------------

LibCFontManager = {}
LibCFontManager.name = "LibCFontManager"
LibCFontManager.version = "1.04"
LibCFontManager.author = "Calamath"
LibCFontManager.savedVars = "LibCFontManagerDB" -- for testing purpose 
LibCFontManager.savedVarsVersion = 1			-- for testing purpose
LibCFontManager.authority = {2973583419,210970542} 
LibCFontManager.isInitialized = false

local LCFM = LibCFontManager

-- -------------------------------------------

local lang = "en"
local isGamepad = false
local zosFontNum = 0
local unknownFontNum = 0

local lmpFontStyleList = {}
local lmpFontPathTable = {}
local needToRebuildFontStyleList = false			-- need for alphabetical sorting due to new fonts added to LibMediaProvider after initialize

local lmpFontExTable = {
--		lmpFontExTable[key].XXX
--			filename			: [string] font filename without path string (not lowercase !)
--			provider			: [string] font provider (usually add-on filepath that bundled this font, or '$$LCFM_unknown' when the provider is unknown)
--			isEsoEmbeddedFont	: [boolean] ESO embedded font or not (the result of judging whether the filename matches that of the ESO embedded font)
--			name				: [string] font name (OPTIONAL)
--			description 		: [string] font description (OPTIONAL)
--			tooltip				: [string] tooltip text
--			tooltipUpdated		: [boolean] need to update tooltip text or not (internal use only)
--
	["Univers 55"] = { name = L(SI_LCFM_FONTNAME_UNIVERS55) }, 
	["Univers 57"] = { name = L(SI_LCFM_FONTNAME_UNIVERS57) }, 
	["Univers 67"] = { name = L(SI_LCFM_FONTNAME_UNIVERS67) }, 
	["JP-StdFont"] = { name = L(SI_LCFM_FONTNAME_ESO_FWNTLGUDC70_DB) }, 
	["JP-ChatFont"] = { name = L(SI_LCFM_FONTNAME_ESO_FWUDC_70_M) }, 
	["JP-KafuPenji"] = { name = L(SI_LCFM_FONTNAME_ESO_KAFUPENJI_M) }, 
	["Futura Condensed Light"] = { name = L(SI_LCFM_FONTNAME_FTN47) }, 
	["Futura Condensed"] = { name = L(SI_LCFM_FONTNAME_FTN57) }, 
	["Futura Condensed Bold"] = { name = L(SI_LCFM_FONTNAME_FTN87) }, 
	["Skyrim Handwritten"] = { name = L(SI_LCFM_FONTNAME_HANDWRITTEN_BOLD) }, 
	["ProseAntique"] = { name = L(SI_LCFM_FONTNAME_PROSEANTIQUEPSMT) }, 
	["Trajan Pro"] = { name = L(SI_LCFM_FONTNAME_TRAJANPRO_REGULAR) }, 
	["Consolas"] = { name = L(SI_LCFM_FONTNAME_CONSOLA) }, 
}

local lmpFontFilenameToFontStyleLMP = {}  -- lowercase filename to FontStyleLMP


-- A data table used by this library to identify whether the font is an official bundled font or not.
local zosFontFilenameToFontStyleLMP = {   -- lowercase filename to FontStyleLMP
	["univers55.otf"] = "Univers 55",					-- 
	["univers57.otf"] = "Univers 57",					-- "MEDIUM_FONT""CHAT_FONT"
	["univers67.otf"] = "Univers 67",					-- "BOLD_FONT"
	["eso_fwntlgudc70-db.ttf"] = "JP-StdFont",			-- JP-ESO bundled gothic font
	["eso_fwudc_70-m.ttf"] = "JP-ChatFont", 			-- JP-ESO bundled gothic condensed font
	["eso_kafupenji-m.ttf"] = "JP-KafuPenji",			-- JP-ESO bundled hand written font
	["ftn47.otf"] = "Futura Condensed Light",			-- "GAMEPAD_LIGHT_FONT"
	["ftn57.otf"] = "Futura Condensed", 				-- "GAMEPAD_MEDIUM_FONT"
	["ftn87.otf"] = "Futura Condensed Bold",			-- "GAMEPAD_BOLD_FONT"
	["handwritten_bold.otf"] = "Skyrim Handwritten",	-- "HANDWRITTEN_FONT"
	["proseantiquepsmt.otf"] = "ProseAntique",			-- "ANTIQUE_FONT"
	["trajanpro-regular.otf"] = "Trajan Pro",			-- "STONE_TABLET_FONT"
	["consola.ttf"] = "Consolas",						-- 
}

-- in-game ZOS defined font list
local zosFontTable = {
	ZoFontWinH1 					= {}, 
	ZoFontWinH2 					= {}, 
	ZoFontWinH3 					= {}, 
	ZoFontWinH4 					= {}, 
	ZoFontWinH5 					= {}, 

	ZoFontWinH3SoftShadowThin		= {}, 

	ZoFontWinT1 					= {}, 
	ZoFontWinT2 					= {}, 

	ZoFontGame						= {}, 
	ZoFontGameMedium				= {}, 
	ZoFontGameBold					= {}, 
	ZoFontGameOutline				= {}, 
	ZoFontGameShadow				= {}, 

	ZoFontKeyboard28ThickOutline	= {}, 
	ZoFontKeyboard24ThickOutline	= {}, 
	ZoFontKeyboard18ThickOutline	= {}, 

	ZoFontGameSmall 				= {}, 
	ZoFontGameLarge 				= {}, 
	ZoFontGameLargeBold 			= {}, 
	ZoFontGameLargeBoldShadow		= {}, 

	ZoFontHeader					= {}, 
	ZoFontHeader2					= {}, 
	ZoFontHeader3					= {}, 
	ZoFontHeader4					= {}, 

	ZoFontHeaderNoShadow			= {}, 

	ZoFontCallout					= {}, 
	ZoFontCallout2					= {}, 
	ZoFontCallout3					= {}, 

	ZoFontEdit						= {}, 
	ZoFontEdit20NoShadow			= {}, 

	ZoFontChat						= {}, 
	ZoFontEditChat					= {}, 

	ZoFontWindowTitle				= {}, 
	ZoFontWindowSubtitle			= {}, 

	ZoFontTooltipTitle				= {}, 
	ZoFontTooltipSubtitle			= {}, 

	ZoFontAnnounce					= {}, 
	ZoFontAnnounceMessage			= {}, 
	ZoFontAnnounceMedium			= {}, 
	ZoFontAnnounceLarge 			= {}, 

	ZoFontAnnounceLargeNoShadow 	= {}, 
	
	ZoFontCenterScreenAnnounceLarge = {}, 
	ZoFontCenterScreenAnnounceSmall = {}, 

	ZoFontAlert 					= {}, 

	ZoFontConversationName			= {}, 
	ZoFontConversationText			= {}, 
	ZoFontConversationOption		= {}, 
	ZoFontConversationQuestReward	= {}, 

	ZoFontKeybindStripKey			= {}, 
	ZoFontKeybindStripDescription	= {}, 
	ZoFontDialogKeybindDescription	= {}, 

	ZoInteractionPrompt 			= {}, 

	ZoFontCreditsHeader 			= {}, 
	ZoFontCreditsText				= {}, 

	ZoFontSubtitleText				= {}, 

	ZoMarketAnnouncementCalloutFont = {}, 

--	<!-- In Game Book Fonts-->
	ZoFontBookPaper 				= {}, 
	ZoFontBookSkin					= {}, 
	ZoFontBookRubbing				= {}, 
	ZoFontBookLetter				= {}, 
	ZoFontBookNote					= {}, 
	ZoFontBookScroll				= {}, 
	ZoFontBookTablet				= {}, 
	ZoFontBookMetal 				= {}, 

--	<!-- In Game Book Title Fonts-->
	ZoFontBookPaperTitle			= {}, 
	ZoFontBookSkinTitle 			= {}, 
	ZoFontBookRubbingTitle			= {}, 
	ZoFontBookLetterTitle			= {}, 
	ZoFontBookNoteTitle 			= {}, 
	ZoFontBookScrollTitle			= {}, 
	ZoFontBookTabletTitle			= {}, 
	ZoFontBookMetalTitle			= {}, 


--	<!-- Generic Gamepad Fonts-->
	ZoFontGamepad61 				= {}, 
	ZoFontGamepad54 				= {}, 
	ZoFontGamepad45 				= {}, 
	ZoFontGamepad42 				= {}, 
	ZoFontGamepad36 				= {}, 
	ZoFontGamepad34 				= {}, 
	ZoFontGamepad27 				= {}, 
	ZoFontGamepad25 				= {}, 
	ZoFontGamepad22 				= {}, 
	ZoFontGamepad20 				= {}, 
	ZoFontGamepad18 				= {}, 

	ZoFontGamepad27NoShadow 		= {}, 
	ZoFontGamepad42NoShadow 		= {}, 

	ZoFontGamepad36ThickOutline 	= {}, 
	
	ZoFontGamepadCondensed61		= {}, 
	ZoFontGamepadCondensed54		= {}, 
	ZoFontGamepadCondensed45		= {}, 
	ZoFontGamepadCondensed42		= {}, 
	ZoFontGamepadCondensed36		= {}, 
	ZoFontGamepadCondensed34		= {}, 
	ZoFontGamepadCondensed27		= {}, 
	ZoFontGamepadCondensed25		= {}, 
	ZoFontGamepadCondensed22		= {}, 
	ZoFontGamepadCondensed20		= {}, 
	ZoFontGamepadCondensed18		= {}, 

	ZoFontGamepadBold61 			= {}, 
	ZoFontGamepadBold54 			= {}, 
	ZoFontGamepadBold48 			= {}, 
	ZoFontGamepadBold34 			= {}, 
	ZoFontGamepadBold27 			= {}, 
	ZoFontGamepadBold25 			= {}, 
	ZoFontGamepadBold22 			= {}, 
	ZoFontGamepadBold20 			= {}, 
	ZoFontGamepadBold18 			= {}, 
	
	ZoFontGamepadChat				= {}, 
	ZoFontGamepadEditChat			= {}, 
	
--	<!-- In Game Book Fonts-->
	ZoFontGamepadBookPaper			= {}, 
	ZoFontGamepadBookSkin			= {}, 
	ZoFontGamepadBookRubbing		= {}, 
	ZoFontGamepadBookLetter 		= {}, 
	ZoFontGamepadBookNote			= {}, 
	ZoFontGamepadBookScroll 		= {}, 
	ZoFontGamepadBookTablet 		= {}, 
	ZoFontGamepadBookMetal			= {}, 
	
--	<!-- In Game Book Title Fonts-->
	ZoFontGamepadBookPaperTitle 	= {}, 
	ZoFontGamepadBookSkinTitle		= {}, 
	ZoFontGamepadBookRubbingTitle	= {}, 
	ZoFontGamepadBookLetterTitle	= {}, 
	ZoFontGamepadBookNoteTitle		= {}, 
	ZoFontGamepadBookScrollTitle	= {}, 
	ZoFontGamepadBookTabletTitle	= {}, 
	ZoFontGamepadBookMetalTitle 	= {}, 
	
--	<!-- Header fonts-->
	ZoFontGamepadHeaderDataValue	= {}, 
	
--	<!-- Market fonts-->
	ZoMarketGamepadCalloutFont		= {}, 
}

-- ------------------------------------------------


local function GetFilename(filePath)
	if filePath then
		return zo_strmatch(filePath, "[^/]+$")
	end
end

local function GetAddonPath(filePath)
	if filePath then
		return zo_strmatch(filePath, "^/?([^/]+)/")
	end
end

local function GetFileExtension(filename)
	if filename then
		filenameWithoutExt, ext = zo_strmatch(filename, "(.+)%.([^%.]+)$")
		if ext == nil then
			filenameWithoutExt = filename
		end
		return ext, filenameWithoutExt
	end
end

local function GetTableKeyForValue(table, value)
	for k, v in pairs(table) do
		if v == value then 
			return k
		end
	end
	return nil
end

local function Decolorize(str)
	if type(str) == "string" then
		return str:gsub("|c%x%x%x%x%x%x", ""):gsub("|r", "")
	else
		return str
	end
end

local function localMakeFontDescriptor(fontPath, size, weight)
-- 'fontPath' should contain a valid filepath string of the target font file.
	local formatStr = "%s|%d"

	if weight or weight ~= "" then
		weight = zo_strlower(weight)
		if weight ~= "normal" then
			formatStr = formatStr .. "|%s"
		end
	end
	return string.format(formatStr, fontPath, size, weight)
end

local function GetFontStyleForValue(fontPath)
	local filename = zo_strlower(GetFilename(fontPath))
	local fontStyleLMP
	fontStyleLMP = zosFontFilenameToFontStyleLMP[filename]	-- first, look in the eso core font table.
	if fontStyleLMP then
		return fontStyleLMP, true
	end
	fontStyleLMP = lmpFontFilenameToFontStyleLMP[filename]	-- second, look in the LMP font table.
	if fontStyleLMP then
		return fontStyleLMP, false
	end
end

local function AppendUnknownFontToLMP(fontPath) -- for fail-safe
--- if someone use the font not registered yet in LibMediaProvider, ...
	if type(fontPath) == "string" then
		unknownFontNum = unknownFontNum + 1
		local _, noextFilename = GetFileExtension(GetFilename(fontPath))
		local fontStyle = string.format("$LCFM_%s", noextFilename)
		LMP:Register("font", fontStyle, fontPath)
		return fontStyle
	end
end

local function CreateFontTooltipText(key)
--	return : [string] tooltip text
	local s = {}
	local font = lmpFontExTable[key]
	if font then
		s[1] = font.name or key
		s[2] = string.format("(%s)", font.filename or "$$LCFM_unknown")
		if font.isEsoEmbeddedFont and (zo_strlower(font.provider) == "esoui") then
			s[3] = L(SI_LCFM_FONTSTYLE_TIPS_ZOSFONT)
		else
			s[3] = zo_strformat(L(SI_LCFM_FONTSTYLE_TIPS_ADDONFONT), font.provider or "$$LCFM_unknown")
		end
		if font.description then
			s[4] = " "
			s[5] = font.description
		end
		return tconcat(s, "\n")
	else
		return ""
	end
end

local function UpdateFontTooltipText(key)
	if not lmpFontExTable[key].tooltipUpdated then
		lmpFontExTable[key].tooltip = CreateFontTooltipText(key)
		lmpFontExTable[key].tooltipUpdated = true
	end
end

local function RebuildFontStyleList()
	if needToRebuildFontStyleList then
		table.sort(lmpFontStyleList)
		needToRebuildFontStyleList = false
	end
end

-- ------------------------------------------------------

local function InitializeLCFM()
	lang = GetCVar("Language.2")
	isGamepad = IsInGamepadPreferredMode()
	zosFontNum = 0
	unknownFontNum = 0

	CreateFont("WorkSpaceLCFM", "$(MEDIUM_FONT)|12")

-- for font management enhancements, this feature work with LibMediaProvider.
	lmpFontStyleList = ZO_ShallowTableCopy(LMP:List("font"))	-- LCFM uses an own local copy of the LMP font media list.
	lmpFontPathTable = ZO_ShallowTableCopy(LMP:HashTable("font"))
	needToRebuildFontStyleList = false
	for i, key in pairs(lmpFontStyleList) do
		WorkSpaceLCFM:SetFont(lmpFontPathTable[key])	-- Extract reliabe font path whether font string or not.
		local fontPath = WorkSpaceLCFM:GetFontInfo()

		local filename = GetFilename(fontPath)
		local lowercaseFilename = zo_strlower(filename)
		lmpFontFilenameToFontStyleLMP[lowercaseFilename] = key

		lmpFontExTable[key] = lmpFontExTable[key] or {}
		lmpFontExTable[key].provider = GetAddonPath(fontPath) or "$$LCFM_unknown"
		lmpFontExTable[key].filename = filename
		if zosFontFilenameToFontStyleLMP[lowercaseFilename] then
			lmpFontExTable[key].isEsoEmbeddedFont = true
		else
			lmpFontExTable[key].isEsoEmbeddedFont = false
		end
		lmpFontExTable[key].tooltip = CreateFontTooltipText(key)
		lmpFontExTable[key].tooltipUpdated = true
	end
	CALLBACK_MANAGER:RegisterCallback("LibMediaProvider_Registered", function(mediatype, key)	-- callback routine to ensure consistency with the LMP font list after local copy.
		if mediatype ~= "font" then return end
		if GetTableKeyForValue(lmpFontStyleList, key) == nil then
			table.insert(lmpFontStyleList, key)
		end
		local fontPath = LMP:Fetch("font", key)
		lmpFontPathTable[key] = fontPath
		needToRebuildFontStyleList = true

		WorkSpaceLCFM:SetFont(fontPath)					-- Extract reliabe font path whether font string or not.
		fontPath = WorkSpaceLCFM:GetFontInfo()

		local filename = GetFilename(fontPath)
		local lowercaseFilename = zo_strlower(filename)
		lmpFontFilenameToFontStyleLMP[lowercaseFilename] = key

		lmpFontExTable[key] = lmpFontExTable[key] or {}
		lmpFontExTable[key].provider = GetAddonPath(fontPath) or "$$LCFM_unknown"
		lmpFontExTable[key].filename = filename
		if zosFontFilenameToFontStyleLMP[lowercaseFilename] then
			lmpFontExTable[key].isEsoEmbeddedFont = true
		else
			lmpFontExTable[key].isEsoEmbeddedFont = false
		end
		lmpFontExTable[key].tooltip = CreateFontTooltipText(key)
		lmpFontExTable[key].tooltipUpdated = true
		LCFM.LDL:Debug("Registered new font : ", key)
	end)

-- for preserve the initial state of the zos fonts in various game mode environments,
	for k, v in pairs(zosFontTable) do
		if _G[k] ~= nil then
			v.objName = k	-- for debug
			v.fontPath, v.size, v.weight = _G[k]:GetFontInfo()
			if not v.weight or v.weight == "" then
				v.weight = "normal"
			end
			v.descriptor = localMakeFontDescriptor(v.fontPath, v.size, v.weight)	-- for debug
			v.style, v.isEsoEmbeddedFont = GetFontStyleForValue(v.fontPath)
			if not v.style then
				v.style, v.isEsoEmbeddedFont = AppendUnknownFontToLMP(v.fontPath) or "$$LCFM_unknown", false
			end
			v.provider = GetAddonPath(v.fontPath) or "$$LCFM_unknown"	-- for debug
			v.isModified = false
			zosFontNum = zosFontNum + 1
		else
			LCFM.LDL:Warn("Warning : zosFont '" .. tostring(k) .. "' is deleted!")
			zosFontTable[k] = nil
		end
	end
end


local function lcfmConfigDebug(arg)
	local debugMode = false
	local key = HashString(GetDisplayName())
	local dummy = function() end
	if LibDebugLogger then
		for _, v in pairs(arg or LCFM.authority or {}) do
			if key == v then debugMode = true end
		end
	end
	if debugMode then
		LibCFontManager.LDL = LibDebugLogger(LCFM.name)
	else
		LibCFontManager.LDL = { Verbose = dummy, Debug = dummy, Info = dummy, Warn = dummy, Error = dummy, }
	end
end


local function OnAddOnLoaded(event, addonName)
	if addonName ~= LCFM.name then return end
	EVENT_MANAGER:UnregisterForEvent(LCFM.name, EVENT_ADD_ON_LOADED)

	lcfmConfigDebug()
	InitializeLCFM()
	LCFM.isInitialized = true
--	LCFM.LDL:Debug("Initialized")
end
EVENT_MANAGER:RegisterForEvent(LCFM.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)





-- ------------------------------------------------------------------------------------------------
-- API Section
-- ------------------------------------------------------------------------------------------------

function LibCFontManager:MakeFontDescriptor(fontPath, size, weight)
	return localMakeFontDescriptor(fontPath, size, weight)
end

function LibCFontManager:MakeFontDescriptorLMP(style, size, weight)
-- 'style' should contain a valid handle string of the LibMediaProvider font table.
	if type(style) == "string" then
		local fontPath = LMP:Fetch("font", style)
		if fontPath then
			return localMakeFontDescriptor(fontPath, size, weight)
		end
	end
end

function LibCFontManager:GetFontFilenameLMP(style)
	if type(style) ~= "string" then return end
	if lmpFontExTable[style] then
		return lmpFontExTable[style].filename
	end
end

function LibCFontManager:GetFontProviderLMP(style)
	if type(style) ~= "string" then return end
	if lmpFontExTable[style] then
		return lmpFontExTable[style].provider
	end
end

function LibCFontManager:GetFontPathFromFontString(fontString)
-- Extract a fontPath from fontstring such as $(MEDIUM_FONT).
	if type(fontString) == "string" then
		WorkSpaceLCFM:SetFont(fontString)
		return WorkSpaceLCFM:GetFontInfo()
	end
end

--[[
function LibCFontManager:IsEsoEmbeddedFontLMP(style)
	if type(style) ~= "string" then return end
	if lmpFontExTable[style] then
		return lmpFontExTable[style].isEsoEmbeddedFont
	end
end
]]

function LibCFontManager:SetFontNameLMP(style, name)
	if type(style) ~= "string" then return end
	if type(name) ~= "string" then return end
	lmpFontExTable[style] = lmpFontExTable[style] or {}
	lmpFontExTable[style].name = name
	lmpFontExTable[style].tooltipUpdated = false
end

function LibCFontManager:GetFontNameLMP(style)
	if type(style) ~= "string" then return end
	if lmpFontExTable[style] then
		return lmpFontExTable[style].name
	end
end

function LibCFontManager:SetFontDescriptionLMP(style, description)
	if type(style) ~= "string" then return end
	if type(description) ~= "string" then return end
	lmpFontExTable[style] = lmpFontExTable[style] or {}
	lmpFontExTable[style].description = description
	lmpFontExTable[style].tooltipUpdated = false
end

function LibCFontManager:GetFontDescriptionLMP(style)
	if type(style) ~= "string" then return end
	if lmpFontExTable[style] then
		return lmpFontExTable[style].description
	end
end

function LibCFontManager:GetFontTooltipTextLMP(style)
	if type(style) ~= "string" then return end
	if lmpFontExTable[style] then
		UpdateFontTooltipText(style)
		return lmpFontExTable[style].tooltip
	end
end

function LibCFontManager:RegisterLMP(mediatype, style, fontPath, fontName, fontDescription)
	if fontName then
		LCFM:SetFontNameLMP(style, fontName)
	end
	if fontDescription then
		LCFM:SetFontDescriptionLMP(style, fontDescription)
	end
	return LMP:Register(mediatype, style, fontPath)
end

-- ------------------------------------------------------------------------------------------------
function LibCFontManager:GetFontStyleListLMP()
	local t = {}
	RebuildFontStyleList()
	t = ZO_ShallowTableCopy(lmpFontStyleList)
	return t
end

function LibCFontManager:GetDecoratedFontStyleListLMP()
	local t = {}
	RebuildFontStyleList()
	for k, v in pairs(lmpFontStyleList) do
		if lmpFontExTable[v].isEsoEmbeddedFont then
			t[k] = "|c4169e1" .. v .. "|r"
		else
			t[k] = v
		end
	end
	return t
end

function LibCFontManager:GetFontTooltipListLMP()
	local t = {}
	RebuildFontStyleList()
	for k, v in pairs(lmpFontStyleList) do
		UpdateFontTooltipText(v)
		t[k] = lmpFontExTable[v].tooltip or ""
	end
	return t
end

-- ------------------------------------------------------------------------------------------------

function LibCFontManager:GetDefaultFontInfo(objName)
	local tbl = zosFontTable[objName]
	if tbl then
		local weight = tbl.weight
		if weight == "normal" then weight = nil end
		return tbl.fontPath, tbl.size, weight
	end
end

function LibCFontManager:GetDefaultFontInfoLMP(objName)
	local tbl = zosFontTable[objName]
	if tbl then
		return tbl.style, tbl.size, tbl.weight
	end
end

function LibCFontManager:GetDefaultFontDescriptor(objName)
	local tbl = zosFontTable[objName]
	if tbl then
		return tbl.descriptor
	end
end

function LibCFontManager:RestoreToDefaultFont(objName)
	local tbl = zosFontTable[objName]
	if tbl then
		_G[objName]:SetFont(tbl.descriptor)
		tbl.isModified = false
	end
end

function LibCFontManager:SetToNewFont(objName, fontDescriptor)
	local tbl = zosFontTable[objName]
	if tbl then
		_G[objName]:SetFont(fontDescriptor)
		tbl.isModified = true
	end
end

function LibCFontManager:SetToNewFontLMP(objName, style, size, weight)
	local fontDescriptor = self:MakeFontDescriptorLMP(style, size, weight)
	if fontDescriptor then
		self:SetToNewFont(objName, fontDescriptor)
	end
end



-- ------------------------------------------------

SLASH_COMMANDS["/lcfm.debug"] = function(arg) if arg ~= "" then lcfmConfigDebug({tonumber(arg)}) end end
--[[
SLASH_COMMANDS["/lcfm.test"] = function(arg)
	-- for debug
	local db_default = {
		lmpFontStyleList = lmpFontStyleList, 
		lmpFontPathTable = lmpFontPathTable, 
		lmpFontExTable = lmpFontExTable, 
		lmpFontFilenameToFontStyleLMP = lmpFontFilenameToFontStyleLMP, 
		zosFontTable = zosFontTable, 
		unknownFontNum = unknownFontNum, 
	}
	LCFM.db = ZO_SavedVars:NewAccountWide(LCFM.savedVars, LCFM.savedVarsVersion, nil, db_default)

--	LCFM.LDL:Verbose("hoge")
--	LCFM.LDL:Debug("hoge")
--	LCFM.LDL:Info("hoge")
--	LCFM.LDL:Warn("hoge")
--	LCFM.LDL:Error("hoge")
end
]]
