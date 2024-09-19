LW_init();option=[];
%% option for figure
option.inputfiles{1}='Sub093 P300 nontarget.lw6';
option.inputfiles{2}='Sub093 P300 target.lw6';
option.inputfiles{3}='cwt Sub093 P300 target.lw6';
option.inputfiles{4}='cwt Sub093 P300 nontarget.lw6';
option.fig2_pos=[325,100,700,650];

%% option.axis{1}: P300
option.ax{1}.name='P300';
option.ax{1}.pos=[50,340,600,250];
option.ax{1}.style='Curve';
option.ax{1}.fontsize=12;
option.ax{1}.legend='on';
option.ax{1}.XlimMode='Manual';
option.ax{1}.Xlim=[-0.5,1.5];
option.ax{1}.XAxisLocation='origin';
option.ax{1}.xlabel_visible='on';
option.ax{1}.xlabel='Time [sec]';
option.ax{1}.YAxisLocation='origin';
option.ax{1}.ylabel_visible='on';
option.ax{1}.ylabel='Amp [\muV]';

%% option.axis{1}.content{1}: Target
option.ax{1}.content{1}.name='Target';
option.ax{1}.content{1}.type='curve';
option.ax{1}.content{1}.dataset=2;
option.ax{1}.content{1}.ch='Pz';
option.ax{1}.content{1}.color=[0.85,0.325,0.098];

%% option.axis{1}.content{2}: NonTarget
option.ax{1}.content{2}.name='NonTarget';
option.ax{1}.content{2}.type='curve';
option.ax{1}.content{2}.dataset=1;
option.ax{1}.content{2}.ch='Pz';
option.ax{1}.content{2}.color=[0,0.45098,0.74118];

%% option.axis{1}.content{3}: line3
option.ax{1}.content{3}.name='line3';
option.ax{1}.content{3}.type='line';
option.ax{1}.content{3}.x=[0.332,0.332];
option.ax{1}.content{3}.y=[-5,10.8619];

%% option.axis{2}: Target
option.ax{2}.name='Target';
option.ax{2}.pos=[70,50,250,250];
option.ax{2}.style='Image';
option.ax{2}.fontsize=12;
option.ax{2}.XlimMode='Manual';
option.ax{2}.Xlim=[-0.5,1.5];
option.ax{2}.xlabel_visible='on';
option.ax{2}.xlabel='Time [sec]';
option.ax{2}.ylabel_visible='on';
option.ax{2}.ylabel='Freq [Hz]';
option.ax{2}.climMode='Manual';
option.ax{2}.clim=[-9,9];

%% option.axis{2}.content{1}: image1
option.ax{2}.content{1}.name='image1';
option.ax{2}.content{1}.type='image';
option.ax{2}.content{1}.dataset=3;
option.ax{2}.content{1}.ch='Pz';
option.ax{2}.content{1}.contour_enable='on';
option.ax{2}.content{1}.contour_linewidth=0.5;
option.ax{2}.content{1}.contour_LevelListMode='Manual';
option.ax{2}.content{1}.contour_level_start=0;
option.ax{2}.content{1}.contour_level_end=0;
option.ax{2}.content{1}.contour_level_step=1;

%% option.axis{3}: Nontarget
option.ax{3}.name='Nontarget';
option.ax{3}.pos=[360,50,250,250];
option.ax{3}.style='Image';
option.ax{3}.fontsize=12;
option.ax{3}.XlimMode='Manual';
option.ax{3}.Xlim=[-0.5,1.5];
option.ax{3}.xlabel_visible='on';
option.ax{3}.xlabel='Time [sec]';
option.ax{3}.ylabel_visible='on';
option.ax{3}.ylabel='\muV^2/Hz';
option.ax{3}.colorbar='on';
option.ax{3}.climMode='Manual';
option.ax{3}.clim=[-9,9];

%% option.axis{3}.content{1}: image1
option.ax{3}.content{1}.name='image1';
option.ax{3}.content{1}.type='image';
option.ax{3}.content{1}.dataset=4;
option.ax{3}.content{1}.ch='Pz';
option.ax{3}.content{1}.contour_enable='on';
option.ax{3}.content{1}.contour_linewidth=0.5;
option.ax{3}.content{1}.contour_LevelListMode='Manual';
option.ax{3}.content{1}.contour_level_start=0;
option.ax{3}.content{1}.contour_level_end=0;
option.ax{3}.content{1}.contour_level_step=2;

%% option.axis{4}: 332 ms
option.ax{4}.name='332 ms';
option.ax{4}.pos=[480,470,120,120];
option.ax{4}.style='Topograph';
option.ax{4}.fontsize=12;
option.ax{4}.colorbar='on';

%% option.axis{4}.content{1}: topo1
option.ax{4}.content{1}.name='topo1';
option.ax{4}.content{1}.type='topo';
option.ax{4}.content{1}.dataset=2;
option.ax{4}.content{1}.x=[0.332,0.332];
option.ax{4}.content{1}.dim='2D';
option.ax{4}.content{1}.shrink=0.95;
option.ax{4}.content{1}.headrad=0.5;
option.ax{4}.content{1}.maplimits=[-5,10.8619];
option.ax{4}.content{1}.dotsize=8;
option.ax{4}.content{1}.mark={'Pz'};
GLW_figure(option);
