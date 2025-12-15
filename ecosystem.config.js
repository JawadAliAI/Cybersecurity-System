module.exports = {
  apps: [
    {
      name: 'cybersec-backend',
      script: './start_backend.sh',
      cwd: '/home/cybersec/cybersecurity-project/backend',
      interpreter: '/bin/bash',
      env: {
        NODE_ENV: 'production',
        PYTHONUNBUFFERED: '1'
      },
      error_file: '/home/cybersec/logs/backend-error.log',
      out_file: '/home/cybersec/logs/backend-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      autorestart: true,
      max_restarts: 10,
      min_uptime: '10s',
      restart_delay: 4000,
      watch: false,
      instances: 1,
      exec_mode: 'fork'
    },
    {
      name: 'cybersec-frontend',
      script: 'npm',
      args: 'start',
      cwd: '/home/cybersec/cybersecurity-project/frontend',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      error_file: '/home/cybersec/logs/frontend-error.log',
      out_file: '/home/cybersec/logs/frontend-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      autorestart: true,
      max_restarts: 10,
      min_uptime: '10s',
      restart_delay: 4000,
      watch: false,
      instances: 1,
      exec_mode: 'fork'
    }
  ]
};
