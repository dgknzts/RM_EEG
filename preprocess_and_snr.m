%% adding letswave and my functions to the path
addpath 'D:\Projects\EEG_RM\toolboxes\letswave7-master'
addpath 'my_functions'

%% Initialization of Parameters

%filters and downsample ratio
bandpass_filter = [0.1 100];
bandpass_filter_order = 4;
notch_filter = [49 51];
notch_filter_order = 2;
downsample_ratio = 4;

%oc removal
oc_removal = true; %false if not.

%epoching settings
epoch_triggers = {'S222'};
% 111: left, 222: right
epoch_start_n_end = [-2.5, 12.5];
epoch_duration = epoch_start_n_end(2)- epoch_start_n_end(1);
time_range_of_interest = [0 10];


%channel selections
channel_list_withoutVEOG= {'Fp1','Fz','F3','F7','FT9','FC5','FC1','C3','T7','CP5','CP1','Pz','P3','P7','O1','Oz','O2','P4','P8','TP10','CP6','CP2','Cz','C4','T8','FT10','FC6','FC2','F4','F8','Fp2','AF7','AF3','AFz','F1','F5','FT7','FC3','C1','C5','TP7','CP3','P1','P5','PO7','PO3','POz','PO4','PO8','P6','P2','CPz','CP4','TP8','C6','C2','FC4','FT8','F6','AF8','AF4','F2','Iz'};

%fft settings
y_axis = 'power'; %'amplitude' is the other option


%snr settings
first_neighbour_order = 2;
last_neighbour_order = 8;
num_extereme_remove = 1;
snr_option = 'snr'; % can also use 'substraction'


%% Paths and file lists
raw_data_path = 'D:\Projects\EEG_RM\data\raw';
behavioral_data_path = 'D:\Projects\EEG_RM\behavioral\';

file_list_raw_data = dir(fullfile(raw_data_path, 'sbj_*.eeg'));

%% Bad Electrodes inspected by eye during exp and manually in the data for each Subject
num_of_neighbours = 3;

sbj_1_bad = {'AF7','Fp1'};
sbj_2_bad = {'AF7', 'Iz'};
sbj_3_bad = {'AF7', 'AF3'};
sbj_4_bad = {'CP1', 'AF7', 'AF3'};
sbj_5_bad = {'AF7', 'AF8', 'Fp1'};
sbj_6_bad = {'AF7','Fp2'};

%% Subject Loop
for xSbj = 1:length(file_list_raw_data)
    %% Importing
    LW_init();
    FLW_import_data.get_lwdata('filename',file_list_raw_data(xSbj).name,'pathname',raw_data_path,'is_save',1);
end
%% lw6 file paths
% IMPORTANT!! COULDNT FIGURE OUT HOW TO SAVE LW6 FILES TO DIFF FOLDER THAN
% CURRENT PATH. MOVE THEM MANUALLY TO THE PATH WRITTEN BELOW
lw6_file_path = 'D:\Projects\EEG_RM\lw6_files';
file_list_lw6_path = dir(fullfile(lw6_file_path, 'sbj_*.lw6'));

%% Preprocess Loop
for iSbj = 6:length(file_list_lw6_path)
    %% Load
    option=struct('filename',append(lw6_file_path,'\',file_list_lw6_path(iSbj).name));
    lwdata= FLW_load.get_lwdata(option);
    
    %% Filters and downsampling
    option=struct('filter_type','bandpass','high_cutoff',bandpass_filter(2),'low_cutoff',bandpass_filter(1),'filter_order',bandpass_filter_order,'suffix','','is_save',0);
    lwdata = FLW_butterworth_filter.get_lwdata(lwdata,option);
    option=struct('x_dsratio',downsample_ratio,'suffix','','is_save',0);
    lwdata = FLW_downsample.get_lwdata(lwdata,option);
    option=struct('filter_type','notch','high_cutoff',notch_filter(2),'low_cutoff',notch_filter(1),'filter_order',notch_filter_order,'suffix','','is_save',0);
    lwdata = FLW_butterworth_filter.get_lwdata(lwdata,option);
    
    
    %% Ocular Removal
    %option=struct('ocular_channel',{{'VEOG'}},'suffix','','is_save',0);
    %lwdata = FLW_ocular_remove.get_lwdata(lwdata,option);
    
    %% Interpolation
    bad_channel_var_name = sprintf('sbj_%d_bad', iSbj);
    bad_channels = eval(bad_channel_var_name);

    for iBad = 1:length(bad_channels)
        bad_electrode = bad_channels(iBad);
        neighbours = find_neighbour_Callback('chanlocs.ced', bad_electrode, num_of_neighbours, bad_channels);
        option=struct('channel_to_interpolate',bad_electrode,'channels_for_interpolation_list',{neighbours},'suffix','','is_save',0);
        lwdata = FLW_interpolate_channel.get_lwdata(lwdata,option);
    end
    %% Rereference
    option=struct('reference_list',{{'Fp1','Fz','F3','F7','FT9','FC5','FC1','C3','T7','CP5','CP1','Pz','P3','P7','O1','Oz','O2','P4','P8','TP10','CP6','CP2','Cz','C4','T8','FT10','FC6','FC2','F4','F8','Fp2','AF7','AF3','AFz','F1','F5','FT7','FC3','C1','C5','TP7','CP3','P1','P5','PO7','PO3','POz','PO4','PO8','P6','P2','CPz','CP4','TP8','C6','C2','FC4','FT8','F6','AF8','AF4','F2','Iz'}},'apply_list',{{'Fp1','Fz','F3','F7','FT9','FC5','FC1','C3','T7','CP5','CP1','Pz','P3','P7','O1','Oz','O2','P4','P8','TP10','CP6','CP2','Cz','C4','T8','FT10','FC6','FC2','F4','F8','Fp2','AF7','AF3','AFz','F1','F5','FT7','FC3','C1','C5','TP7','CP3','P1','P5','PO7','PO3','POz','PO4','PO8','P6','P2','CPz','CP4','TP8','C6','C2','FC4','FT8','F6','AF8','AF4','F2','Iz'}},'suffix','','is_save',0);
    lwdata = FLW_rereference.get_lwdata(lwdata,option);
    
    %% Epoching
    option=struct('event_labels',{epoch_triggers},'x_start',epoch_start_n_end(1),'x_end',epoch_start_n_end(2),'x_duration',epoch_duration,'suffix','','is_save',0);
    lwdata = FLW_segmentation.get_lwdata(lwdata,option);
    
    %% Crop Epochs
    option=struct('xcrop_chk',1,'xstart',time_range_of_interest(1),'xend',time_range_of_interest(2),'suffix','right','is_save',0); %write left if S111 right if S222
    lwdata = FLW_crop_epochs.get_lwdata(lwdata,option);
    
    %% Epoch Selections based on responses and averages
    [idxAmount1, idxAmount2, idxAmount3, idxAmount4] = extract_epoch_indices(append(behavioral_data_path, 'sbj_' , num2str(iSbj) , '_behavioral'), 222); %change the last part by 111
    
    if ~isempty(idxAmount1)
        option=struct('type','epoch','items',{idxAmount1},'suffix','Resp_1','is_save',1);
        lwdata_1 = FLW_selection.get_lwdata(lwdata,option);
    end

    if ~isempty(idxAmount2)
        option=struct('type','epoch','items',{idxAmount2},'suffix','Resp_2','is_save',1);
        lwdata_2 = FLW_selection.get_lwdata(lwdata,option);
    end

    if ~isempty(idxAmount3)
        option=struct('type','epoch','items',{idxAmount3},'suffix','Resp_3','is_save',1);
        lwdata_3 = FLW_selection.get_lwdata(lwdata,option);
    end

    if ~isempty(idxAmount4)
        option=struct('type','epoch','items',{idxAmount4},'suffix','Resp_3','is_save',1);
        lwdata_4 = FLW_selection.get_lwdata(lwdata,option);
    end
    %% Average Epochs
    if ~isempty(idxAmount1)
        option=struct('operation','average','suffix','avg_all','is_save',1);
        lwdata_1 = FLW_average_epochs.get_lwdata(lwdata_1,option);
    end

    if ~isempty(idxAmount2)
        option=struct('operation','average','suffix','avg_all','is_save',1);
        lwdata_2 = FLW_average_epochs.get_lwdata(lwdata_2,option);
    end

    if ~isempty(idxAmount3)
        option=struct('operation','average','suffix','avg_all','is_save',1);
        lwdata_3 = FLW_average_epochs.get_lwdata(lwdata_3,option);
    end

    if ~isempty(idxAmount4)
        option=struct('operation','average','suffix','avg_all','is_save',1);
        lwdata_4 = FLW_average_epochs.get_lwdata(lwdata_4,option);
    end

end
