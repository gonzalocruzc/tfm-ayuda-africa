# -------------------------------------------------------------------------
# TFM - Determinantes y eficacia de la ayuda externa en África Subsahariana: un análisis comparativo entre los bloques occidental y chino (2002-2021)
# -------------------------------------------------------------------------

# 1. CARGAR LIBRERÍAS
library(dplyr)
library(readxl)
library(car)
library(stargazer) # Para exportar las tablas
library(plm) # Para el panel de datos
library(ggplot2)

# 2. CARGAR Y PREPARAR LOS DATOS
df <- read_excel("Base de Datos África.xlsx", sheet = "Datos_Panel")

# Tratamiento de NAs
df_clean <- df |>
  filter(Year >= 2002 & Year <= 2021) |>
  mutate(across(c("AOD_Occ2024", "China_Conc", "China_NoConc", "China_NoClasif", "Ayuda_China"), 
                ~ ifelse(is.na(.), 0, .)))

# Escala inicial de ayudas y población
df_clean$Occidente_Mill <- df_clean$AOD_Occ / 1000000
df_clean$China_Mill <- df_clean$Ayuda_China / 1000000
df_clean$Poblacion_Mill <- df_clean$Poblacion / 1000000

# 3. ANÁLISIS EXPLORATORIO

# Seleccionamos solo las variables numéricas clave para la tabla
variables_descriptivas <- df_clean[, c("Occidente_Mill", "China_Mill", 
                                          "Corrupcion", "Conflicto", 
                                          "Poblacion_Mill", "PIB_pc", "Crec_PIB")]

# Convertimos a data.frame estándar
df_desc <- as.data.frame(variables_descriptivas)

# Generamos la tabla descriptiva (Tabla 1)
stargazer(df_desc, 
          type = "text", 
          title = "Estadísticos Descriptivos de las Variables Principales",
          summary = TRUE,
          digits = 2)

# Agrupamos los datos por año para ver el total del continente
df_tendencia <- df_clean |>
  group_by(Year) |>
  summarise(Occidente_Total = sum(Occidente_Mill, na.rm = TRUE),
            China_Total = sum(China_Mill, na.rm = TRUE))

# Dibujamos el gráfico de líneas
ggplot(df_tendencia, aes(x = Year)) +
  geom_line(aes(y = Occidente_Total, color = "Occidente"), size = 1.2) +
  geom_line(aes(y = China_Total, color = "China"), size = 1.2) +
  scale_color_manual(values = c("Occidente" = "blue", "China" = "red")) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(2002, 2021, 2)) +
  labs(title = "Evolución de los Flujos de Ayuda en África Subsahariana (2002-2021)",
       subtitle = "Volumen de las ayudas en millones de USD constantes",
       x = "Año", y = "Millones de USD", color = "Donante") +
  theme(legend.position = "bottom")

# 4. CREAR LOS CORTES TRANSVERSALES

# Filtramos los años clave usando la base ya imputada y perfecta
df_2006 <- df_clean |> filter(Year == 2006)
df_2016 <- df_clean |> filter(Year == 2016)
df_2019 <- df_clean |> filter(Year == 2019)

# 5. REGRESIONES PARA OCCIDENTE Y CHINA

# Occidente
occ_2006 <- lm(Occidente_Mill ~ Corrupcion + 
                 Conflicto + PIB_pc + Poblacion_Mill, 
               data = df_2006)
occ_2016 <- lm(Occidente_Mill ~ Corrupcion + 
                 Conflicto + PIB_pc + Poblacion_Mill, 
               data = df_2016)
occ_2019 <- lm(Occidente_Mill ~ Corrupcion + 
                 Conflicto + PIB_pc + Poblacion_Mill, 
               data = df_2019)


# China
chi_2006 <- lm(China_Mill ~ Corrupcion + 
                 Conflicto + PIB_pc + Poblacion_Mill, 
               data = df_2006)
chi_2016 <- lm(China_Mill ~ Corrupcion + 
                 Conflicto + PIB_pc + Poblacion_Mill, 
               data = df_2016)
chi_2019 <- lm(China_Mill ~ Corrupcion + 
                 Conflicto + PIB_pc + Poblacion_Mill, 
               data = df_2019)

# Revisión
# Función para diagnosticar los modelos lineales
diagnosticar_modelo <- function(modelo, nombre) {
  print(paste("--- VIF para:", nombre, "---"))
  print(vif(modelo))
  
  # Gráficos
  par(mfrow=c(2,2))
  plot(modelo, main=nombre)
  par(mfrow=c(1,1))
}

diagnosticar_modelo(occ_2006, "Occidente 2006")
diagnosticar_modelo(occ_2016, "Occidente 2016")
diagnosticar_modelo(occ_2019, "Occidente 2019")
diagnosticar_modelo(chi_2006, "China 2006")
diagnosticar_modelo(chi_2016, "China 2016")
diagnosticar_modelo(chi_2019, "China 2019")


# 6. DATOS DE PANEL

# Preparación final de escala de PIB_pc (Para evitar matriz singular en el Panel)

df_clean$PIB_pc_Miles <- df_clean$PIB_pc / 1000

# Declaramos a R que es un Panel de Datos
panel_data <- pdata.frame(df_clean, index = c("Pais", "Year"))

# PREGUNTA 1: Determinantes de la Ayuda
plm_occidente <- plm(Occidente_Mill ~ Corrupcion + 
                       Conflicto + PIB_pc_Miles + Poblacion_Mill, 
                     data = panel_data, model = "within", effect = "twoways")

plm_china <- plm(China_Mill ~ Corrupcion + 
                   Conflicto + PIB_pc_Miles + Poblacion_Mill, 
                 data = panel_data, model = "within", effect = "twoways")

# Justificación Matemática: Test de Hausman para Occidente
plm_aleatorio_occ <- plm(Occidente_Mill ~ Corrupcion + 
                           Conflicto + PIB_pc_Miles + Poblacion_Mill, 
                         data = panel_data, model = "random")

phtest(plm_occidente, plm_aleatorio_occ)

# Test de Hausman para China
plm_aleatorio_china <- plm(China_Mill ~ Corrupcion + 
                             Conflicto + PIB_pc_Miles + Poblacion_Mill, 
                           data = panel_data, model = "random")

phtest(plm_china, plm_aleatorio_china)

# PREGUNTA 2: Eficacia de la Ayuda
eficacia_occ <- plm(Crec_PIB ~ Occidente_Mill + 
                      Corrupcion + Conflicto + 
                      PIB_pc_Miles + Poblacion_Mill, 
                    data = panel_data, model = "within", effect = "twoways")

eficacia_chi <- plm(Crec_PIB ~ China_Mill + 
                      Corrupcion + Conflicto + 
                      PIB_pc_Miles + Poblacion_Mill, 
                    data = panel_data, model = "within", effect = "twoways")

# Test de Hausman para Occidente
eficacia_aleatorio_occ <- plm(Crec_PIB ~ Occidente_Mill + 
                                Corrupcion + Conflicto + 
                                PIB_pc_Miles + Poblacion_Mill, 
                         data = panel_data, model = "random")

phtest(eficacia_occ, eficacia_aleatorio_occ)

# Test de Hausman para China
eficacia_aleatorio_china <- plm(Crec_PIB ~ China_Mill + 
                                  Corrupcion + Conflicto + 
                                  PIB_pc_Miles + Poblacion_Mill, 
                           data = panel_data, model = "random")

phtest(eficacia_chi, eficacia_aleatorio_china)


# 7. EXPORTAR TABLAS FINALES

# Tabla 2: Evolución Occidente
stargazer(occ_2006, occ_2016, occ_2019, 
          type = "text", 
          title = "Evolución de los Determinantes de la AOD Occidental",
          column.labels = c("2006", "2016", "2019"))

# Tabla 3: Evolución China
stargazer(chi_2006, chi_2016, chi_2019, 
          type = "text", 
          title = "Evolución de los Determinantes de la Financiación China",
          column.labels = c("2006", "2016", "2019"))

# Tabla 4: Panel Determinantes (Occidente vs China)
stargazer(plm_occidente, plm_china, 
          type = "text", 
          title = "Determinantes Dinámicos de la Ayuda Exterior en África (Panel 2002-2021)",
          column.labels = c("Occidente", "China"))

# Tabla 5: Panel Eficacia (Crecimiento PIB)
stargazer(eficacia_occ, eficacia_chi,
          type = "text", 
          title = "Eficacia de la Ayuda sobre el Crecimiento del PIB (Panel 2002-2021)")
