const { webpackConfig, merge } = require('@rails/webpacker');
// const webpack = require('webpack');
const dotenv = require('dotenv');

const dotenvFiles = [
  `.env.${process.env.NODE_ENV}.local`,
  '.env.local',
  `.env.${process.env.NODE_ENV}`,
  '.env'
];
dotenvFiles.forEach((dotenvFile) => {
  dotenv.config({ path: dotenvFile, silent: true });
});

// Is already included I think
// webpackConfig.plugins.prepend('Environment', new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env))));

// Set nested object prop using path notation
// environment.config.set('resolve.extensions', ['.foo', '.bar'])
// environment.config.set('output.filename', '[name].js')

// Delete a property
// environment.config.delete('output.chunkFilename')

const scssConfigIndex = webpackConfig.module.rules.findIndex((config) => ".scss".match(config.test))
webpackConfig.module.rules.splice(scssConfigIndex, 1)

const customConfig = require('./custom');

module.exports = merge(webpackConfig, customConfig);
