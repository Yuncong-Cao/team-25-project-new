# 使用 Flutter 3.7.0 作为基础镜像
FROM cirrusci/flutter:3.7.0

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 安装依赖
RUN flutter pub get

# 暴露端口
EXPOSE 8080

# 启动 Flutter 应用
CMD ["flutter", "run", "--web-port", "8080", "--web-hostname", "0.0.0.0"]