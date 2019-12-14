local strings = {
    SI_LCFM_FONTSTYLE_TIPS_ZOSFONT =    "This is the official ESO UI font.", 
    SI_LCFM_FONTSTYLE_TIPS_ADDONFONT =  "This font is bundled with the add-on '<<1>>'", 
}

for stringId, stringToAdd in pairs(strings) do
   ZO_CreateStringId(stringId, stringToAdd)
   SafeAddVersion(stringId, 1)
end
