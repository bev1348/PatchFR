---
title: Architecture interne PatchFR
audience: mainteneur
status: living
last_review: 2026-07-12
pinned_version: 2.0.20
---

# Architecture interne — PatchFR

> Document interne mainteneur. Vue d'ensemble de la structure du **code** (pas des traductions), des
> dépendances et des choix de conception. Mis à jour à chaque refactor structurel — section
> « Historique » en bas.
>
> Périmètre volontaire : ce document couvre **le cœur `CommuPrototype` et le flux data-stage**. Les
> 596 fichiers `locale/fr/*.cfg` (traductions natives moteur) sont des **données**, hors périmètre de
> cette page. Un guide séparé destiné au traducteur (fonctionnement des `.cfg` et de leurs équivalents
> `.lua`) est prévu ultérieurement.

## 1. Identité

| Aspect | Valeur |
|---|---|
| Type de mod | **Data-patcher + locale provider** — passif au runtime, modifie `data.raw` au chargement |
| factorio_version | `2.0` |
| Dépendances | `base >= 2.0` uniquement ([info.json](https://github.com/bev1348/PatchFR/blob/main/info.json)) |
| Auteur | `bev` — mod **autonome**, sans dépendance à RitnLib / RitnCoreGame ni à aucun autre mod Ritn |
| Rôle | Fournir la traduction française de 500+ mods, par deux voies : `.cfg` natifs + patchs `.lua` de prototypes |

**Absences structurelles** (caractéristiques de conception, pas des manques) : aucun `control.lua`,
aucun stage `data`/`data-updates`/`settings`, aucun `script.on_event`, aucun `on_nth_tick`, aucun
`remote.add_interface`, aucun `storage`/`global`, aucune migration, aucune commande, aucun GUI.
Le seul point d'entrée exécuté est [data-final-fixes.lua](https://github.com/bev1348/PatchFR/blob/main/data-final-fixes.lua).

## 2. Vue d'ensemble en couches

```
                    ┌─────────────────────────────────────────────┐
   MOTEUR FACTORIO  │  locale/fr/*.cfg  (596 fichiers)            │  ← voie native, hors code
   (chargement)     │  chargés automatiquement, aucun code Lua    │
                    └─────────────────────────────────────────────┘

                    ┌─────────────────────────────────────────────┐  ← voie programmatique (LE code)
   DATA STAGE       │  data-final-fixes.lua        ENTRYPOINT     │
   (data-final-     │      │                                      │
    fixes)          │      ├── prototypes/mods-list.lua   (liste) │
                    │      ├── prototypes/prototypes-list.lua     │
                    │      ├── mods/<mod>.lua  (×106, tables trad)│
                    │      │                                      │
                    │      └── classes/CommuPrototype.lua  ◄─ CŒUR│
                    │              │                              │
                    │              ├── core/class.lua      (OOP)  │
                    │              ├── core/functions.lua  (utils)│
                    │              ├── core/types_entity.lua      │
                    │              ├── core/types_item.lua        │
                    │              └── core/types_equipment.lua   │
                    └─────────────────────────────────────────────┘
```

Les deux voies sont **indépendantes** : les `.cfg` couvrent la majorité des mods ; les patchs `.lua`
prennent le relais quand un `.cfg` ne peut pas fonctionner (nom posé dynamiquement sur le prototype,
technos à niveaux / recherche infinie, items ou entités à variantes numérotées `-N`).

## 3. Entrypoints

| Stage | Fichier | Action |
|---|---|---|
| data-final-fixes | [data-final-fixes.lua](https://github.com/bev1348/PatchFR/blob/main/data-final-fixes.lua) | Boucle sur les mods actifs × types de prototypes ; pose `localised_name`/`localised_description` sur `data.raw` via `CommuPrototype` |
| (locale) | `locale/fr/*.cfg` | Chargés par le moteur, aucun code — hors périmètre |

Le choix de **data-final-fixes** (dernier stage data) est volontaire : toutes les entités/items/technos
de tous les mods sont déjà présents dans `data.raw`, ce qui permet de les surcharger de façon fiable.

## 4. Registre global / modules

Aucun registre global. Rien n'est publié dans `_G` : `CommuPrototype`, `class`, `functions` et les
listes `types_*` / `prototypes-list` / `mods-list` sont tous des **modules `require`-és** (valeur de
retour locale). Il n'y a donc **pas de meta-file de globals** à tenir.

| Module | Fichier | Nature | Accès |
|---|---|---|---|
| `CommuPrototype` | `classes/CommuPrototype.lua` | classe (factory) | `require("classes.CommuPrototype")` |
| `class` | `core/class.lua` | `{ newclass }` | `require("core.class")` |
| `functions` (util) | `core/functions.lua` | table d'utilitaires | `require("core.functions")` |
| `entity_types` | `core/types_entity.lua` | `string[]` ordonné | `require` |
| `item_types` | `core/types_item.lua` | `string[]` ordonné | `require` |
| `equip_types` | `core/types_equipment.lua` | `string[]` ordonné | `require` |
| `modsList` | `prototypes/mods-list.lua` | `string[]` (103 mods) | `require` |
| `prototypes_list` | `prototypes/prototypes-list.lua` | `string[]` (32 types) | `require` |
| `mods/<mod>.lua` | `mods/*.lua` (×106) | table de traduction | `require("mods."..name)` |

## 5. Système de classes

Une seule classe : **`CommuPrototype`**, construite via la factory maison
[core/class.lua](https://github.com/bev1348/PatchFR/blob/main/core/class.lua) (`class.newclass(super, init)`,
compatible Lua 5.1, métatable + `__call` comme constructeur, `is_a`, `_super`). Aucune hiérarchie
d'héritage n'est utilisée ici — `CommuPrototype` n'a pas de super-classe. La factory est **vendorée**
(recopiée) pour garder le mod autonome, sans dépendre de RitnLib.

`CommuPrototype(name, type_générique)` :
1. **résout le type concret** : `getType()` mappe le type générique (`item`/`entity`/`equipment`) vers
   le vrai sous-type de `data.raw` en balayant les listes `types_*` (avec `pcall` défensif) ; cas
   spéciaux `decorative → optimized-decorative`, `controls → custom-input` ; sinon type passé tel quel ;
2. **détecte les variantes** : si `data.raw[type][name]` est absent mais `data.raw[type][name-1]`
   existe, bascule `prototype_with_level = true` (technos à niveaux, items/entités à variantes) ;
3. **deep-copie** le prototype (`table.deepcopy`) dans `self.prototype`, socle des mutations.

Puis `setLocalisedName(v)` / `setLocalisedDescription(v)` écrivent `localised_name` /
`localised_description` et propagent via `update()` → `setData()` vers `data.raw`.

## 6. Flux d'exécution

**Bootstrap effectif** (data-final-fixes) :

```
data-final-fixes.lua
  require mods-list, prototypes-list, CommuPrototype
  pour chaque mod_name de modsList :
      si mods[mod_name] actif :                     ← garde : ne patche que les mods présents
          localization = require("mods."..mod_name)
          pour chaque prototype_type de prototypes_list :
              localizationPrototype(prototype_type, localization)
```

`localizationPrototype(type, loc)` teste 3 clés dans la table de traduction :

```
loc[type]              → setLocalisedName   (ex. "controls")
loc[type.."-name"]     → setLocalisedName   (ex. "entity-name")
loc[type.."-description"] → setLocalisedDescription (ex. "entity-description")
    pour chaque (name, locale) :
        pcall( CommuPrototype(name, type):setLocalised…(locale) )   ← chaque pose est pcall-protégée
```

**Cas « prototype à niveaux »** (`setLocalisedName`) :

```
repeat
    si isInfinite() → pose le nom SANS numéro, fin       (dernier palier recherche infinie)
    sinon → pose "<valeur> <variant_level>"  (ex. "Foreuse 1", "Foreuse 2")
    changePrototype()  → variant_level++, recharge data.raw[type][name-<level>]
until self.prototype == nil                              (plus de variante → arrêt)
```

## 7. Persistance

| Aspect | Statut |
|---|---|
| `storage` / `global` | **Aucun** — mod data-stage, pas d'état runtime |
| `script.register_metatable` | Aucun |
| Méta-objets persistés | Aucun |
| Wrappers temporaires | `CommuPrototype` est un **wrapper de chargement** jeté après usage ; ses mutations sont écrites dans `data.raw`, jamais stockées ailleurs |

## 8. Évènements

**Aucun.** Pas de `script.on_event`, `on_nth_tick`, custom event, ni hook. Le mod n'a aucune surface
runtime : tout se joue au chargement data-stage.

## 9. Interfaces remote

**Aucune.** Ni exposée (`remote.add_interface`), ni consommée (`remote.call`). Mod autonome.

## 10. APIs Factorio touchées

| Surface | Où | Usage type |
|---|---|---|
| `data.raw[type][name]` (lecture) | `CommuPrototype` (`getType`, constructeur, `getData`) | Sonder l'existence d'un prototype / d'une variante `-N` |
| `data.raw[type][name]` (écriture) | `CommuPrototype:setData` / `update` | Poser `localised_name` / `localised_description` |
| `table.deepcopy` | `CommuPrototype` constructeur, `changePrototype` | Copie de travail du prototype avant mutation |
| `log` | partout | Traces de chargement / erreurs de résolution de type |
| `pcall` | `getType`, `localizationPrototype`, `isInfinite` | Sondage défensif (types inexistants, champs absents) |
| Champs prototype | `localised_name`, `localised_description`, `max_level` | Champs lus/écrits |

**Coût au chargement (pas UPS)** : `getType` balaie linéairement les listes `types_*` avec un `pcall`
par type ; `CommuPrototype` `deepcopy` le prototype entier (sprites compris) pour ne changer qu'un
libellé. Lourd, mais **strictement au chargement** — aucun impact runtime.

## 11. Dette / erreurs résiduelles (synthèse)

Détail et classification complète dans [docs/audit/handoff.md](https://github.com/bev1348/PatchFR/blob/main/docs/audit/handoff.md) (§ C.6). Statuts arbitrés par l'auteur le 2026-07-12 : **aucun défaut latent retenu**.

- **`ifElse` → `tryCatch`** (`core/functions.lua`) — utilitaire **recopié de RitnLib, conservé
  volontairement**. La branche appelant `tryCatch` est **dormante** (seul appelant `isNil`, qui passe
  des booléens) ; `tryCatch` reste non défini tant que la branche n'est pas utilisée. **Assumé, pas un
  bug.**
- **Cluster `localisedBuilder*` / `matchLocalisedBuilder`** + `self.start` / `self.pattern` — parseur
  de tokens `__ITEM__…__` non câblé au flux : tentative de fonctionnalité **inachevée, gardée exprès**
  (🚧). À conserver.
- **`setLocalisedDescription` à niveaux** — l'arrêt anticipé (`max_level == ""`) est **voulu** : la
  description reste identique quel que soit le niveau. Comportement intentionnel.
- **Toggle de test commenté** `data-final-fixes.lua:49-50` — résidu de scaffolding, à nettoyer (pas
  un bug).
- **NON-bugs** : suffixe `-N` de `getVariantName` (convention intentionnelle) ; sondage `pcall` des
  types (défensif intentionnel).

## 12. Sortie attendue post-refactor

| Version | Vague | Contenu |
|---|---|---|
| (à définir) | Nettoyage léger | Retirer le seul vrai résidu : le toggle de test commenté `data-final-fixes.lua:49-50`. (Le cluster `localisedBuilder*` et l'utilitaire `ifElse`/`tryCatch` sont **conservés volontairement** — cf. §11.) |
| (facultatif) | Si un jour utile | Finir le cluster `localisedBuilder*` (insertion d'icônes) ; définir `tryCatch` seulement si sa branche est activée |
| (à définir) | Annotations LuaLS | Skill 2 : annoter le cœur ; type-alias `mods/` central et non-intrusif (ne pas toucher les 106 fichiers) |
| (à définir) | Doc | Skill 3 : référence du code + guide traducteur (`.cfg` + équivalents `.lua`) — ce dernier hors périmètre de cette page |

## Historique

| Date | Version pin | Changement |
|---|---|---|
| 2026-07-12 | 2.0.20 | Document initial (audit Phases 1-4) |
