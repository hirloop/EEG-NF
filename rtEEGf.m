%搜索所有流EEG数据流和事件标记流
markerStreams = {};eegstreams = {};
while isempty(markerStreams)||isempty(eegstreams)
    eegstreams = lsl_resolve_byprop(lsl_loadlib(), 'type', 'EEG');
    markerStreams = lsl_resolve_byprop(lsl_loadlib(), 'type', 'Markers');  
end
disp(['找到流: ' eegstreams{1}.name()]);
disp(['找到事件标记流: ' markerStreams{1}.name()]);
% 创建输入流
inlet = lsl_inlet(eegstreams{1});
markerInlet = lsl_inlet(markerStreams{1});



% 初始化参数；接收数据
data=[];time=[];markers={};markerTime=[];load('eegmb.mat');
n=0;BS=0;BE=0;blockData=[];blockMarkerTime=[]; LPP=[];zLPP=[];
while true
    [markerValues, markerStamps] = markerInlet.pull_sample(0);  % 0为非阻塞读取pull_sample(0)
    if ~isempty(markerStamps)
        n=n+1;
        disp(['收到事件: ' markerValues{1} ' @ ' num2str(markerStamps)]);
        markers= [markers;markerValues{1}];markerTime = [markerTime;markerStamps];
    end

    [chunk, timestamp] = inlet.pull_chunk();
    if ~isempty(chunk)
%         disp(['收到数据: ' num2str(size(chunk,2)) ' 个 ']);
        data=[data,chunk];time=[time;timestamp'];
    end
%     plot(data(30,[end-500:end])');pause(0.5);end%
    % 获取block开始、结束的时间点（样本点位置）;msidx=find(markerTime==markerStamps,1);
    if ~isempty(markerValues) && strcmp(markerValues{1},'1') 
        BS=1;msidx=n;
        [~, BSidx] = min(abs(time - markerStamps));
    end
    if ~isempty(markerValues) && strcmp(markerValues{1},'3')
        BE=1;meidx=n;
        [~, BEidx] = min(abs(time - markerStamps));
    end
    % 提取该block数据！
    if BS==1 && BE==1
        BS=0;BE=0;
        blockData=data(:,BSidx:BEidx);blockTime=time(BSidx:BEidx);
        blockMarker=markers(msidx:meidx);blockMarkerTime=markerTime(msidx:meidx);
        stime=blockTime(1);blockTime=blockTime-stime;blockMarkerTime=blockMarkerTime-stime;
        bMarker=[num2cell(blockMarkerTime) blockMarker];
        [EEG,value,z_value]=LPPcompute(eegmb,blockData,bMarker,M,SD);    %算LPP
        LPP=[LPP value];%zLPP=[zLPP z_value];
    end
end
