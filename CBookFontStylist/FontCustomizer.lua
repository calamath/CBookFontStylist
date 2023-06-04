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

local zosFontStrings = {
	"$(MEDIUM_FONT)", 
	"$(BOLD_FONT)", 
	"$(CHAT_FONT)", 
	"$(GAMEPAD_LIGHT_FONT)", 
	"$(GAMEPAD_MEDIUM_FONT)", 
	"$(GAMEPAD_BOLD_FONT)", 
	"$(ANTIQUE_FONT)", 
	"$(HANDWRITTEN_FONT)", 
	"$(STONE_TABLET_FONT)", 
}

local lmpFontStrings = {
	"$(PROSE_ANTIQUE_FONT)", 
	"$(CONSOLAS_FONT)", 
	"$(FTN47_FONT)", 
	"$(FTN57_FONT)", 
	"$(FTN87_FONT)", 
	"$(HANDWRITTEN_BOLD_FONT)", 
	"$(TRAJAN_PRO_R_FONT)", 
	"$(UNIVERS55_FONT)", 
	"$(UNIVERS57_FONT)", 
	"$(UNIVERS67_FONT)", 
	"$(UNIVERS57CYR_FONT)", 
	"$(UNIVERS67CYR_FONT)", 
}

local lmpPredefinedFontStyles = {
	"Univers 57", 
	"Univers 67", 
	"ProseAntique", 
	"Skyrim Handwritten", 
	"Trajan Pro", 
	"Futura Condensed", 
	"Futura Condensed Bold", 
	"Futura Condensed Light", 
	"JP-StdFont", 
	"JP-ChatFont", 
	"JP-KafuPenji", 
	"ZH-StdFont", 
	"ZH-MYoyoPRC", 
	"Univers 55", 
	"Consolas", 
}

local zosBookFontNames = {
--	<!-- In Game Book Fonts-->
	"ZoFontBookPaper", 
	"ZoFontBookSkin", 
	"ZoFontBookRubbing", 
	"ZoFontBookLetter", 
	"ZoFontBookNote", 
	"ZoFontBookScroll", 
	"ZoFontBookTablet", 
	"ZoFontBookMetal", 
	"ZoFontGamepadBookPaper", 
	"ZoFontGamepadBookSkin", 
	"ZoFontGamepadBookRubbing", 
	"ZoFontGamepadBookLetter", 
	"ZoFontGamepadBookNote", 
	"ZoFontGamepadBookScroll", 
	"ZoFontGamepadBookTablet", 
	"ZoFontGamepadBookMetal", 
--	<!-- In Game Book Title Fonts-->
	"ZoFontBookPaperTitle", 
	"ZoFontBookSkinTitle", 
	"ZoFontBookRubbingTitle", 
	"ZoFontBookLetterTitle", 
	"ZoFontBookNoteTitle", 
	"ZoFontBookScrollTitle", 
	"ZoFontBookTabletTitle", 
	"ZoFontBookMetalTitle", 
	"ZoFontGamepadBookPaperTitle", 
	"ZoFontGamepadBookSkinTitle", 
	"ZoFontGamepadBookRubbingTitle", 
	"ZoFontGamepadBookLetterTitle", 
	"ZoFontGamepadBookNoteTitle", 
	"ZoFontGamepadBookScrollTitle", 
	"ZoFontGamepadBookTabletTitle", 
	"ZoFontGamepadBookMetalTitle", 
}


-- ---------------------------------------------------------------------------------------
-- Font Customizer Class
-- ---------------------------------------------------------------------------------------
local CBFS_FontCustomizer_Singleton = ZO_InitializingObject:Subclass()

function CBFS_FontCustomizer_Singleton:Initialize()
	self.name = "CBFS-FontCustomizerSingleton"
	self.myWorkspaceFont = CreateFont("cbfsWorkspaceUtilityFont", "$(MEDIUM_FONT)|12")
	self.customizedFontList = {}

	self.lmpFontStyleList = LMP:List("font")
	self.lmpFontPathList = {}
	for _, fontStyle in ipairs(self.lmpFontStyleList) do
		self.lmpFontPathList[fontStyle] = LMP:Fetch("font", fontStyle)
	end

	self.fontStyleReverseLookup = {}	-- We often want to reverse lookup which font style is this font path.
	for _, fontStyle in ipairs(lmpPredefinedFontStyles) do
		self:InsertFontStyleReverseLookup(fontStyle)
	end
	for _, fontStyle in ipairs(self.lmpFontStyleList) do
		self:InsertFontStyleReverseLookup(fontStyle)
	end
	CALLBACK_MANAGER:RegisterCallback("LibMediaProvider_Registered", function(mediatype, fontStyle)
		if mediatype ~= "font" then return end
		if self.lmpFontPathList[fontStyle] then return end
		local lmpFontPath = LMP:Fetch("font", fontStyle)
		if lmpFontPath then
			self.lmpFontPathList[fontStyle] = self.lmpFontPathList[fontStyle] or lmpFontPath
			self:InsertFontStyleReverseLookup(fontStyle)
			CBFS.LDL:Debug("Registered new LMP font: ", fontStyle)
		end
	end)

	self.defaultFonts = {}
	for _, fontObjectName in ipairs(zosBookFontNames) do
	-- for preserve the initial state of the zos book fonts in various game mode environments,
		local fontObject = _G[fontObjectName]
		if fontObject then
			local fontPath, fontSize, fontWeight = fontObject:GetFontInfo()
			self.defaultFonts[fontObjectName] = {
				fontPath = fontPath, 
				fontSize = fontSize, 
				fontWeight = fontWeight, 
				fontDescriptor = self:MakeFontDescriptor(fontPath, fontSize, fontWeight), 
			}
		end
	end
end

function CBFS_FontCustomizer_Singleton:InsertFontStyleReverseLookup(fontStyle, fontPath)
	local fontPath = fontStyle and self.lmpFontPathList[fontStyle] or ""
	fontPath = self:GetFontDescriptorInfo(fontPath)
	if fontPath ~= "" then
		local lowercaseFontPath = zo_strlower(fontPath)
		self.fontStyleReverseLookup[lowercaseFontPath] = self.fontStyleReverseLookup[lowercaseFontPath] or fontStyle
	end
end

function CBFS_FontCustomizer_Singleton:GetFontDescriptorInfo(fontDescriptor)
-- ** _Returns:_ *string* _fontPath_, *integer* _fontSize_, *string* _fontWeight_
-- Hint: We often want to know the entity value indicated by a font string such as "$(BOLD_FONT)" or "$(KB_18)".
	if type(fontDescriptor) == "string" then
		self.myWorkspaceFont:SetFont(fontDescriptor)
		return self.myWorkspaceFont:GetFontInfo()
	end
end

function CBFS_FontCustomizer_Singleton:MakeFontDescriptor(fontPath, fontSize, fontWeight)
-- 'fontPath' should contain a valid filepath string of the target font file.
	if fontWeight and fontWeight ~= "" then
		return string.format("%s|%s|%s", fontPath, tostring(fontSize), fontWeight)
	else
		return string.format("%s|%s", fontPath, tostring(fontSize))
	end
end
function CBFS_FontCustomizer_Singleton:MakeFontDescriptorByLMP(fontStyle, fontSize, fontWeight)
	if self.lmpFontPathList[fontStyle] then
		return self:MakeFontDescriptor(self.lmpFontPathList[fontStyle], fontSize, fontWeight)
	end
end

function CBFS_FontCustomizer_Singleton:GetDefaultFontPath(fontObjectName)
	return type(fontObjectName) == "string" and self.defaultFonts[fontObjectName] and self.defaultFonts[fontObjectName].fontPath
end

function CBFS_FontCustomizer_Singleton:GetDefaultFontSize(fontObjectName)
	return type(fontObjectName) == "string" and self.defaultFonts[fontObjectName] and self.defaultFonts[fontObjectName].fontSize
end

function CBFS_FontCustomizer_Singleton:GetDefaultFontWeight(fontObjectName)
	return type(fontObjectName) == "string" and self.defaultFonts[fontObjectName] and self.defaultFonts[fontObjectName].fontWeight
end

function CBFS_FontCustomizer_Singleton:GetDefaultFontDescriptor(fontObjectName)
	return type(fontObjectName) == "string" and self.defaultFonts[fontObjectName] and self.defaultFonts[fontObjectName].fontDescriptor
end

function CBFS_FontCustomizer_Singleton:GetDefaultFontStyle(fontObjectName)
	local defaultFontPath = self:GetDefaultFontPath(fontObjectName)
	if defaultFontPath then
		return self.fontStyleReverseLookup[zo_strlower(defaultFontPath)]
	end
end

function CBFS_FontCustomizer_Singleton:IsCustomized(fontObjectName)
	return fontObjectName and self.customizedFontList[fontObjectName] or false
end

function CBFS_FontCustomizer_Singleton:CustomizeFont(fontObjectName, fontDescriptor)
	-- We only customize fonts that can be reverted.
	local fontObject = _G[fontObjectName]
	if fontObject and fontObject.SetFont and self.defaultFonts[fontObjectName] then
		fontObject:SetFont(fontDescriptor)
--		CBFS.LDL:Debug("changed: %s -> %s", tostring(fontObjectName), tostring(fontDescriptor))
		self.customizedFontList[fontObjectName] = true
	end
end

function CBFS_FontCustomizer_Singleton:RevertFontToDefault(fontObjectName)
	local fontObject = _G[fontObjectName]
	if fontObject and fontObject.SetFont and self.defaultFonts[fontObjectName] then
		fontObject:SetFont(self.defaultFonts[fontObjectName].fontDescriptor)
--		CBFS.LDL:Debug("reverted: %s -> %s", tostring(fontObjectName), tostring(self.defaultFonts[fontObjectName].fontDescriptor))
		self.customizedFontList[fontObjectName] = nil
	end
end

function CBFS_FontCustomizer_Singleton:RevertAllFontsToDefault()
	for fontObjectName in pairs(self.customizedFontList) do
		_G[fontObjectName]:SetFont(self.defaultFonts[fontObjectName].fontDescriptor)
--		CBFS.LDL:Debug("reverted: %s -> %s", tostring(fontObjectName), tostring(self.defaultFonts[fontObjectName].fontDescriptor))
		self.customizedFontList[fontObjectName] = nil
	end
end


-- ---------------------------------------------------------------------------------------

local CBFS_FONT_MANAGER = CBFS_FontCustomizer_Singleton:New()	-- Never do this more than once!
-- NOTE: The font manager must be prepared prior to EVENT_ADD_ON_LOADED.

-- global API --
local function GetFontManager() return CBFS_FONT_MANAGER end
CBFS:RegisterSharedObject("GetFontManager", GetFontManager)

