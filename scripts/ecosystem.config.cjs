'use strict';

const path = require('path');

const config = require('../config.json');
const webPort = config.ports?.web;
if (webPort === undefined || webPort === null || webPort === '') {
  throw new Error('config.json: ports.web is not set');
}

module.exports = {
  apps: [
    {
      name: 'game-studio-web',
      script: path.join(__dirname, 'serve-static.cjs'),
      env: {
        SERVE_PATH: path.join(__dirname, '..', 'web'),
        SERVE_PORT: String(webPort),
      },
    },
  ],
};
