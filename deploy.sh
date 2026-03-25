# PM2 部署脚本
# 在云服务器上运行此脚本完成部署

echo "=== 开始 PM2 部署 ==="

# 进入项目目录
cd ~/k-story || {
  echo "错误：k-story 目录不存在"
  exit 1
}

# 拉取最新代码
echo "拉取最新代码..."
git pull origin main || {
  echo "错误：git pull 失败"
  exit 1
}

# 安装依赖
echo "安装依赖..."
npm install || {
  echo "错误：npm install 失败"
  exit 1
}

# 构建项目
echo "构建项目..."
npm run build || {
  echo "错误：npm run build 失败"
  exit 1
}

# 启动/重启应用
echo "启动应用..."
pm2 reload k-story --update-env 2>/dev/null || {
  echo "首次启动，创建新应用..."
  pm2 delete k-story 2>/dev/null || true
  pm2 start ecosystem.config.js
}

# 保存 PM2 配置（开机自启）
echo "保存 PM2 配置..."
pm2 save

# 显示应用状态
echo "=== 部署完成 ==="
pm2 status
