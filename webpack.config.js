const path = require('path');
const JavaScriptObfuscator = require('javascript-obfuscator');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
    mode: 'production',
    entry: {
        // wizard: './frontend/src/wizard.js',
        // edu: './frontend/src/edu.js',
        // phone: './frontend/src/phone.js',
        // method: './frontend/src/method.js',
        // pricing: './frontend/src/pricing.js',
        // review: './frontend/src/review.js',
        // skills: './frontend/src/skills.js',
        profile: './frontend/src/profile.js',
        availability: './frontend/src/availability.js',
    },
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].min.js',
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env']
                    }
                },
            }
        ]
    },
    optimization: {
        minimizer: [
            new TerserPlugin(),
            new (class {
                apply(compiler) {
                    compiler.hooks.emit.tap('Obfuscator', (compilation) => {
                        Object.keys(compilation.assets).forEach(name => {
                            if (name.endsWith('.js')) {
                                const asset = compilation.assets[name];
                                const obfuscated = JavaScriptObfuscator.obfuscate(
                                    asset.source(),
                                    {
                                        rotateStringArray: true,
                                        controlFlowFlattening: true,
                                        stringArray: true,
                                        stringArrayThreshold: 0.75
                                    }
                                );
                                compilation.assets[name] = {
                                    source: () => obfuscated.getObfuscatedCode(),
                                    size: () => obfuscated.getObfuscatedCode().length
                                };
                            }
                        });
                    });
                }
            })()
        ]
    },
    devtool: false
};