%%
% 图片颜色提取器
% 作者：Icanitm
% 时间：2025.04.20
% 功能：支持多点取色、色轮标注、标注RGB值，自动调整文字颜色对比度

%%
% 选择图片文件
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif','图片文件 (*.jpg,*.png,*.bmp,*.tif)'},'选择图片文件');
if isequal(filename,0), return; end
img = imread(fullfile(pathname, filename));

% 创建图形界面
hFig = figure('Name','高级颜色提取器', 'NumberTitle','off', ...
    'Position', [100 100 1200 600], 'KeyPressFcn', @closeFig);

% 左侧图像显示区域（调整Position参数使宽度更大）
hAxImg = axes('Parent', hFig, 'Position', [0.05 0.1 0.65 0.8]); % 宽度65%
imshow(img, 'Parent', hAxImg);
hold(hAxImg, 'on');
title('点击图片取色（ESC结束）');

% 右侧色轮区域（调整Position参数缩小宽度）
hAxWheel = axes('Parent', hFig, 'Position', [0.72 0.1 0.25 0.8]); % 宽度25%
[colorWheel, wheelCenter, wheelRadius] = createColorWheel(300);
hWheel = imshow(colorWheel, 'Parent', hAxWheel);
hold(hAxWheel, 'on');
axis(hAxWheel, 'equal');
axis(hAxWheel, 'off');
title('色轮颜色分布');

% 初始化变量并存储到appdata
colorData = struct('pos',[], 'rgb',[], 'hsv',[], 'text',[], 'marker',[]);
colorIndex = 0;
setappdata(hFig, 'hAxImg', hAxImg);
setappdata(hFig, 'img', img);
setappdata(hFig, 'colorData', colorData);
setappdata(hFig, 'colorIndex', colorIndex);
setappdata(hFig, 'hAxWheel', hAxWheel);
setappdata(hFig, 'wheelCenter', wheelCenter);
setappdata(hFig, 'wheelRadius', wheelRadius);

% 设置交互属性
set(hFig, 'Pointer', 'crosshair', 'WindowButtonDownFcn', @clickCallback);

% 点击回调函数
function clickCallback(~,~)
    % 获取存储数据
    hFig = gcbf();
    hAxImg = getappdata(hFig, 'hAxImg');
    img = getappdata(hFig, 'img');
    colorData = getappdata(hFig, 'colorData');
    colorIndex = getappdata(hFig, 'colorIndex');
    
    % 获取点击位置
    point = get(hAxImg, 'CurrentPoint');
    x = round(point(1,1));
    y = round(point(1,2));
    
    % 验证坐标有效性
    if x < 1 || x > size(img,2) || y < 1 || y > size(img,1), return; end
    
    % 提取颜色信息
    rgb = double(squeeze(img(y,x,:)))';
    hsv = rgb2hsv(rgb/255);
    
    % 更新颜色数据
    colorIndex = colorIndex + 1;
    colorData(colorIndex).pos = [x y];
    colorData(colorIndex).rgb = rgb;
    colorData(colorIndex).hsv = hsv;
    
    % 保存更新后的数据
    setappdata(hFig, 'colorData', colorData);
    setappdata(hFig, 'colorIndex', colorIndex);
    
    % 绘制标注
    drawImageAnnotation(hFig, hAxImg, x, y, rgb);
    drawWheelMarker(hFig, hsv, rgb);
end

% 创建色轮函数（保持不变）
function [wheel, center, radius] = createColorWheel(size)
    [X,Y] = meshgrid(1:size, 1:size);
    center = (size+1)/2;
    radius = center*0.95;

    theta = atan2(Y-center, X-center);
    theta(theta<0) = theta(theta<0) + 2*pi;
    r = hypot(X-center, Y-center);

    H = theta/(2*pi);
    S = ones(size).*(r<=radius).*r/radius;
    V = ones(size);

    wheel = hsv2rgb(cat(3, H, S, V));
    wheel(repmat(r>radius,1,1,3)) = 1; % 背景设为白色
end

% 图像标注绘制函数（修改参数传递）
function drawImageAnnotation(hFig, ax, x, y, rgb)
    % 获取当前颜色索引
    colorIndex = getappdata(hFig, 'colorIndex');
    
    % 计算文字颜色
    luminance = 0.299*rgb(1) + 0.587*rgb(2) + 0.114*rgb(3);
    txtColor = [0 0 0];
    if luminance < 128, txtColor = [1 1 1]; end
    
    % 绘制标记
    plot(ax, x, y, 'o', 'MarkerSize',6, ...
        'MarkerEdgeColor',txtColor, 'MarkerFaceColor',rgb/255, ...
        'LineWidth',1);
    
    % 添加文字说明
    text(ax, x+65, y, sprintf('%d-RGB(%d,%d,%d)',colorIndex,rgb), ...
        'Color',txtColor, 'FontSize',10, 'FontWeight','bold',...
        'BackgroundColor',rgb/255, 'Margin',1,...
        'HorizontalAlignment','left', 'VerticalAlignment','middle');
end

% 色轮标记绘制函数（修改参数传递）
function drawWheelMarker(hFig, hsv, rgb)
    % 获取色轮参数
    hAxWheel = getappdata(hFig, 'hAxWheel');
    wheelCenter = getappdata(hFig, 'wheelCenter');
    wheelRadius = getappdata(hFig, 'wheelRadius');
    colorIndex = getappdata(hFig, 'colorIndex');
    
    % 计算标记位置
    theta = hsv(1)*2*pi;
    x = wheelCenter + wheelRadius*cos(theta)*hsv(2);
    y = wheelCenter + wheelRadius*sin(theta)*hsv(2);
    
    % 自动选择标记样式
    markerTypes = {'o', 's', '^', 'v', 'd'};
    marker = markerTypes{mod(colorIndex-1,5)+1};
    
    % 绘制色轮标记
    plot(hAxWheel, x, y, marker, 'MarkerSize',6, ...
        'MarkerEdgeColor','k', 'MarkerFaceColor',rgb/255,...
        'LineWidth',1);
    
    % 添加编号
    text(hAxWheel, x+8, y+8, num2str(colorIndex),...
        'Color','k', 'FontSize',10, 'FontWeight','bold');
end

% 窗口关闭函数（修改数据获取方式）
function closeFig(~,evt)
    if strcmp(evt.Key, 'escape')
        hFig = gcbf();
        colorData = getappdata(hFig, 'colorData');
        colorIndex = getappdata(hFig, 'colorIndex');
        
        % 输出颜色报告
        fprintf('\n=== 颜色提取报告 ===\n');
        fprintf('%-6s %-12s %-16s %s\n', '序号', '坐标', 'RGB值', 'HSV值');
        for i = 1:colorIndex
            fprintf('%-6d (%-4d,%-4d) [%3d,%3d,%3d]  [%.2f,%.2f,%.2f]\n',...
                i, colorData(i).pos(1), colorData(i).pos(2),...
                colorData(i).rgb(1), colorData(i).rgb(2), colorData(i).rgb(3),...
                colorData(i).hsv(1), colorData(i).hsv(2), colorData(i).hsv(3));
        end
        % close(hFig);
    end
end