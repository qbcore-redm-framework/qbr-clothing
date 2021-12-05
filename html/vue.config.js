module.exports = {
    chainWebpack: config => {
        config.plugin('preload').tap(args => {
            args[0].fileBlacklist.push(/\.css/, /\.js/);
            return args;
        });

        config
            .plugin('inline-source')
            .use(require('html-webpack-inline-source-plugin'));

        config.plugin('html').tap(args => {
            args[0].inlineSource = '.(js|css)$';
            return args;
        });

        config.module
            .rule('ifdef')
            .test(/\.(vue|js)?$/)
            .exclude.add(/node_modules/)
            .end();
    },
    filenameHashing: false,
    productionSourceMap: false,
    publicPath: './',
    transpileDependencies: [
        'vuetify'
    ],
    css: {
        requireModuleExtension: false
    }
}
