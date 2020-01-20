--
-- Calamath's BookFont Stylist [CBFS]
--
-- Copyright (c) 2019 Calamath
--
-- This software is released under the MIT License (X11 License).
-- https://choosealicense.com/licenses/mit/
--
-- Note :
-- This addon works that uses the library LibMediaProvider-1.0 by Seerah, released under the LGPL-2.1 license.
-- This addon works that uses the library LibAddonMenu-2.0 by sirinsidiator, Seerah, released under the Artistic License 2.0
-- You will need to obtain the above libraries separately.
--


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


-- Library
local LMP = LibMediaProvider
if not LMP then d("[CBFS] Error : 'LibMediaProvider' not found.") return end
local LAM = LibAddonMenu2
if not LAM then d("[CBFS] Error : 'LibAddonMenu' not found.") return end
local LCFM = LibCFontManager
if not LCFM then d("[CBFS] Error : 'LibCFontManager' not found.") return end

local L = GetString

-- UI section locals
local uiLang
local uiIsGamepad
local uiPreset
local uiBMID
local ui = ui or {}


local function DoSetupDefault(bmid)
	local body = CBFS.GetBodyFontObjName(bmid)
	local title = CBFS.GetTitleFontObjName(bmid)

	ui.defBodyFontMenu, ui.defBodySizeMenu, ui.defBodyWeightMenu = LCFM:GetDefaultFontInfoLMP(body)
	ui.defTitleAutoMenu = false
	ui.defTitleFontMenu, ui.defTitleSizeMenu, ui.defTitleWeightMenu = LCFM:GetDefaultFontInfoLMP(title)
end

local function InitializeUI()
	uiLang = CBFS.lang
	uiIsGamepad = CBFS.isGamepad
	uiPreset = CBFS.preset 
	uiBMID = BMID_YELLOWED_PAPER

	ui.bookMediumTexture = {
		[BMID_YELLOWED_PAPER]	= "EsoUI/Art/LoreLibrary/loreLibrary_paperBook.dds", 
		[BMID_ANIMAL_SKIN]		= "EsoUI/Art/LoreLibrary/loreLibrary_skinBook.dds", 
		[BMID_RUBBING_PAPER]	= "EsoUI/Art/LoreLibrary/loreLibrary_rubbingBook.dds", 
		[BMID_LETTER]			= "EsoUI/Art/LoreLibrary/loreLibrary_letter.dds", 
		[BMID_NOTE] 			= "EsoUI/Art/LoreLibrary/loreLibrary_note.dds", 
		[BMID_SCROLL]			= "EsoUI/Art/LoreLibrary/loreLibrary_scroll.dds", 
		[BMID_STONE_TABLET] 	= "EsoUI/Art/LoreLibrary/loreLibrary_stoneTablet.dds", 
		[BMID_METAL]			= "EsoUI/Art/LoreLibrary/loreLibrary_dwemerBook.dds", 
		[BMID_METAL_TABLET] 	= "EsoUI/Art/LoreLibrary/loreLibrary_dwemerPage.dds", 
	}
	ui.MediumChoices = {
		L(SI_CBFS_BMID_YELLOWED_PAPER_NAME),	-- "Yellowed Paper",
		L(SI_CBFS_BMID_ANIMAL_SKIN_NAME),		-- "Animal Skin",	
		L(SI_CBFS_BMID_RUBBING_PAPER_NAME), 	-- "Rubbing Paper", 
		L(SI_CBFS_BMID_LETTER_NAME),			-- "Letter",		
		L(SI_CBFS_BMID_NOTE_NAME),				-- "Note",			
		L(SI_CBFS_BMID_SCROLL_NAME),			-- "Scroll",		
		L(SI_CBFS_BMID_STONE_TABLET_NAME),		-- "Stone Tablet",	
		L(SI_CBFS_BMID_METAL_NAME), 			-- "Metal", 		
		L(SI_CBFS_BMID_METAL_TABLET_NAME),		-- "Metal Tablet",	
	}
	ui.MediumChoicesValues = {
		BMID_YELLOWED_PAPER, 
		BMID_ANIMAL_SKIN, 
		BMID_RUBBING_PAPER, 
		BMID_LETTER, 
		BMID_NOTE, 
		BMID_SCROLL, 
		BMID_STONE_TABLET, 
		BMID_METAL, 
		BMID_METAL_TABLET, 
	}
	ui.MediumChoicesTooltips = {
		L(SI_CBFS_BMID_YELLOWED_PAPER_TIPS),	-- "Yellowed Paper",
		L(SI_CBFS_BMID_ANIMAL_SKIN_TIPS),		-- "Animal Skin",	
		L(SI_CBFS_BMID_RUBBING_PAPER_TIPS), 	-- "Rubbing Paper", 
		L(SI_CBFS_BMID_LETTER_TIPS),			-- "Letter",		
		L(SI_CBFS_BMID_NOTE_TIPS),				-- "Note",			
		L(SI_CBFS_BMID_SCROLL_TIPS),			-- "Scroll",		
		L(SI_CBFS_BMID_STONE_TABLET_TIPS),		-- "Stone Tablet",	
		L(SI_CBFS_BMID_METAL_TIPS), 			-- "Metal", 		
		L(SI_CBFS_BMID_METAL_TABLET_TIPS),		-- "Metal Tablet",	
	}

	ui.FontChoices = LCFM:GetDecoratedFontStyleListLMP()
	ui.FontChoicesValues = LCFM:GetFontStyleListLMP()
	ui.FontChoicesTooltips = LCFM:GetFontTooltipListLMP()

	ui.WeightChoices = {
		L(SI_CBFS_WEIGHT_NORMAL_NAME),				-- "normal", 
		L(SI_CBFS_WEIGHT_SHADOW_NAME),				-- "shadow", 
		L(SI_CBFS_WEIGHT_OUTLINE_NAME), 			-- "outline", 
		L(SI_CBFS_WEIGHT_THICK_OUTLINE_NAME),		-- "thick-outline", 
		L(SI_CBFS_WEIGHT_SOFT_SHADOW_THIN_NAME),	-- "soft-shadow-thin", 
		L(SI_CBFS_WEIGHT_SOFT_SHADOW_THICK_NAME),	-- "soft-shadow-thick", 
	}
	ui.WeightChoicesValues = { "normal", "shadow", "outline", "thick-outline", "soft-shadow-thin", "soft-shadow-thick" }
	ui.WeightChoicesTooltips = {
		L(SI_CBFS_WEIGHT_NORMAL_TIPS),				-- "normal", 
		L(SI_CBFS_WEIGHT_SHADOW_TIPS),				-- "shadow", 
		L(SI_CBFS_WEIGHT_OUTLINE_TIPS), 			-- "outline", 
		L(SI_CBFS_WEIGHT_THICK_OUTLINE_TIPS),		-- "thick-outline", 
		L(SI_CBFS_WEIGHT_SOFT_SHADOW_THIN_TIPS),	-- "soft-shadow-thin", 
		L(SI_CBFS_WEIGHT_SOFT_SHADOW_THICK_TIPS),	-- "soft-shadow-thick", 
	}

	DoSetupDefault(uiBMID)
end

-- ----------------------------------------------------------------------------------------

local function DoUpdateFontPreview()
	local t = CBFS.db.config[uiLang][uiPreset][uiBMID]
	local bodyFont = LCFM:MakeFontDescriptorLMP(t.bodyStyle, t.bodySize, t.bodyWeight)
	local titleFont = LCFM:MakeFontDescriptorLMP(t.titleStyle, t.titleSize, t.titleWeight)
	local errMsg = ""

	-- font style validity check
	if not LMP:IsValid("font", t.bodyStyle) then
		errMsg = L(SI_CBFS_UI_E1001_ERRMSG_TEXT)
	end
	if not LMP:IsValid("font", t.titleStyle) then
		errMsg = L(SI_CBFS_UI_E1001_ERRMSG_TEXT)
	end
--[[ cbfs082 sta
-- for LAM widget 'descriptions'
	local title = CBFS_UI_FontPreview.title
	local desc = CBFS_UI_FontPreview.desc
	if title then title:SetFont(titleFont) end
	if desc then desc:SetFont(bodyFont) end
cbfs082 end ]]

-- for CBFS Preview Window
	CBFS_UI_PreviewWindowTitle:SetFont(titleFont)
	CBFS_UI_PreviewWindowBody:SetFont(bodyFont)
-- for CBFS Error Message Display
	CBFS_UI_ErrorMessageDisplay.data.text = errMsg
	CBFS_UI_ErrorMessageDisplay:UpdateValue()
end

local function DoChangeBMID(newBMID)
	uiBMID = newBMID
	DoSetupDefault(newBMID)

	CBFS_UI_TabHeader.data.name = ui.MediumChoices[newBMID] .. " :"
	CBFS_UI_TabHeader:UpdateValue()
	CBFS_UI_PreviewWindowMediumBg:SetTexture(ui.bookMediumTexture[newBMID])
	DoUpdateFontPreview()
end

local function DoChangeBodyFont(str)
	CBFS.db.config[uiLang][uiPreset][uiBMID].bodyStyle = str
	if CBFS.db.config[uiLang][uiPreset][uiBMID].titleAuto then
		CBFS_UI_TitleFontMenu:UpdateValue(false, str)
	end
	DoUpdateFontPreview()
end

local function DoChangeBodySize(num)
	CBFS.db.config[uiLang][uiPreset][uiBMID].bodySize = num
	if CBFS.db.config[uiLang][uiPreset][uiBMID].titleAuto then
		CBFS_UI_TitleSizeMenu:UpdateValue(false, num + 10)
	end
	DoUpdateFontPreview()
end

local function DoChangeBodyWeight(str)
	CBFS.db.config[uiLang][uiPreset][uiBMID].bodyWeight = str
	if CBFS.db.config[uiLang][uiPreset][uiBMID].titleAuto then
		CBFS_UI_TitleWeightMenu:UpdateValue(false, str)
	end
	DoUpdateFontPreview()
end

local function DoChangeTitleAuto(bool)
	CBFS.db.config[uiLang][uiPreset][uiBMID].titleAuto = bool
	if (bool == true) then		-- set to ON
		CBFS_UI_TitleFontMenu:UpdateValue(false, CBFS.db.config[uiLang][uiPreset][uiBMID].bodyStyle)
		CBFS_UI_TitleSizeMenu:UpdateValue(false, CBFS.db.config[uiLang][uiPreset][uiBMID].bodySize + 10)
		CBFS_UI_TitleWeightMenu:UpdateValue(false, CBFS.db.config[uiLang][uiPreset][uiBMID].bodyWeight)
		DoUpdateFontPreview()
	end
end

local function DoChangeTitleFont(str)
	CBFS.db.config[uiLang][uiPreset][uiBMID].titleStyle = str
	DoUpdateFontPreview()
end

local function DoChangeTitleSize(num)
	CBFS.db.config[uiLang][uiPreset][uiBMID].titleSize = num
	DoUpdateFontPreview()
end

local function DoChangeTitleWeight(str)
	CBFS.db.config[uiLang][uiPreset][uiBMID].titleWeight = str
	DoUpdateFontPreview()
end

local function DoResetCurrentTab()
	CBFS_UI_BodyFontMenu:UpdateValue(true)
	CBFS_UI_BodySizeMenu:UpdateValue(true)
	CBFS_UI_BodyWeightMenu:UpdateValue(true)
	CBFS_UI_TitleFontMenu:UpdateValue(true)
	CBFS_UI_TitleSizeMenu:UpdateValue(true)
	CBFS_UI_TitleWeightMenu:UpdateValue(true)
	DoUpdateFontPreview()
end

local function DoPanelDefaultMenu()
	CBFS.InitializeConfigData(uiLang, uiPreset)
	uiBMID = BMID_YELLOWED_PAPER
	DoChangeBMID(uiBMID)
	DoResetCurrentTab()
end

local function DoPreviewButton()
	LORE_READER:Show( L(SI_CBFS_UI_PREVIEW_BOOK_TITLE), L(SI_CBFS_UI_PREVIEW_BOOK_BODY), uiBMID, true )
	CBFS.uiPreviewMode = true		-- When the LORE_READER is closed in the CBFS preview mode, the scene is forcibly moved to the CBFS addon panel.
	if uiIsGamepad then
		SCENE_MANAGER:Push("gamepad_loreReaderInteraction")
	else
		SCENE_MANAGER:Push("loreReaderInteraction")    
	end
end






-- -------------------------------------------


local function SetupTLW()
	local tlw = CBFS_UI_PreviewWindow
	local savedata = CBFS.db.window

	local function OnMoveStop(control)
		local newX, newY = control:GetScreenRect()
		CBFS.db.window.x = newX
		CBFS.db.window.y = newY
	end
	local function OnResizeStop(control)
		local newWidth, newHeight = control:GetDimensions()
		CBFS.db.window.width = newWidth
		CBFS.db.window.height = newHeight
	end

-- update TLW attributes
	tlw:ClearAnchors()
	if savedata then
		tlw:SetAnchor(TOPLEFT, guiRoot, TOPLEFT, savedata.x, savedata.y)
		tlw:SetDimensions(savedata.width, savedata.height)
	else
		tlw:SetAnchor(LEFT, ui.panel, RIGHT, 20, 0)
		tlw:SetDimensions(400, 600)

		local x, y = tlw:GetScreenRect()
		local width, height = tlw:GetDimensions()
		savedata = {
			x = x, 
			y = y, 
			width = width, 
			height = height, 
		}
		CBFS.db.window = savedata
	end

	tlw:SetAnchor(LEFT, ui.panel, RIGHT, 20, 0) -- forcibly reset ;p
	tlw:SetDimensions(400, 600) 				-- forcibly reset ;p
	CBFS_UI_PreviewWindowTitle:SetText(L(SI_CBFS_UI_PREVIEW_TITLE_COMMON))
	CBFS_UI_PreviewWindowBody:SetMaxInputChars(1000)
	CBFS_UI_PreviewWindowBody:SetText(L(SI_CBFS_UI_PREVIEW_BODY_COMMON) .. L(SI_CBFS_UI_PREVIEW_BODY_LOCALE))
	CBFS_UI_PreviewWindowMediumBg:SetTexture(ui.bookMediumTexture[uiBMID])

	tlw:SetHandler("OnMoveStop", OnMoveStop)
	tlw:SetHandler("OnResizeStop", OnResizeStop)
end

-- ---------------------------------------------------------


local function OnLAMPanelControlsCreated(panel)
	if (panel ~= ui.panel) then return end
	CALLBACK_MANAGER:UnregisterCallback("LAM-PanelControlsCreated", OnLAMControlsCreated)

	CBFS_UI_GameModeDisplay.desc:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
	SetupTLW()
	DoUpdateFontPreview()
end

local function OnLAMPanelClosed(panel)
	if (panel ~= ui.panel) then return end
--	CBFS.LDL:Debug("LAM-Panel Closed")
	CBFS_UI_PreviewWindow:SetHidden(true)
end

local function OnLAMPanelOpened(panel)
	if (panel ~= ui.panel) then return end
	CBFS.uiPreviewMode = false	-- force end of the CBFS preview mode.
--	CBFS.LDL:Debug("LAM-Panel Opened")
	CBFS_UI_PreviewWindow:SetHidden(false)
end

function CBFS.CreateSettingsWindow()

	InitializeUI()

	local panelData = {
		type = "panel", 
		name = "BookFont Stylist", 
		displayName = "Calamath's BookFont Stylist", 
		author = CBFS.author, 
		version = CBFS.version, 
		website = "https://www.esoui.com/downloads/info2505-CalamathsBookFontStylist.html", 
		slashCommand = "/cbfs.settings", 
		registerForRefresh = true, 
		registerForDefaults = true, 
		resetFunc = DoPanelDefaultMenu, 
	}
	ui.panel = LAM:RegisterAddonPanel("CBFS_OptionsMenu", panelData)

	local optionsData = {}
	optionsData[#optionsData + 1] = {
			type = "description", 
			title = "", 
			text = L(SI_CBFS_UI_PANEL_HEADER1_TEXT), 
	}
	optionsData[#optionsData + 1] = {
			type = "dropdown", 
			name = L(SI_CBFS_UI_BMID_SELECT_MENU_NAME), 
			tooltip = L(SI_CBFS_UI_BMID_SELECT_MENU_TIPS), 
			choices = ui.MediumChoices, 	-- If choicesValue is defined, choices table is only used for UI display!
			choicesValues = ui.MediumChoicesValues, 
			choicesTooltips = ui.MediumChoicesTooltips, 
			getFunc = function() return uiBMID end, 
			setFunc = DoChangeBMID, 
--			sort = "name-up", --or "name-down", "numeric-up", "numeric-down", "value-up", "value-down", "numericvalue-up", "numericvalue-down" 
			width = "half", 
--			scrollable = true, 
			default = BMID_YELLOWED_PAPER, 
	}
	optionsData[#optionsData + 1] = {
			type = "description", 
			title = L(SI_CBFS_UI_GAMEMODE_DISPLAY_NAME), 
			text = (uiIsGamepad and L(SI_CBFS_UI_GAMEMODE_GAMEPAD_NAME) or L(SI_CBFS_UI_GAMEMODE_KEYBOARD_NAME)) .. " - " .. zo_strupper(uiLang), 
			width = "half", 
			reference = "CBFS_UI_GameModeDisplay", 
	}
	optionsData[#optionsData + 1] = {
			type = "header", 
			name = ui.MediumChoices[uiBMID] .. " :", 
			reference = "CBFS_UI_TabHeader", 
	}
	optionsData[#optionsData + 1] = {
			type = "dropdown", 
			name = L(SI_CBFS_UI_BODYFONT_MENU_NAME), 
			tooltip = L(SI_CBFS_UI_BODYFONT_MENU_TIPS), 
			choices = ui.FontChoices, 
			choicesValues = ui.FontChoicesValues, 
			choicesTooltips = ui.FontChoicesTooltips, 
			getFunc = function() return CBFS.db.config[uiLang][uiPreset][uiBMID].bodyStyle end, 
			setFunc = DoChangeBodyFont, 
--			sort = "name-up", --or "name-down", "numeric-up", "numeric-down", "value-up", "value-down", "numericvalue-up", "numericvalue-down" 
			scrollable = 15, 
			default = function() return ui.defBodyFontMenu end, 
			reference = "CBFS_UI_BodyFontMenu", 
	}
	optionsData[#optionsData + 1] = {
			type = "slider", 
			name = L(SI_CBFS_UI_BODYSIZE_MENU_NAME), 
			tooltip = L(SI_CBFS_UI_BODYSIZE_MENU_TIPS), 
			min = 8,
			max = 40,
			step = 1, 
			getFunc = function() return CBFS.db.config[uiLang][uiPreset][uiBMID].bodySize end, 
			setFunc = DoChangeBodySize,
			clampInput = false, 
			default = function() return ui.defBodySizeMenu end, 
			reference = "CBFS_UI_BodySizeMenu", 
	}
	optionsData[#optionsData + 1] = {
			type = "dropdown", 
			name = L(SI_CBFS_UI_BODYWEIGHT_MENU_NAME), 
			tooltip = L(SI_CBFS_UI_BODYWEIGHT_MENU_TIPS), 
			choices = ui.WeightChoices, 
			choicesValues = ui.WeightChoicesValues, 
			choicesTooltips = ui.WeightChoicesTooltips, 
			getFunc = function() return CBFS.db.config[uiLang][uiPreset][uiBMID].bodyWeight end, 
			setFunc = DoChangeBodyWeight, 
--			sort = "name-up", --or "name-down", "numeric-up", "numeric-down", "value-up", "value-down", "numericvalue-up", "numericvalue-down" 
			default = function() return ui.defBodyWeightMenu end, 
			reference = "CBFS_UI_BodyWeightMenu", 
	}
	optionsData[#optionsData + 1] = {
			type = "checkbox", 
			name = L(SI_CBFS_UI_TITLEAUTO_MENU_NAME), 
			tooltip = L(SI_CBFS_UI_TITLEAUTO_MENU_TIPS), 
			getFunc = function() return CBFS.db.config[uiLang][uiPreset][uiBMID].titleAuto end,
			setFunc = DoChangeTitleAuto,
			default = function() return ui.defTitleAutoMenu end, 
			reference = "CBFS_UI_TitleAutoMenu", 
	}
	optionsData[#optionsData + 1] = {
			type = "dropdown", 
			name = L(SI_CBFS_UI_TITLEFONT_MENU_NAME), 
			tooltip = L(SI_CBFS_UI_TITLEFONT_MENU_TIPS), 
			choices = ui.FontChoices, 
			choicesValues = ui.FontChoicesValues, 
			choicesTooltips = ui.FontChoicesTooltips, 
			getFunc = function() return CBFS.db.config[uiLang][uiPreset][uiBMID].titleStyle end, 
			setFunc = DoChangeTitleFont, 
--			sort = "name-up", --or "name-down", "numeric-up", "numeric-down", "value-up", "value-down", "numericvalue-up", "numericvalue-down" 
			scrollable = 15, 
			disabled = function() return CBFS.db.config[uiLang][uiPreset][uiBMID].titleAuto end, 
			default = function() return ui.defTitleFontMenu end, 
			reference = "CBFS_UI_TitleFontMenu", 
	}
	optionsData[#optionsData + 1] = {
			type = "slider", 
			name = L(SI_CBFS_UI_TITLESIZE_MENU_NAME), 
			tooltip = L(SI_CBFS_UI_TITLESIZE_MENU_TIPS), 
			min = 8,
			max = 50,
			step = 1, 
			getFunc = function() return CBFS.db.config[uiLang][uiPreset][uiBMID].titleSize end, 
			setFunc = DoChangeTitleSize,
			disabled = function() return CBFS.db.config[uiLang][uiPreset][uiBMID].titleAuto end, 
			clampInput = false, 
			default = function() return ui.defTitleSizeMenu end, 
			reference = "CBFS_UI_TitleSizeMenu", 
	}
	optionsData[#optionsData + 1] = {
			type = "dropdown", 
			name = L(SI_CBFS_UI_TITLEWEIGHT_MENU_NAME), 
			tooltip = L(SI_CBFS_UI_TITLEWEIGHT_MENU_TIPS), 
			choices = ui.WeightChoices, 
			choicesValues = ui.WeightChoicesValues, 
			choicesTooltips = ui.WeightChoicesTooltips, 
			getFunc = function() return CBFS.db.config[uiLang][uiPreset][uiBMID].titleWeight end, 
			setFunc = DoChangeTitleWeight, 
--			sort = "name-up", --or "name-down", "numeric-up", "numeric-down", "value-up", "value-down", "numericvalue-up", "numericvalue-down" 
			disabled = function() return CBFS.db.config[uiLang][uiPreset][uiBMID].titleAuto end, 
			default = function() return ui.defTitleWeightMenu end, 
			reference = "CBFS_UI_TitleWeightMenu", 
	}
	optionsData[#optionsData + 1] = {
			type = "button", 
			name = L(SI_CBFS_UI_LOAD_DEFAULT_FONT_NAME), 
			tooltip = L(SI_CBFS_UI_LOAD_DEFAULT_FONT_TIPS), 
			func = DoResetCurrentTab, 
			width = "half", 
	}
	optionsData[#optionsData + 1] = {
			type = "button", 
			name = L(SI_CBFS_UI_SHOW_READER_WND_NAME), 
			tooltip = L(SI_CBFS_UI_SHOW_READER_WND_TIPS), 
			func = DoPreviewButton, 
			width = "half", 
	}
	optionsData[#optionsData + 1] = {
			type = "description", 
			title = "", 
			text = "There is no error", 
			reference = "CBFS_UI_ErrorMessageDisplay", 
	}
--[[
	optionsData[#optionsData + 1] = {
			type = "divider",
			height = 3, 
			alpha = 0.25, 
	}
]]
--[[ cbfs082 sta
	optionsData[#optionsData + 1] = {
			type = "description", 
			title = "Preview : ", 
			text = "The quick brown fox jumps over the lazy dog.\n1234567890", 
			reference = "CBFS_UI_FontPreview", )
	}
cbfs082 end ]]

	LAM:RegisterOptionControls("CBFS_OptionsMenu", optionsData)

	CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", OnLAMPanelControlsCreated)
	CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", OnLAMPanelClosed)
	CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", OnLAMPanelOpened)

--	CBFS.LDL:Debug("Initalize LAM panel")
	return ui.panel
end
