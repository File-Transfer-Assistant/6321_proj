% =========================================================================
% 1024-point FFT FP32 Golden Model (全量 10 帧处理版)
% 目标：读取 Hex，循环处理 10 帧，批量保存 TXT，并绘制 3D 瀑布频谱图
% =========================================================================

clear; clc; close all;

%% 1. 参数设置
N = 1024;            % FFT 点数
num_frames = 10;     % 总帧数 (10240 / 1024 = 10)
input_file = 'input_fp32_v3.hex';

%% 2. 读取并解析 FP32 Hex 文件
fid = fopen(input_file, 'r');
if fid == -1
    error('无法打开输入文件 %s，请确认文件位置！', input_file);
end
hex_str_cell = textscan(fid, '%s');
fclose(fid);

uint32_data = uint32(hex2dec(hex_str_cell{1}));
in_data_fp32 = typecast(uint32_data, 'single');

disp(['✅ 成功加载输入数据: ', num2str(length(in_data_fp32)), ' points.']);

if length(in_data_fp32) < N * num_frames
    warning('警告：数据总点数不足 10240 点，可能无法跑满 10 帧！');
end

%% 3. 循环处理 10 帧数据
% 创建一个矩阵用来存所有帧的幅值，方便后面画 3D 图
all_magnitudes = zeros(num_frames, N); 

disp('⏳ 开始批量处理 10 帧 FFT...');

for frame_idx = 1:num_frames
    % 计算当前帧的起止索引
    start_idx = (frame_idx - 1) * N + 1;
    end_idx = frame_idx * N;
    
    % 截取当前帧数据
    x_n = in_data_fp32(start_idx:end_idx);
    
    % 计算 Golden FFT
    X_k_golden = fft(x_n, N);
    
    % 提取幅值和相位
    magnitude = abs(X_k_golden);
    phase = angle(X_k_golden); 
    
    % 存入大矩阵中
    all_magnitudes(frame_idx, :) = magnitude;
    
    % --- 保存为 TXT 格式 ---
    txt_filename = sprintf('golden_result_frame%02d.txt', frame_idx);
    fid_out = fopen(txt_filename, 'w');
    fprintf(fid_out, '%% Index \t Real \t\t Imaginary \t Magnitude \t Phase(rad)\n');
    for i = 1:N
        fprintf(fid_out, '%d\t %.6f\t %.6f\t %.6f\t %.6f\n', ...
                i-1, real(X_k_golden(i)), imag(X_k_golden(i)), magnitude(i), phase(i));
    end
    fclose(fid_out);
    
    disp(['  💾 已保存: ', txt_filename]);
end

disp('🎉 全部 10 帧数据处理及保存完毕！');

%% 4. 绘制 10 帧频谱 3D 瀑布图 (Waterfall Plot)
% 这种图放在论文或报告里非常专业，能一眼看出频谱随时间(帧)的变化
figure('Name', '10-Frame FFT Magnitude Spectrogram', 'Position', [150, 150, 900, 600]);

k_bins = 0:(N-1);           % X 轴：频率 Bin
frames = 1:num_frames;      % Y 轴：帧号

% 绘制瀑布图
waterfall(k_bins, frames, all_magnitudes);

% 美化图表
title('3D Magnitude Spectrum across 10 Frames (FP32 Golden Model)', 'FontSize', 14);
xlabel('Frequency Bin (k)', 'FontSize', 12);
ylabel('Frame Number', 'FontSize', 12);
zlabel('Magnitude |X(k)|', 'FontSize', 12);
xlim([0 N-1]);
ylim([1 num_frames]);
set(gca, 'YDir', 'reverse'); % 让第 1 帧在最前面
colormap(jet);               % 加上好看的伪彩色

% 调整视角，让你看得很清楚
view(35, 45);
