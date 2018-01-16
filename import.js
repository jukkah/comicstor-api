const { Client } = require('pg');
const fs = require('fs');

/**
 * Find and replace environment variables by their values in text and then
 * return it.
 *
 * @param {String} text input with placeholders
 * @returns String output with values
 */
function replaceEnvVars(text) {
    Object.keys(process.env).forEach((name) => {
        const value = process.env[name];
        text = text.replace(new RegExp(`\\$(${name}|\\{${name}\\})`, 'g'), value);
    });

    return text;
}

const client = new Client({
    connectionString: process.env.DATABASE_URL_ROOT,
    ssl: process.env.NODE_ENV === 'production',
});
client.connect();

fs.readFile('/tmp/import.sql', 'utf8', function (err, data) {
    if (err) {
        console.log(err);
        process.exit(1);
    }

    data = replaceEnvVars(data);

    client.query(data, (err, res) => {
        if (err) {
            console.log(err);
            process.exit(1);
        }
        client.end()
    });
});
