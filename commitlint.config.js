module.exports = {
    extends: ['@commitlint/config-conventional'],
    rules: {
        'subject-case': [0],
        'subject-full-stop': [0],
        'body-max-line-length': [2, 'always', 120],
        'footer-max-line-length': [2, 'always', 120],
        'header-max-length': [2, 'always', 72],
    },
};
