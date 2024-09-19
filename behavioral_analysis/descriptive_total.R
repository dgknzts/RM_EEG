# Gerekli kütüphaneleri yükleyelim
library(dplyr)
library(tidyverse)
library(ggplot2)


df <- readxl::read_xlsx('behavioral_data.xlsx')
response_colors <- c("1" = "#1f77b4", "2" = "#ff7f0e", "3" = "#2ca02c", "4" = "#d62728")

library(dplyr)
library(tidyverse)
library(ggplot2)

# Veriyi okuyalım
df <- readxl::read_xlsx('behavioral_data.xlsx')

# Her katılımcının dağılımını hesaplayalım
df_summary_all <- df %>%
  group_by(amount_response.keys, location_response.keys) %>%
  filter(amount_response.keys == 1) %>%
  summarise(count = n(), .groups = 'drop')

# # stimStartTrigger değerlerini left ve right olarak değiştirelim
# df_summary_all$stimStartTrigger <- recode(df_summary_all$stimStartTrigger,
#                                            `111` = "left",
#                                            `222` = "right")

# Yeni renkleri tanımlayalım
location_colors <- c("1" = "#66c2a5", "2" = "#fc8d62", "3" = "#8da0cb")  # 3 için yeni renk ekleyelim


# Bar grafiğini çizelim
p <-
  ggplot(df_summary_all, aes(
    x = factor(amount_response.keys),
    y = count,
    fill = factor(location_response.keys)
  )) +
  geom_bar(stat = "identity", position = "stack") +  # Stacked bar plot
  labs(
    title = paste("Summary"),
    x = "Response Keys",
    y = "Count",
    fill = "Location Response Keys"
  ) +
  theme_minimal() +
  scale_fill_manual(values = location_colors) +
  geom_text(aes(label = count),
            vjust = -0.5,
            position = position_stack(vjust = 0.5))  # Adjust text position for stacked bars

# # Grafiği kaydedelim
# ggsave(
#   filename = paste0("D:/Projects/EEG_RM/behavioral/", subject, "_bar_chart.png"),
#   plot = p,
#   width = 10,
#   height = 6
# )

# Sonucu yazdıralım
print(p)
