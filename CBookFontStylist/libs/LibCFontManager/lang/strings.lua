local strings = {
	SI_LCFM_FONTSTYLE_TIPS_ZOSFONT =		"The ESO embedded font.", 
	SI_LCFM_FONTSTYLE_TIPS_ADDONFONT =		"redistributed by add-on '<<1>>'", 

	SI_LCFM_FONTNAME_UNIVERS55 =			"Univers LT Std 55", 
	SI_LCFM_FONTNAME_UNIVERS57 =			"Univers LT Std 57 Cn", 
	SI_LCFM_FONTNAME_UNIVERS67 =			"Univers LT Std 67 Bold Cn", 
	SI_LCFM_FONTNAME_FTN47 =				"Futura PT Cond Book", 
	SI_LCFM_FONTNAME_FTN57 =				"Futura PT Cond Medium", 
	SI_LCFM_FONTNAME_FTN87 =				"Futura PT Cond Bold", 
	SI_LCFM_FONTNAME_HANDWRITTEN_BOLD = 	"SkyrimBooks Handwritten Bold", 
	SI_LCFM_FONTNAME_PROSEANTIQUEPSMT = 	"ProseAntique", 
	SI_LCFM_FONTNAME_TRAJANPRO_REGULAR =	"Trajan Pro Regular", 
	SI_LCFM_FONTNAME_CONSOLA =				"Consolas", 
	SI_LCFM_FONTNAME_ESO_FWNTLGUDC70_DB =	"ESO-FWNTLGUDC70 DB", 
	SI_LCFM_FONTNAME_ESO_FWUDC_70_M =		"ESO-FWUDC_70 M", 
	SI_LCFM_FONTNAME_ESO_KAFUPENJI_M =		"ESO-KafuPenjitai M", 
	SI_LCFM_FONTNAME_UNIVERS57_CYR =		"Univers LT Cyrillic 57 Cn", 
	SI_LCFM_FONTNAME_UNIVERS67_CYR =		"Univers LT Cyrillic 67 Bold Cn", 
	SI_LCFM_FONTNAME_HANDWRITTEN_CYR_BOLD =	"SkyrimBooks Handwritten Cyrillic Bold", 
	SI_LCFM_FONTNAME_PROSEANTIQUEPSMT_CYR = "ProseAntique Cyrillic", 
	SI_LCFM_FONTNAME_TRAJANPRO_CYR_R =		"Goudy Trajan Medium", 
	SI_LCFM_FONTNAME_MYINGHEIPRC_W5 =		"M Ying Hei PRC W5", 
	SI_LCFM_FONTNAME_MYOYOPRC_M =			"M Yoyo PRC Medium", 
}

for stringId, stringToAdd in pairs(strings) do
   ZO_CreateStringId(stringId, stringToAdd)
   SafeAddVersion(stringId, 1)
end
