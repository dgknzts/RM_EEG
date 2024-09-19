# Gerekli kütüphaneleri yükleyelim
library(dplyr)

# Dosya yolunu belirtelim
base_dir <- "D:/Projects/EEG_RM/behavioral"

# Katılımcıların dosya isimlerini alalım
subject_folders <- list.dirs(base_dir, full.names = TRUE, recursive = FALSE)

# Tüm katılımcılar için veri çerçevesini başlatalım
all_subjects_data <- data.frame()

# Her katılımcının klasöründe döngü ile gezelim
for (folder in subject_folders) {
  # Katılımcı kodunu alalım (örneğin sbj_1)
  subject_code <- basename(folder)
  
  # Klasördeki tüm csv dosyalarını listeleyelim
  csv_files <- list.files(folder, pattern = "\\.csv$", full.names = TRUE)
  
  # Her katılımcı için birleştirilmiş veri çerçevesini başlatalım
  subject_data <- data.frame()
  
  # Her bir csv dosyasını okuyalım ve işleyelim
  for (file in csv_files) {
    data <- read.csv(file)
    data <- data %>%
      select(stimStartTrigger, amount_response.keys, location_response.keys, session) %>%
      mutate(subject_code = subject_code) %>%
      na.omit()  # NA değerleri atmak için
    
    # Katılımcının verisine ekleyelim
    subject_data <- bind_rows(subject_data, data)
  }
  
  # Tüm katılımcıların verisine ekleyelim
  all_subjects_data <- bind_rows(all_subjects_data, subject_data)
}

# Sonucu yazdıralım
writexl::write_xlsx(all_subjects_data, 'behavioral_data.xlsx')
