本项目依赖MATLAB的[eeglab](https://sccn.ucsd.edu/eeglab/download.php)、[liblsl-Matlab](https://github.com/labstreaminglayer/liblsl-Matlab)工具包，使用BP官方提供的放大器[LSL插件](https://www.brainproducts.com/downloads/more-software/#lsl)进行推流后，运行rtEEGf即可自动搜索并创建相应数据流，此时已能够进行EEG任务态信号的实时接收与自定义计算。
<img width="557" height="527" alt="4465035c-893c-4390-a897-f4fda6f89d91" src="https://github.com/user-attachments/assets/e4ee9bce-9122-4914-8b4d-32aa4e0db854" />

演示功能为截取每block（mark 1 开始，mark 3 结束）数据，计算不同条件（mark 2、mark 22）刺激诱发LPP波幅的block平均值，暂存于value.txt中，被e-prime程序（EEG-NF.es2）实时读取且可视化。
<img width="1920" height="1080" alt="876b30c8-4430-486c-8e95-7e53fd739d41" src="https://github.com/user-attachments/assets/f1d708f8-c51b-45a5-8e6e-26f463a948d3" />

eegmb.mat为同设备同workspace文件下的channel location信息，用于直接提供所接收EEG信号流的通道相关信息，以进行后续预处理和分析。
