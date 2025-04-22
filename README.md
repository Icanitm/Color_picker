# 简易取色器
 
## 🎨 项目背景
在使用Microsoft Visio进行专业绘图时，保持多图形间的色彩一致性是常见需求。然而，Visio原生缺乏取色器功能，本人常用解决方案（如微信截图提取HEX码）存在以下痛点：
- 仅支持实时截图取色，无法保存历史记录
- 每次只能识别单个颜色值
- 缺乏色彩搭配可视化工具
 
## 🌟 功能
1. **多色值提取**  
   通过MATLAB图像分析算法，可批量提取图片中任意位置的RGB颜色值
 
2. **色轮映射**  
   自动将提取颜色映射到HSV色彩空间，生成可视化色轮：
   - 色相环展示颜色分布
   - 色相/饱和度坐标辅助配色分析
   - 支持多颜色同时对比
 
3. **设计场景**  
   特别针对以下场景设计：
   - Visio图形配色规范制定
   - 摄影后期调色参考
   - 数字绘画色彩搭配学习
 
## 📸 使用示例
![image](https://github.com/Icanitm/Color_picker/blob/main/demo.png)
*图示说明：左侧为原始图片取色区域，右侧色轮显示提取颜色的HSL映射位置*
 
## ⚠️ 技术说明
1. **色轮映射原理**  
   采用HSV色彩空间转换算法，将RGB值转换为色相(H)/饱和度(S)/明度(V)三维坐标。由于色轮仅展示二维色相-饱和度平面，明度信息会被投影处理，可能导致：
   - 深色系颜色在色轮中心区域显示异常
   - 同色相不同明度颜色可能重叠
  
# Simple Color Picker
 
## 🎨 Project Background
Maintaining color consistency across multiple shapes in Microsoft Visio is a common requirement for professional diagramming. However, Visio lacks a native color picker, and my 
traditional workarounds like WeChat screenshot color extraction have significant limitations:
- Real-time color capture only (no history preservation)
- Single color value detection per operation
- Lack of color harmony visualization tools
 
## 🌟 Core Features
1. **Multi-color Extraction**  
   Utilizes MATLAB image analysis algorithms to batch extract RGB values from any positions in an image.
 
2. **Color Wheel Mapping**  
   Automatically converts extracted colors to HSV color space and generates visual color wheels:
   - Hue circle for color distribution analysis
   - Hue/Saturation coordinates for color matching
   - Simultaneous multi-color comparison
 
3. **Use Cases**  
   Specifically designed for:
   - Visio diagram color standardization
   - Photography post-processing references
   - Digital painting color scheme studies
 
## 📸 Live Demo
![Interface Demonstration](main/demo.png)  
*Left: Original image sampling area | Right: HSL-mapped color wheel visualization*
 
## ⚠️ Technical Specifications
1. **Color Mapping Methodology**  
   Employs HSV color space conversion algorithm, projecting RGB values into hue(H)/saturation(S)/value(v) coordinates. Note that:
   - Dark colors may appear anomalous in the wheel center
   - Same-hue different-value colors may overlap
 
 
