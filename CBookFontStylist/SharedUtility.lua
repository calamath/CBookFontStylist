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

local bookMediumTexture = {
	[BMID_YELLOWED_PAPER]	= "EsoUI/Art/LoreLibrary/loreLibrary_paperBook.dds", 
	[BMID_ANIMAL_SKIN]		= "EsoUI/Art/LoreLibrary/loreLibrary_skinBook.dds", 
	[BMID_RUBBING_PAPER]	= "EsoUI/Art/LoreLibrary/loreLibrary_rubbingBook.dds", 
	[BMID_LETTER]			= "EsoUI/Art/LoreLibrary/loreLibrary_letter.dds", 
	[BMID_NOTE] 			= "EsoUI/Art/LoreLibrary/loreLibrary_note.dds", 
	[BMID_SCROLL]			= "EsoUI/Art/LoreLibrary/loreLibrary_scroll.dds", 
	[BMID_STONE_TABLET] 	= "EsoUI/Art/LoreLibrary/loreLibrary_stoneTablet.dds", 
	[BMID_METAL]			= "EsoUI/Art/LoreLibrary/loreLibrary_dwemerBook.dds", 
	[BMID_METAL_TABLET] 	= "EsoUI/Art/LoreLibrary/loreLibrary_dwemerPage.dds", 
	[BMID_ANTIQUITY_CODEX] 	= "EsoUI/Art/Antiquities/codex_document.dds", 
}
local function GetBookMediumTexture(bmid)
	return bookMediumTexture[bmid] or bookMediumTexture[BMID_YELLOWED_PAPER]
end
CBFS:RegisterSharedObject("GetBookMediumTexture", GetBookMediumTexture)


local zosBookMedium_To_BMID = {
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
local function GetBMID(zosBookMedium)
	return zosBookMedium_To_BMID[zosBookMedium] or zosBookMedium_To_BMID[BOOK_MEDIUM_YELLOWED_PAPER]
end
CBFS:RegisterSharedObject("GetBMID", GetBMID)


-- This table is equivalent to an enumeration of book medium IDs managed by CBFS add-on.
local bookMediumFont = {
	[BMID_YELLOWED_PAPER] = {
		keyboard = {
			body	= "ZoFontBookPaper", 
			title	= "ZoFontBookPaperTitle", 
		}, 
		gamepad = {
			body	= "ZoFontGamepadBookPaper", 
			title	= "ZoFontGamepadBookPaperTitle", 
		}, 
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
	}, 
}
local function GetBookMediumBodyFont(bmid, isGamepad)
	if isGamepad then
		return bookMediumFont[bmid].gamepad.body or bookMediumFont[BMID_YELLOWED_PAPER].gamepad.body
	else
		return bookMediumFont[bmid].keyboard.body or bookMediumFont[BMID_YELLOWED_PAPER].keyboard.body
	end
end
CBFS:RegisterSharedObject("GetBookMediumBodyFont", GetBookMediumBodyFont)

local function GetBookMediumTitleFont(bmid, isGamepad)
	if isGamepad then
		return bookMediumFont[bmid].gamepad.title or bookMediumFont[BMID_YELLOWED_PAPER].gamepad.title
	else
		return bookMediumFont[bmid].keyboard.title or bookMediumFont[BMID_YELLOWED_PAPER].keyboard.title
	end
end
CBFS:RegisterSharedObject("GetBookMediumTitleFont", GetBookMediumTitleFont)

local function BookMediumIdIterator()
	local nextKey = next(bookMediumFont)
	return function()
		while nextKey do
			local currentKey = nextKey
			nextKey = next(bookMediumFont, nextKey)
			return currentKey
		end
	end
end
CBFS:RegisterSharedObject("BookMediumIdIterator", BookMediumIdIterator)

