library(dplyr)
library(tidyverse)
library(ggplot2)

# Veriyi okuyalım
df <- readxl::read_xlsx('behavioral_data.xlsx')

# Her katılımcının dağılımını hesaplayalım
df_summary_pSbj <- df %>%
  group_by(subject_code, stimStartTrigger, amount_response.keys, location_response.keys) %>%
  summarise(count = n(), .groups = 'drop')

# stimStartTrigger değerlerini left ve right olarak değiştirelim
df_summary_pSbj$stimStartTrigger <- recode(df_summary_pSbj$stimStartTrigger,
                                           `111` = "left",
                                           `222` = "right")

# Yeni renkleri tanımlayalım
location_colors <- c("1" = "#66c2a5", "2" = "#fc8d62", "3" = "#8da0cb")  # 3 için yeni renk ekleyelim

# Her katılımcı için bar grafiklerini çizelim
for (subject in unique(df_summary_pSbj$subject_code)) {
  # Katılımcının verilerini filtreleyelim
  subject_data <- df_summary_pSbj %>% filter(subject_code == subject)
  
  # Bar grafiğini çizelim
  p <- ggplot(subject_data, aes(x = factor(amount_response.keys), y = count, fill = factor(location_response.keys))) +
    geom_bar(stat = "identity", position = "stack") +  # Stacked bar plot
    facet_wrap(~stimStartTrigger) +
    labs(title = paste("Subject:", subject), x = "Response Keys", y = "Count", fill = "Location Response Keys") +
    theme_minimal() +
    scale_fill_manual(values = location_colors) +
    geom_text(aes(label = count), vjust = -0.5, position = position_stack(vjust = 0.5))  # Adjust text position for stacked bars
  
  # Grafiği kaydedelim
  ggsave(filename = paste0("D:/Projects/EEG_RM/behavioral/", subject, "_bar_chart.png"), plot = p, width = 10, height = 6)
}

# Sonucu yazdıralım
print(df_summary_pSbj)
