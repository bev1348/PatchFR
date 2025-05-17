log("> CHARGEMENT DU FICHIER : mods-list.lua")
local modsList = require('prototypes.mods-list')
local prototypes_list = require('prototypes.prototypes-list')
-----------------------------------------------------------
local CommuPrototype = require("classes.CommuPrototype")

-- fonction de setter des localised_name et localised_description
local function localizationPrototype(prototype_type, localization)
    
    if localization[prototype_type] ~= nil then 
        --log("> prototype_type: " .. prototype_type)
        for name, locale in pairs(localization[prototype_type]) do 
            local status = pcall(function()
                CommuPrototype(name, prototype_type):setLocalisedName(locale)
            end)
            --[[ if status == false then 
                log('> erreur sur la localisation (localised_name) => type: '.. prototype_type ..' - name: '..name)
            end ]]
        end
    end

    if localization[prototype_type.."-name"] ~= nil then 
        log("> prototype_type (name):  " .. prototype_type .."-name")
        for name, locale in pairs(localization[prototype_type.."-name"]) do 
            local status = pcall(function()
                CommuPrototype(name, prototype_type):setLocalisedName(locale)
            end)
            if status == false then 
                log('> Erreur sur la localisation (localised_name) => type: '.. prototype_type ..' - name: '..name)
            end
        end
    end


    if localization[prototype_type.."-description"] ~= nil then 
        for name, locale in pairs(localization[prototype_type.."-description"]) do 
            local status = pcall(function()
                CommuPrototype(name, prototype_type):setLocalisedDescription(locale)
            end)
            if status == false then 
                log('> erreur sur la localisation (localised_description) => type: '.. prototype_type ..' - name: '..name)
            end
        end
    end
end

-- boucle sur tous les fichiers de localisation lua se trouvant dans le dossiers mods et dans la mods_list.
for _,mod_name in pairs(modsList) do
    if mods[mod_name] then       -- !!!!!!!!!!!!!! REMETTRE CETTE LIGNE APRÈS LES TESTS    !!!!!!!!!!!!!!!
    --if true then                 -- !!!!!!!!!!!!!! À UTILISER UNIQUEMENT PENDANT LES TESTS !!!!!!!!!!!!!!!
        
        log("> le mod suivant est actif : " .. mod_name)
        local localization = require("mods." .. mod_name)

        for _, prototype_type in pairs(prototypes_list) do 
            -- lance la fonction de remplacement des localisations
            localizationPrototype(prototype_type, localization)
        end

    end
end

log("> FIN du chargement des traductions")