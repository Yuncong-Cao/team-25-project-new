FROM cirrusci/flutter:latest AS build

WORKDIR /app

# 允许 root 权限运行（如果需要）
ENV FLUTTER_ALLOW_ROOT=1

# 复制整个 Flutter 项目
COPY . .

# 安装依赖
RUN flutter pub get

# 构建 Web
RUN flutter build web

# 使用 Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
