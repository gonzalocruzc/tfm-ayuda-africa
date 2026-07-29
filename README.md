# Determinantes y eficacia de la financiación externa en África Subsahariana

Análisis comparativo entre la Ayuda Oficial al Desarrollo (AOD) occidental y la financiación oficial china, mediante datos de panel de 46 países de África Subsahariana entre 2002 y 2021.

## Resumen

Este Trabajo Fin de Máster analiza los **determinantes** y la **eficacia** de la financiación externa en África Subsahariana, diferenciando la AOD occidental (OCDE/CRS) de los fondos procedentes de China (AidData). Mediante un panel de 920 observaciones (46 países × 20 años) y un modelo de efectos fijos bidireccionales, el estudio revela dos hallazgos centrales:

1. **Occidente premia la buena gobernanza; China aplica no injerencia.** El control de la corrupción es un determinante significativo y positivo de la AOD occidental, mientras que resulta estadísticamente irrelevante para la financiación china.
2. **Se confirma la "paradoja micro-macro" (Mosley, 1986):** ni la ayuda occidental ni la china tienen un impacto significativo sobre el crecimiento del PIB. El único determinante robusto del crecimiento es la calidad institucional interna (control de la corrupción).

## Preguntas de investigación

1. ¿Qué factores geopolíticos, económicos e institucionales determinan la asignación de ayuda a África Subsahariana por parte de Occidente y de China?
2. ¿Tienen estos flujos externos un impacto real en el crecimiento económico del país receptor, o el desarrollo depende de otros factores?

## Datos

Panel de **46 países** de África Subsahariana, **2002–2021** (920 observaciones país-año), integrando 5 fuentes:

- **OECD Creditor Reporting System (CRS)** — AOD occidental (USD constantes de 2024)
- **AidData Global Chinese Development Finance Dataset (GCDF v3.0)** — financiación china concesional, no concesional y no clasificada (USD constantes de 2021)
- **World Bank World Development Indicators (WDI)** — PIB, PIB per cápita, población, deflactor de precios
- **World Bank Worldwide Governance Indicators (WGI)** — control de la corrupción y otros indicadores de gobernanza
- **UCDP/PRIO Armed Conflict Dataset (v25.1)** — presencia de conflicto armado activo (≥25 muertes/año)

Todas las fuentes son de acceso abierto; licencias y citas completas en [`DATA_SOURCES.md`](./DATA_SOURCES.md).

**Tratamiento de datos:**
- Homogeneización de precios: la AOD occidental se deflactó de USD constantes de 2024 a 2021 usando el deflactor implícito del PIB de EE.UU. para hacerla comparable con la financiación china
- Ausencias estructurales en financiación china (ej. Esuatini, Burkina Faso hasta 2018, Santo Tomé y Príncipe y Gambia hasta 2016) tratadas como ceros, al deberse al principio diplomático de Una Sola China, no a datos faltantes
- Variables escaladas a millones (ayuda, población) y miles (PIB per cápita) para evitar problemas de matriz singular en la estimación within

## Metodología

- **Modelos de corte transversal (MCO)** para tres años clave: 2006 (pico de condonación de deuda occidental), 2016 (pico histórico de financiación china) y 2019 (punto de divergencia pre-pandemia)
- **Modelo de panel con efectos fijos bidireccionales (within)** para la serie completa 2002-2021, separado por bloque donante y replicado para el modelo de determinantes y el de eficacia (impacto en crecimiento del PIB)
- **Test de Hausman** para la elección de especificación: los resultados no rechazan la hipótesis nula en los modelos de determinantes (p = 0,2491 Occidente; p = 0,6699 China), pero el estudio justifica el uso de efectos fijos apoyándose en fundamentos teóricos (Wooldridge, 2010; Hausman, 1978) dada la previsible correlación entre heterogeneidad inobservable y variables explicativas. En los modelos de eficacia sobre el crecimiento, el test sí rechaza la hipótesis nula (p = 0,0087 Occidente; p = 0,0004 China), respaldando estadísticamente la elección de efectos fijos
- Diagnósticos de multicolinealidad (VIF < 1,5 en todos los modelos) y de residuos (normalidad, homocedasticidad, distancias de Cook)

## Resultados principales

- **Determinantes de la AOD occidental:** el control de la corrupción es significativo y positivo al 1% en el panel completo (β = 17,21). Occidente incrementa su ayuda ante mejoras de gobernanza
- **Determinantes de la financiación china:** el control de la corrupción no es significativo (β = -9,68). La financiación china es indiferente a la calidad institucional del receptor
- **Convergencia:** la población es significativa al 1% para ambos bloques, con un efecto ligeramente mayor en China (β = 15,16) que en Occidente (β = 13,52)
- **Eficacia sobre el crecimiento:** ni la AOD occidental ni la financiación china tienen efecto significativo sobre el crecimiento del PIB; el control de la corrupción es la única variable significativa (β ≈ 0,10, p < 0,05) — confirma la paradoja micro-macro (Mosley, 1986)

## Herramientas

- **R**: `dplyr`, `readxl`, `plm`, `car`, `ggplot2`, `stargazer`

## Autor

**Gonzalo Cruz Cañizares** — Máster Universitario en Modelización y Análisis de Datos Económicos (MUMADE)

Tutor: Víctor Manuel Casero Alonso

Universidad de Castilla-La Mancha (UCLM) — Curso 2025/2026
