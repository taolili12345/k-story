# 使用更具体的镜像版本（基于 sha256）
FROM node:20-alpine@sha256:b88333c42c23fbd91596ebd7fd10de239cedab9617de04142dde7315e3bc0afa AS builder

# 设置工作目录
WORKDIR /app

# 只复制 package.json 并安装依赖
COPY package.json ./
RUN npm install --production

# 复制项目文件
COPY . .

# 构建 Next.js（生产构建）
RUN npm run build

# 清理 node_modules 中的无用文件（减少镜像体积）
RUN rm -rf node_modules && \
    npm install --production && \
    npm cache clean --force

# 生产环境镜像
FROM node:20-alpine@sha256:b88333c42c23fbd91596ebd7fd10de239cedab9617de04142dde7315e3bc0afa

# 安装 iconv-lite 依赖（处理 GBK 编码）
RUN apk add --no-cache python3 g++ make

WORKDIR /app

# 复制构建产物
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/content ./content
COPY --from=builder /app/src ./src
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/tsconfig.json ./
COPY --from=builder /app/postcss.config.js ./

# 暴露端口
EXPOSE 3000

# 启动 Next.js 生产服务器
CMD ["npm", "start"]
