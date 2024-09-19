%% Interpolation
sbj_5_bad = {'AF7', 'AF8', 'Fp1'};
num_of_neighbours = 3;
bad_channel_var_name = sprintf('sbj_%d_bad', 5);
bad_channels = eval(bad_channel_var_name);

for iBad = 1:length(bad_channels)
    bad_electrode = bad_channels{iBad};  % Hücre dizisini kullanıyorsanız {iBad} olarak değiştirin
    neighbours = find_neighbour_Callback('chanlocs.ced', bad_electrode, num_of_neighbours, bad_channels);
end
