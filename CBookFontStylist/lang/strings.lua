local strings = {
	SI_CBFS_BMID_YELLOWED_PAPER_NAME =	"Yellowed Paper Book",	-- "Yellowed Paper"
	SI_CBFS_BMID_ANIMAL_SKIN_NAME = 	"Animal Skin Book", 	-- "Animal Skin"
	SI_CBFS_BMID_RUBBING_PAPER_NAME =	"Rubbing Book", 		-- "Rubbing Paper"
	SI_CBFS_BMID_LETTER_NAME =			"Letter",				-- "Letter"
	SI_CBFS_BMID_NOTE_NAME =			"Note", 				-- "Note"
	SI_CBFS_BMID_SCROLL_NAME =			"Scroll",				-- "Scroll"
	SI_CBFS_BMID_STONE_TABLET_NAME =	"Stone Tablet", 		-- "Stone Tablet"
	SI_CBFS_BMID_METAL_NAME =			"Dwemer Book",			-- "Metal"
	SI_CBFS_BMID_METAL_TABLET_NAME =	"Dwemer Page",			-- "Metal Tablet"
	SI_CBFS_BMID_ANTIQUITY_CODEX_NAME =	"Antiquity Codex",		-- "Antiquity Codex"

	SI_CBFS_BMID_YELLOWED_PAPER_TIPS =	"Yellowed Paper",	-- tooltip for book medium "Yellowed Paper" if you want to add a description in your localization
	SI_CBFS_BMID_ANIMAL_SKIN_TIPS = 	"Animal Skin",		-- tooltip for book medium "Animal Skin" if you want to add a description in your localization
	SI_CBFS_BMID_RUBBING_PAPER_TIPS =	"Rubbing Paper",	-- tooltip for book medium "Rubbing Paper" if you want to add a description in your localization
	SI_CBFS_BMID_LETTER_TIPS =			"Letter",			-- tooltip for book medium "Letter" if you want to add a description in your localization
	SI_CBFS_BMID_NOTE_TIPS =			"Note", 			-- tooltip for book medium "Note" if you want to add a description in your localization
	SI_CBFS_BMID_SCROLL_TIPS =			"Scroll",			-- tooltip for book medium "Scroll" if you want to add a description in your localization
	SI_CBFS_BMID_STONE_TABLET_TIPS =	"Stone Tablet", 	-- tooltip for book medium "Stone Tablet" if you want to add a description in your localization
	SI_CBFS_BMID_METAL_TIPS =			"Metal Book",		-- tooltip for book medium "Metal Book" if you want to add a description in your localization
	SI_CBFS_BMID_METAL_TABLET_TIPS =	"Metal Tablet", 	-- tooltip for book medium "Metal Tablet" if you want to add a description in your localization
	SI_CBFS_BMID_ANTIQUITY_CODEX_TIPS =	"Antiquity Codex", 	-- tooltip for book medium "Antiquity Codex" if you want to add a description in your localization

	SI_CBFS_WEIGHT_NORMAL_NAME				= "normal", 
	SI_CBFS_WEIGHT_SHADOW_NAME				= "shadow", 
	SI_CBFS_WEIGHT_OUTLINE_NAME 			= "outline", 
	SI_CBFS_WEIGHT_THICK_OUTLINE_NAME		= "thick-outline", 
	SI_CBFS_WEIGHT_SOFT_SHADOW_THIN_NAME	= "soft-shadow-thin", 
	SI_CBFS_WEIGHT_SOFT_SHADOW_THICK_NAME	= "soft-shadow-thick", 

	SI_CBFS_WEIGHT_NORMAL_TIPS				= "normal", 			-- tooltip for font weight "normal" if you want to add a description in your localization
	SI_CBFS_WEIGHT_SHADOW_TIPS				= "shadow", 			-- tooltip for font weight "shadow" if you want to add a description in your localization
	SI_CBFS_WEIGHT_OUTLINE_TIPS 			= "outline",			-- tooltip for font weight "outline" if you want to add a description in your localization
	SI_CBFS_WEIGHT_THICK_OUTLINE_TIPS		= "thick-outline",		-- tooltip for font weight "thick-outline" if you want to add a description in your localization
	SI_CBFS_WEIGHT_SOFT_SHADOW_THIN_TIPS	= "soft-shadow-thin",	-- tooltip for font weight "soft-shadow-thin" if you want to add a description in your localization
	SI_CBFS_WEIGHT_SOFT_SHADOW_THICK_TIPS	= "soft-shadow-thick",	-- tooltip for font weight "soft-shadow-thick" if you want to add a description in your localization

	SI_CBFS_UI_PANEL_HEADER_TEXT =		"This add-on allows you to adjust the typeface of several in-game reading materials, lore book etc.", 
	SI_CBFS_UI_PANEL_HEADER1_TEXT = 	"These account-wide settings are saved for each language mode.", 
	SI_CBFS_UI_PANEL_HEADER2_TEXT = 	"And also separetely saved depending on whether in gamepad mode or not.", 
	SI_CBFS_UI_E1001_ERRMSG_TEXT =		"|cdc143cYour saved font settings are currently unavailable. Make sure related add-on is not disabled or deleted, updating font add-on may have caused deleting font files you copied manually.|r", 
	SI_CBFS_UI_BMID_SELECT_MENU_NAME =	"Select Book Medium", 
	SI_CBFS_UI_BMID_SELECT_MENU_TIPS =	"First, please select the type of book medium you want to configure.", 
	SI_CBFS_UI_GAMEMODE_DISPLAY_NAME =	"Game Mode : ", 
	SI_CBFS_UI_GAMEMODE_DISPLAY_TIPS =	"You can set prefered font styles individually for each game mode.", 
	SI_CBFS_UI_GAMEMODE_KEYBOARD_NAME = "Keyboard Mode", 
	SI_CBFS_UI_GAMEMODE_GAMEPAD_NAME =	"Gamepad Mode", 
	SI_CBFS_UI_BODYFONT_MENU_NAME = 	"Body Font", 
	SI_CBFS_UI_BODYFONT_MENU_TIPS = 	"Specify your prefered font style.", 
	SI_CBFS_UI_BODYSIZE_MENU_NAME = 	"Body Font Size", 
	SI_CBFS_UI_BODYSIZE_MENU_TIPS = 	"Specify your prefered font size.", 
	SI_CBFS_UI_BODYWEIGHT_MENU_NAME =	"Body Font Weight", 
	SI_CBFS_UI_BODYWEIGHT_MENU_TIPS =	"Specify your prefered font weight.", 
	SI_CBFS_UI_TITLEAUTO_MENU_NAME =	"Title Font Auto Adjustment", 
	SI_CBFS_UI_TITLEAUTO_MENU_TIPS =	"As the title font, use 10 points larger than above body font.", 
	SI_CBFS_UI_TITLEFONT_MENU_NAME =	"Title Font", 
	SI_CBFS_UI_TITLEFONT_MENU_TIPS =	"Specify your prefered font style.", 
	SI_CBFS_UI_TITLESIZE_MENU_NAME =	"Title Font Size", 
	SI_CBFS_UI_TITLESIZE_MENU_TIPS =	"Specify your prefered font size.", 
	SI_CBFS_UI_TITLEWEIGHT_MENU_NAME =	"Title Font Weight", 
	SI_CBFS_UI_TITLEWEIGHT_MENU_TIPS =	"Specify your prefered font weight.", 
	SI_CBFS_UI_LOAD_DEFAULT_FONT_NAME = "Default Font", 
	SI_CBFS_UI_LOAD_DEFAULT_FONT_TIPS = "Restore settings on this medium to the in-game default font. The default font depends on whether you are in gamepad mode.", 
	SI_CBFS_UI_SHOW_READER_WND_NAME =	"Preview", 
	SI_CBFS_UI_SHOW_READER_WND_TIPS =	"Preview your book font settings", 

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
--	Please do not translate the following two, these are to preview the display of alphabet !!
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
	SI_CBFS_UI_PREVIEW_TITLE_COMMON =	"Book Title", 
	SI_CBFS_UI_PREVIEW_BODY_COMMON =	"five dancing skooma cats jump quickly to the wizard's box.\nABCDEFGHIJKLMNOPQRSTUVWXYZ\n1234567890\n\n", 

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
--	The following does not require translation. Instead, you are free to write something like a pangram that is useful for checking fonts in your language.
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
	SI_CBFS_UI_PREVIEW_BODY_LOCALE =	"Six big juicy steaks sizzled in a pan as five workmen left the quarry.\n\n", 

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
--	The following two are the title and text of the 'dummy' book using on the Lore Reader preview screen. 
--	You (translator) can replace these texts with something else in your language, but please take care never cause any copyright problems.
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
	SI_CBFS_UI_PREVIEW_BOOK_TITLE = 	"Lorem Ipsum", 
	SI_CBFS_UI_PREVIEW_BOOK_BODY =		"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
}


for stringId, stringToAdd in pairs(strings) do
   ZO_CreateStringId(stringId, stringToAdd)
   SafeAddVersion(stringId, 1)
end
