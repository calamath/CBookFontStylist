local strings = {
	SI_LCFM_FONTSTYLE_TIPS_ZOSFONT =		"The ESO embedded font.", 
	SI_LCFM_FONTSTYLE_TIPS_ADDONFONT =		"redistributed by add-on '<<1>>'", 

	SI_LCFM_FONTNAME_UNIVERS55 =			"Univers LT Std 55", 
	SI_LCFM_FONTNAME_UNIVERS57 =			"Univers LT Std 57 Cn", 
	SI_LCFM_FONTNAME_UNIVERS67 =			"Univers LT Std 47 Cn Lt", 
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
}

for stringId, stringToAdd in pairs(strings) do
   ZO_CreateStringId(stringId, stringToAdd)
   SafeAddVersion(stringId, 1)
end
