process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const webpackConfig = require('./base')

// Re-generate manifest file when not in test env
// https://github.com/danethurber/webpack-manifest-plugin
environment.plugins.get('Manifest').opts.writeToFileEmit = process.env.NODE_ENV !== 'test'

// Use inline-source-map devtool,
// https://webpack.js.org/configuration/devtool/
environment.config.set('devtool', 'inline-source-map')

module.exports = webpackConfig
