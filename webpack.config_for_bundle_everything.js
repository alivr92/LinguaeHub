const path = require('path');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
    mode: 'production',
    entry: {
        // Bundle wizard and phone together
        wizard: ['./frontend/src/phone.js', './frontend/src/wizard.js'],
    },
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].bundle.js',
    },
    optimization: {
        minimizer: [
            new TerserPlugin({
                terserOptions: {
                    mangle: {
                        reserved: [
                            'validatePhoneNumber', 'selectCountry', 'countries',
                            'validate_profile', 'validate_skills', 'submit_skills'
                        ]
                    }
                }
            })
        ]
    },
    devtool: false
};