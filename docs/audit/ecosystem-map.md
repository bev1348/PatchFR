# Écosystème Factorio — carte PatchFR (interne au mod, hors-stack)

> ⚠ **Carte INTERNE au mod** — produite lors de l'audit de PatchFR. **Décision de Ritn (2026-07-12,
> décision 1b) : NE PAS fusionner dans le canonique `W:\git\Factorio\ecosystem-map.md`.** PatchFR
> n'appartient pas à l'écosystème Ritn (auteur `bev`, aucune dépendance à RitnLib/RitnCoreGame) et la
> règle réserve le registre canonique aux mods de Ritn. Cette carte **reste ici** (`PatchFR/docs/audit/`)
> et sert de **matière aux skills 2 (annotations) et 3 (documentation)**.
>
> PatchFR est un mod **autonome que Ritn co-maintient au niveau du code** — **PAS** un maillon de la
> chaîne d'extensions Ritn. Entrée marquée `hors-stack` ci-dessous.
>
> **Portée** : faits vérifiés par lecture de code / grep pendant l'audit PatchFR `2.0.20` (2026-07-12).
> Repos mirrorés sous `C:\Users\ritn\Documents\GitHub\` sur ce poste (équivalent local de
> `W:\git\Factorio\`, où PatchFR vit aussi).

## Registre des mods

> ⚠ Entrée `hors-stack` **non reportée au registre canonique** (décision 1b). Reste locale à cette carte.

| Mod | Chemin (poste principal) | Traits | Rôle en une ligne | Audité | Annoté | Documenté |
|---|---|---|---|---|---|---|
| PatchFR `(hors-stack)` | `W:\git\Factorio\PatchFR` | data-patcher + locale provider (passif runtime) — **autonome, non-Ritn** | Traduction FR de 500+ mods via `.cfg` natifs + patchs de prototypes `data.raw` | **oui (2026-07-12)** | **oui (2026-07-12, FR seul)** | non |

## Graphe des relations

- **PatchFR est autonome** : **aucune** relation avec la chaîne Ritn (`RitnLib → RitnCoreGame → …`).
  Vérifié — rien n'est `require`é hors de son propre arbre ; dépendance unique `base >= 2.0`
  (`PatchFR/info.json`). Ni provider, ni consumer d'interface remote ; aucun héritage inter-mod.
- **Écho de convention (sans dépendance)** : `PatchFR/core/class.lua` est une **copie vendorée** de la
  factory `newclass` de RitnLib (`RitnLib/core/class.lua:24`) — même algorithme (copie superficielle du
  parent, `_super`, `__call` constructeur, `:is_a()`). PatchFR la **réimplémente localement pour rester
  indépendant** de RitnLib, sans les annotations LuaLS ni la variante dépréciée `new`. C'est un **partage
  de patron, pas un lien de dépendance**.

> Aucune arête vers/depuis le stack Ritn : PatchFR est un îlot dans la carte.

## Conventions partagées observées (multi-mods)

> N'ajouter au canonique que si confirmé dans plusieurs mods. Pertinent ici :

- **Factory de classes `newclass(super?, init)`** (copie superficielle, `_super`, `:is_a()`) : définie
  dans **RitnLib** (`core/class.lua`), **vendorée à l'identique dans PatchFR** (`core/class.lua`).
  → Confirme que ce patron circule au-delà du stack Ritn, y compris par recopie délibérée dans un mod
  indépendant. (Les autres conventions Ritn — `ritnlib.defines.*`, event listener, persistance déléguée
  remote — **ne s'appliquent PAS** à PatchFR : il est data-stage pur.)

## Modèle de format

**RitnLib** — reste la référence de style pour audits/annotations/docs. (Inchangé par ce fragment.)

## Fiches par mod

### PatchFR *(hors-stack — co-maintenu par Ritn, auteur `bev`)*
- **Profil réel** : **data-patcher + locale provider**, passif au runtime. `factorio_version` `2.0`.
  Dépendance unique : `base >= 2.0`. Auteur `bev` (dépôt `github.com/bev1348/PatchFR`).
- **Spécificités propres** :
  - **Data-stage pur** : seul entrypoint `data-final-fixes.lua`. Aucun `control.lua`, aucun `storage`/
    `global`, aucun `script.on_event`/`on_nth_tick`, aucune interface remote, aucune migration, aucun GUI.
  - **Deux voies de traduction indépendantes** : (1) `locale/fr/*.cfg` (596 fichiers) chargés nativement
    par le moteur — aucun code ; (2) patchs Lua `mods/<mod>.lua` (106 fichiers) via la classe
    **`CommuPrototype`** qui pose `localised_name`/`localised_description` sur `data.raw` — pour les cas
    hors portée du `.cfg` (noms dynamiques, technos à niveaux, variantes `-N`).
  - **Autonomie assumée** : factory de classe vendorée (cf. graphe), aucune dépendance à RitnLib.
  - Défauts qualifiés : `tryCatch` non défini (latent, non exercé) ; cluster `localisedBuilder*` (code
    inachevé/mort) ; boucle à niveaux de `setLocalisedDescription` (à vérifier). Détail dans le handoff.
- **Renvois** : `PatchFR/docs/architecture.md`, `PatchFR/docs/audit/handoff.md`.
- **Questions ouvertes** : voir handoff §D (inscription au registre canonique à trancher ; intention de
  `tryCatch` ; sort du cluster `localisedBuilder*` ; comportement de la description à niveaux ; type-alias
  `mods/`).
