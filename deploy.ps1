#!/bin/bash

# PM2 部署脚本（Windows PowerShell 版本）
# 在云服务器上运行此脚本完成部署

Write-Host "=== 开始 PM2 部署 ===" -ForegroundColor Green

# 进入项目目录
$item = Get-Item -Path "$env:HOME/k-story" -ErrorAction SilentlyContinue
if (-not $item) {
    Write-Host "错误：k-story 目录不存在" -ForegroundColor Red
    exit 1
}
Set-Location -Path "$env:HOME/k-story"

# 拉取最新代码
Write-Host "拉取最新代码..." -ForegroundColor Yellow
if (-not (git pull origin main)) {
    Write-Host "错误：git pull 失败" -ForegroundColor Red
    exit 1
}

# 安装依赖
Write-Host "安装依赖..." -ForegroundColor Yellow
if (-not (npm install)) {
    Write-Host "错误：npm install 失败" -ForegroundColor Red
    exit 1
}

# 构建项目
Write-Host "构建项目..." -ForegroundColor Yellow
if (-not (npm run build)) {
    Write-Host "错误：npm run build 失败" -ForegroundColor Red
    exit 1
}

# 启动/重启应用
Write-Host "启动应用..." -ForegroundColor Yellow
if (pm2 list | Select-String -Pattern "k-story") {
    pm2 reload k-story --update-env
} else {
    Write-Host "首次启动，创建新应用..." -ForegroundColor Yellow
    pm2 delete k-story 2>$null
    pm2 start "npm" --name "k-story" -- start
}

# 保存 PM2 配置（开机自启）
Write-Host "保存 PM2 配置..." -ForegroundColor Yellow
pm2 save

# 显示应用状态
Write-Host "=== 部署完成 ===" -ForegroundColor Green
pm2 status
