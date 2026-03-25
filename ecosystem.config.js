module.exports = {
  apps: [
    {
      name: 'k-story',
      script: 'npm',
      args: 'start',
      instances: 'max',
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        PORT: 3000,
      },
      env_production: {
        NODE_ENV: 'production',
      },
      watch: false,
      ignore_watch: ['node_modules', '.next', 'content'],
      max_memory_restart: '1G',
      log_date_format: 'YYYY-MM-DD HH:mm:ss',
      error_file: './logs/err.log',
      out_file: './logs/out.log',
      combine_logs: true,
    },
  ],
};
