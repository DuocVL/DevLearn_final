const languageConfig = {
    python: {
        image: 'codejudge-env', 
        srcFileName: 'main.py',
        containerDir: '/app',
        compileCmd: null, 
        runCmd: {
            cmd: 'python3', 
            args: ['main.py']
        }
    },
    cpp: {
        image: 'codejudge-env', 
        srcFileName: 'main.cpp',
        containerDir: '/app',
        compileCmd: {
            cmd: 'g++',
            args: ['main.cpp', '-o', 'a.out', '-std=c++17']
        },
        runCmd: {
            cmd: './a.out',
            args: []
        }
    }
};

function getLanguageConfig(language) {
    return languageConfig[language];
}

module.exports = { getLanguageConfig };
