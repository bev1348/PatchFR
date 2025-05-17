return {
    ---------------
    --ammo-loader.cfg
    ["controls"] = {
        ["ammo-loader-key-reset"]="Recontrôler toutes les entités",
        ["ammo-loader-key-return"]="Restituer tous les objets",
        ["ammo-loader-key-filter-window"]="Ouvrir les options de l'entité",
        ["ammo-loader-key-toggle-chest-ranges"]="Activer la vue de la portée des coffres",
        ["ammo-loader-key-toggle-enabled"]="Activer/désactiver",
        ["ammo-loader-key-e"]="Touche d'acceptation dans l'interface graphique",
        ["ammo-loader-key-escape"]="Touche de fermeture dans l'interface graphique",
    },
    ["controls-description"] = {
        ["ammo-loader-key-reset"]="Déclenchez la réinitialisation complète de la table interne et revérifiez toutes les entités.",
        ["ammo-loader-key-return"]="Tenter de renvoyer tous les objets dans des coffres de stockage (Coffre de stockage des chargeurs). Il doit y avoir des coffres avec de l'espace libre à portée.",
        ["mmo-loader-key-filter-window"]="En appuyant sur cette touche tout en passant la souris sur un coffre/entité, l'interface graphique du mod s'ouvrira pour cette entité.",
        ["ammo-loader-key-toggle-chest-ranges"]="Dessiner toutes les portées des coffres comme des périmètres. Activer et désactiver. Caractéristique expérimentale.",
        ["ammo-loader-key-toggle-enabled"]="Activez ou désactivez le mod.",
        ["ammo-loader-key-e"]="Touche utilisée pour accepter et fermer les fenêtres de l'interface graphique. Devrait être la même que celle de la base de Factorio (par défaut E).",
        ["ammo-loader-key-escape"]="Touche utilisée pour fermer normalement les interfaces graphiques. Devrait être la même que celle de la base de Factorio.",
    },
    ["entity-name"] = {
        ["ammo-loader-chest"]="Chargeur de munitions - Coffre ouvrier",
        ["ammo-loader-chest-storage"]="Chargeur de munitions - Coffre de stockage logistique",
        ["ammo-loader-chest-requester"]="Chargeur de munitions - Coffre de demandes logistiques",
        ["ammo-loader-chest-passive-provider"]="Chargeur de munitions - Coffre d'approvisionnement logistique passif",
    },
    ["entity-description"] = {
        ["ammo-loader-chest"]="Chargeur de munitions de base qui permettra de remplir les tourelles et autres entités en munitions.",
        ["ammo-loader-chest-requester"]="Fonctionne à la fois comme un coffre de chargeur de munitions et comme un coffre de demandes logistiques.",
        ["ammo-loader-chest-storage"]="Stocke les munitions, permet aux coffres d'améliorer les munitions lorsque l'emplacement est déjà plein.",
        ["ammo-loader-chest-passive-provider"]="Fonctionne à la fois comme un coffre de chargeur de munitions et comme un coffre d'approvisionnement logistique passif.",
    },
    ["item-name"] = {
        ["ammo-loader-chest"]="Chargeur de munitions - Coffre ouvrier",
        ["ammo-loader-chest-storage"]="Chargeur de munitions - Coffre de stockage logistique",
        ["ammo-loader-chest-requester"]="Chargeur de munitions - Coffre de demandes logistiques",
        ["ammo-loader-chest-passive-provider"]="Chargeur de munitions - Coffre d'approvisionnement logistique passif",
        ["ammo-loader-cartridge-prefix"]="Chargeur de cartouches :",
    },
    ["item-description"] = {
        ["ammo-loader-chest"]="Un coffre qui permet de charger automatiquement les tourelles et les véhicules avec les munitions qu'il contient (mod Ammo-Loader).",
        ["ammo-loader-chest-requester"]="Un coffre de chargement amélioré qui joue le rôle de demandeur logistique (mod Ammo-Loader).",
        ["ammo-loader-chest-passive-provider"]="Fonctionne à la fois comme un coffre de chargeur de munitions et comme un coffre d'approvisionnement logistique passif.",
        ["ammo-loader-cartridge"]="Une cargaison de munitions préemballée prête à être distribuée. Compatible avec les coffres de chargement de munitions.",
    },
    ["recipe-name"] = {
        ["ammo-loader-chest"]="Chargeur de munitions - Coffre ouvrier",
        ["ammo-loader-chest-storage"]="Chargeur de munitions - Coffre de stockage logistique",
        ["ammo-loader-chest-requester"]="Chargeur de munitions - Coffre de demandes logistiques",
        ["ammo-loader-chest-passive-provider"]="Chargeur de munitions - Coffre d'approvisionnement logistique passif",
        ["ammo-loader-cartridge-prefix"]="Chargeur de cartouches :",
    },
    ["recipe-description"] = {
        ["ammo-loader-chest"]="Un coffre qui permet de charger automatiquement les tourelles et les véhicules avec les munitions qu'il contient (mod Ammo-Loader).",
        ["ammo-loader-chest-requester"]="Un coffre de chargement amélioré qui joue le rôle de demandeur logistique (mod Ammo-Loader).",
        ["ammo-loader-chest-passive-provider"]="Fonctionne à la fois comme un coffre de chargeur de munitions et comme un coffre d'approvisionnement logistique passif.",
        ["ammo-loader-cartridge"]="Une cargaison de munitions préemballée prête à être distribuée. Compatible avec les coffres de chargement de munitions.",
    },
    ["technology-name"] = {
        ["ammo-loader-tech-loader-chest"]="Chargeur de munitions",
        ["ammo-loader-tech-requester-chest"]="Chargeur de munitions : Intégration logistique",
        ["ammo-loader-tech-vehicles"]="Chargeur de munitions : Véhicules",
        ["ammo-loader-tech-burners"]="Chargeur de munitions : Combustible",
        ["ammo-loader-tech-artillery"]="Chargeur de munitions : Artillerie",
        ["ammo-loader-tech-upgrade"]="Chargeur de munitions : Amélioration",
        ["ammo-loader-tech-return-items"]="Chargeur de munitions : Restitution des objets",
    },
    ["technology-description"] = {
        ["ammo-loader-tech-loader-chest"]="Grâce à une conception innovante des armes et à une coordination logistique minutieuse, vous avez découvert des moyens de faciliter la distribution des munitions.",
        ["ammo-loader-tech-requester-chest"]="Une modification des coffres de chargement vous a permis d'intégrer une interface logistique à la conception.",
        ["ammo-loader-tech-burners"]="Après de nombreux efforts, vous avez découvert que le système de distribution de munitions existant peut être étendu pour fournir également du combustible.",
        ["ammo-loader-tech-artillery"]="Grâce à des recherches avancées en logistique, vous avez découvert comment les coffres de chargement peuvent être utilisés pour approvisionner les tourelles et les wagons d'artillerie.",
        ["ammo-loader-tech-upgrade"]="La hiérarchisation et l'organisation des dépôts d'approvisionnement existants permettent désormais de mettre automatiquement à niveau les munitions dans les avant-postes existants.",
        ["ammo-loader-tech-return-items"]="Le déblocage des lignes de ravitaillement en munitions dans les deux sens a permis de réapprovisionner facilement les avant-postes obsolètes.",
    },
    ["item-group-name"] = {
        ["ammo-loader-cartridge-group"]="Chargeur de cartouches",
    },
    ["tips-and-tricks-item-name"] = {
        ["ammo-loader-tip-introduction"]="[img=ammo-loader-sprite-entity-basic-loader-chest-old] Ammo Loader+",
    },
    ["tips-and-tricks-item-description"] = {
    }
    -------------------------
}
