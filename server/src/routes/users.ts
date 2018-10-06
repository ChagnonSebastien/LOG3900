import * as express from 'express';
import { PostgresDatabase } from '../postgres-database';

export class UsersRoute {

    public async getAll(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM Users').then((query) => {
            if (query.rowCount > 0) {
                res.send(query.rows.map((row) => {
                    return {
                        id: row.Id,
                        username: row.Username,
                        userLevel: row.UserLevel,
                    };
                }));
            }
            res.sendStatus(404); // Not found
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async get(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const userId = req.params.id;
        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM Users WHERE "Id" = $1', [userId]).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.send({
                    id: result.Id,
                    username: result.Username,
                    userLevel: result.UserLevel,
                });
            }
            res.sendStatus(404);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async post(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const preparedQuery = {
            text: 'INSERT INTO Users("Username", "Password") VALUES($1, $2) RETURNING *',
            values: [req.body.username, req.body.password],
        };
        const db = await PostgresDatabase.getInstance();
        db.query(preparedQuery).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.status(201);
                res.send({
                    id: result.Id,
                    username: result.Username,
                    userLevel: result.UserLevel,
                });
            }
            res.sendStatus(204);
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }

    public async update(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        let updates = [
            ['Username', req.body.username],
            ['Password', req.body.password],
            ['UserLevel', req.body.userLevel],
        ];
        updates = updates.filter((update) => update[1] !== undefined);
        if (updates.length === 0) {
            res.sendStatus(400);
        }

        // Build the query : UPDATE Users SET col1 = val1, col2 = val2, ... WHERE Id = <id>;
        let queryText = 'UPDATE Users SET ';
        updates.forEach((update, i) => {
            queryText += `"${update[0]}" = $${i + 1}`;
            if (i !== updates.length - 1) {
                queryText += ',';
            }
        });
        queryText += ` WHERE "Id" = $${updates.length + 1} RETURNING *`;

        const preparedQuery = {
            text: queryText,
            values: updates.map((update) => update[1]).concat([req.params.id]),
        };

        // Query the database
        const db = await PostgresDatabase.getInstance();
        db.query(preparedQuery).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                res.status(201);
                res.send({
                    id: result.Id,
                    username: result.Username,
                    userLevel: result.UserLevel,
                });
            }
            res.sendStatus(204);
        })
            .catch((err) => {
                res.sendStatus(404); // Bad request
            });
    }
}
