function [cellArray1, cellArray2, cellArray3, cellArray4] = extractIndices(directoryPath, stimStartTriggerValue)
    % directoryPath - İçinde birleştirilecek CSV dosyalarının bulunduğu dizin yolu
    % stimStartTriggerValue - Filtreleme yapılacak stimStartTrigger değeri
    
    % Dizin içindeki tüm CSV dosyalarını bulma
    csvFiles = dir(fullfile(directoryPath, '*.csv'));
    
    if isempty(csvFiles)
        error('Belirtilen dizinde CSV dosyası bulunamadı.');
    end
    
    % Dosyaları değiştirme tarihine göre sıralama (en eskiden en yeniye)
    [~, idx] = sort([csvFiles.datenum]);
    csvFiles = csvFiles(idx);
    
    % Sütun isimleri
    columnsToKeep = {'stimStartTrigger', 'amount_response_keys', 'location_response_keys', 'session'};
    
    % Boş bir tablo oluşturma
    combinedData = table();
    
    % Her CSV dosyasını okuma ve işlemleri gerçekleştirme
    for i = 1:length(csvFiles)
        % Dosya adını oluşturma
        filePath = fullfile(directoryPath, csvFiles(i).name);
        
        % Dosyayı okuma
        data = readtable(filePath);
        
        % Yalnızca belirtilen sütunları tutma
        data = data(:, columnsToKeep);
        
        % NaN içeren satırları silme
        data = rmmissing(data);
        
        % Belirli stimStartTrigger değerine göre filtreleme
        data = data(data.stimStartTrigger == stimStartTriggerValue, :);
        
        % Veriyi birleştirme
        combinedData = [combinedData; data];
    end
    
    % amount_response_keys sütununda belirli değerlerin indekslerini çıkarma
    idxAmount1 = find(combinedData.amount_response_keys == 1);
    idxAmount2 = find(combinedData.amount_response_keys == 2);
    idxAmount3 = find(combinedData.amount_response_keys == 3);
    idxAmount4 = find(combinedData.amount_response_keys == 4);
    
    % İndeksleri karakter formatında hücre dizilerine dönüştürme
    cellArray1 = arrayfun(@(x) {num2str(x)}, idxAmount1);
    cellArray2 = arrayfun(@(x) {num2str(x)}, idxAmount2);
    cellArray3 = arrayfun(@(x) {num2str(x)}, idxAmount3);
    cellArray4 = arrayfun(@(x) {num2str(x)}, idxAmount4);
end
