%% Finding .set files
set_files_path = 'D:\Projects\EEG_RM\before_fft\pSbj_averages\set_files\';
plots_files_path = 'D:\Projects\EEG_RM\plots\';
set_files_list = dir(fullfile(set_files_path, '*.set'));

%% Parameters
relevant_channels = {'O1', 'Oz', 'O2'};
highlighted_freqs = [1.2, 1.5, 2.7, 4.8, 6, 7.5, 10.8, 12.3, 13.5];

% Tüm .set dosyaları için döngü
for file_idx = 1:length(set_files_list)
    %% Import each item sep
    EEG = pop_loadset('filename', set_files_list(file_idx).name, 'filepath', set_files_path); 

    %% Selecting relevant channels
    rel_chan_index = find(ismember({EEG.chanlocs.labels}, relevant_channels)); % find relevant indices
    EEG.data = EEG.data(rel_chan_index, :, :);

    %% Selecting relevant hz-range
    % Belirli zaman noktalarının indekslerini bulun
    relevant_time_start = find(EEG.times >= 0.5, 1); % 0.5 saniye
    relevant_time_end = find(EEG.times <= 17, 1, 'last'); % 17 saniye

    % Sadece seçilen zaman aralığını içeren veri matrisini elde edin
    EEG.data = EEG.data(:, relevant_time_start:relevant_time_end, :);

    % Zaman vektörünü de seçilen zaman aralığına göre güncelleyin
    EEG.times = EEG.times(relevant_time_start:relevant_time_end);

    %% Drawing histograms

    % Belirli kanalların indekslerini bulun (örneğin, 1, 2 ve 3 numaralı kanallar)
    channel_indices = [1, 2, 3];

    % Her bir kanal için bar grafiği çiz
    figure;

    for i = 1:length(channel_indices)
        channel_idx = channel_indices(i);

        % Seçilen kanal ve zaman aralığına ait veriyi alın
        data = EEG.data(channel_idx, :);

        % Veriyi zaman boyunca ortalayın (eğer deneme sayısı 1'den büyükse)
        if size(data, 3) > 1
            data = mean(data, 3);
        end

        % Bar grafiği çiz
        subplot(length(channel_indices), 1, i);
        b = bar(EEG.times(:), squeeze(data), 'FaceColor', 'flat');

        % Bar renklerini ayarla
        b.CData = repmat([0 0 1], length(EEG.times), 1); % Varsayılan renk mavi
        for j = 1:length(highlighted_freqs)
            freq_idx = find(abs(EEG.times - highlighted_freqs(j)) < 0.01); % küçük bir tolerans ile indeks bulun
            if ~isempty(freq_idx)
                b.CData(freq_idx, :) = [1 0 0]; % Kırmızı renk
            end
        end

        % Y eksenini ayarla
        ylim([0 10]);

        title(['Channel ' relevant_channels{i}]);
        xlabel('Frequency');
        ylabel('Power');
    end

    % Grafiğin ana başlığını dosya adı olarak ayarla
    sgtitle(['File: ' set_files_list(file_idx).name]);

    % Grafiği dosya ismiyle kaydet
    saveas(gcf, fullfile(plots_files_path, [set_files_list(file_idx).name, '.jpg']));
    close(gcf); % Grafiği kapat
end
