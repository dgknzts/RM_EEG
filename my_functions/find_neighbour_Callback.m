function channel_names = find_neighbour_Callback(locs_filename, bad_channel_name, channel_num, bad_channel_list)
    % .locs dosyasını oku
    fid = fopen(locs_filename, 'r');
    if fid == -1
        error('Cannot open the file: %s', locs_filename);
    end
    
    data = textscan(fid, '%f %s %f %f %f %f %f %f %f %s', 'HeaderLines', 1);
    fclose(fid);
    
    labels = data{2};
    X = data{5};
    Y = data{6};
    Z = data{7};

    % bad_channel_name'ın etiket adını labels dizisinde arayıp indeksi bulma
    bad_channel_idx = find(strcmp(labels, bad_channel_name));

    % Eğer bad_channel_name etiket adı labels dizisinde bulunamazsa hata mesajı ver
    if isempty(bad_channel_idx)
        error('Bad channel name not found in channel locations.');
    end

    N = length(labels);
    dist = -ones(N, 1);

    for i = 1:N
        if i ~= bad_channel_idx % Hatalı kanalı dikkate alma
            dist(i) = sqrt((X(i) - X(bad_channel_idx))^2 + ...
                           (Y(i) - Y(bad_channel_idx))^2 + ...
                           (Z(i) - Z(bad_channel_idx))^2);
        end
    end

    % Mesafeleri sırala ve en yakın kanalları bul
    [~, idx] = sort(dist);
    idx(idx == bad_channel_idx) = []; % Hatalı kanalı çıkart

    % Halihazırda kötü olan kanalları listeden çıkar
    bad_channel_idxs = find(ismember(labels, bad_channel_list));
    idx(ismember(idx, bad_channel_idxs)) = [];
    
    % Yeterli sayıda komşu bulana kadar devam et
    nearest_idx = idx(1:min(channel_num, length(idx)));

    % En yakın kanalların isimlerini alın
    channel_names = labels(nearest_idx);
    
    % Hücre dizisini tek satırda birleştir
    channel_names = {channel_names{:}};
end
