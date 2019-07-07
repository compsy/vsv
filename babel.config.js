module.exports = {
  "presets": [
    [
      "@babel/preset-env",
      {
        "modules": false,
        "forceAllTransforms": true,
        "useBuiltIns": "entry"
      }
    ],
    [
      "@babel/preset-react",
      {
        "useBuiltIns": true
      }
    ]
  ],
  "plugins": [
    "@babel/plugin-transform-destructuring",
    "@babel/plugin-syntax-dynamic-import",
    [
      "@babel/plugin-proposal-object-rest-spread",
      {
        "useBuiltIns": true
      }
    ],
    [
      "@babel/plugin-transform-runtime",
      {
        "helpers": false,
        "regenerator": true
      }
    ],
    [
      "@babel/plugin-transform-regenerator",
      {
        "async": false
      }
    ],
    [
      "@babel/plugin-proposal-class-properties",
      {
        "loose": true,
        "spec": true
      }
    ]
  ],
  "env": {
    "test": {
      "presets": [
        ["@babel/env", { "modules": "commonjs" }] // CommonJS imports only in test env because Jest runs in Node, and thus requires ES modules to be transpiled to CommonJS modules.
      ]
    }
  }
};
