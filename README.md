本项目依赖MATLAB的[eeglab](https://sccn.ucsd.edu/eeglab/download.php)、[liblsl-Matlab](https://github.com/labstreaminglayer/liblsl-Matlab)工具包，运行rtEEGf即可进行EEG信号实时接收与计算。

演示功能为提取最近 n TR的数据，计算全脑（aal模板）功能连接，并同目标功能连接模式（FCtemplate.mat）计算表征相似性指标，暂存于value.txt中，被e-prime程序（rt-fMRI.es3）实时读取且可视化。

test.bat用于模拟逐TR接收dcm数据（从example dcm中每2s转移一个dcm文件进数据文件夹test\dcm中）。
