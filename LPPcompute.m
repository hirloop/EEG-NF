%% 数据处理逻辑；识别mark为'2'，'22'，时间窗为[-0.2,3],电极点COI=[7 8 19 57 58]
function [EEG, value, z_value]=LPPcompute(eegmb,blockData,bMarker,M,SD)
    disp(char(datetime));
    % 导入为eeglab数据格式，注意data，srate，chanlocs
    EEG = pop_importdata('dataformat','array','nbchan',0,'data',blockData,'setname','hhh','srate',1000,'pnts',0,'xmin',0,'chanlocs',{eegmb.chanlocs eegmb.chaninfo eegmb.urchanlocs});
    EEG = pop_importevent( EEG, 'event',bMarker,'fields',{'latency','type'},'timeunit',1);
    %电极定位,弃用电极
    EEG = pop_select( EEG, 'rmchannel',{'HEOG','VEOG','IO', 'FT9', 'FT10'});         %去除眼电，HEOG，VEOG
    %滤波
    EEG = pop_eegfiltnew(EEG, 'locutoff',0.1);        %高通滤波，保留>0.1hz的；末尾改0表示不画图
    EEG = pop_eegfiltnew(EEG, 'hicutoff',40);                       %低通，保留<40hz的；不加'plotfreqz'亦表示不画图
    EEG = pop_eegfiltnew(EEG, 'locutoff',49,'hicutoff',51,'revfilt',1);     % 带阻滤波
    %降采样
    EEG = pop_resample( EEG, 500);     %500即降成500HZ
    %提取分段、基线校正
    EEG = pop_epoch( EEG, {  '2' '22' }, [-0.2 3], 'newname',  'resampled epochs', 'epochinfo', 'yes');  %分段，区间为event的出现前0.2s到出现后6s，自行设置
    EEG = pop_rmbase( EEG, [-200 0] ,[]);    %选择前200ms到0ms进行基线校正
    %重参考
    EEG = pop_reref( EEG, [28 29] );   %填电极的编号，自己在plot-channellocation-by name中点击左键查看对应电极编号。此处为双侧乳突
    %LPP提取（即相应通道，相应时间点）
    TOI=find(EEG.times>400&EEG.times<600);COI=[7 8 19 57 58]; %电极点序号
    value=EEG.data(COI,TOI,:);value=mean(value,'ALL');%z_value=(value-M)/SD;
    txt_path='value.txt';

    for iii = 1:5
        try         %若失败，仅跳出try循环!
            fid = fopen(txt_path, 'w');
            fprintf(fid, '%f', z_value); % 写入数值，可根据需要调整格式
            fclose(fid);       
            disp(z_value);
            break;  %若成功，则直接跳出上一级的for循环！
        end
    end
    disp(char(datetime));
end