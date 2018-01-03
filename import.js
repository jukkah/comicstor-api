const { Client } = require('pg');
const fs = require('fs');

const client = new Client({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production',
});
client.connect();

fs.readFile('/tmp/import.sql', 'utf8', function (err, data) {
    if (err) {
        console.log(err);
        process.exit(1);
    }

    client.query(data, (err, res) => {
        if (err) {
            console.log(err);
            process.exit(1);
        }
        client.end()
    });
});
