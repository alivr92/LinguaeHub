const path = require('path');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
    mode: 'production',
    entry: {
        // Dynamic entry - automatically picks up all JS files
        // This will create separate files for each JS file
        // but you need to specify them manually for better control
    },
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].min.js',
        library: {
            type: 'var', // Export as global variables
            name: '[name]'
        }
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env'],
                        plugins: [
                            '@babel/plugin-transform-modules-umd' // Universal Module Definition
                        ]
                    }
                },
            }
        ]
    },
    optimization: {
        minimizer: [
            new TerserPlugin({
                terserOptions: {
                    mangle: false, // Safe option for future files
                    compress: {
                        drop_console: false
                    }
                }
            })
        ]
    },
    devtool: false
};