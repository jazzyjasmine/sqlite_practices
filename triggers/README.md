# README

## Build up database and test triggers
1. Create db: ```sqlite3 app.db < create_db.sql```
2. Populate db: ```sqlite3 app.db < populate_db.sql```
3. Add triggers to db: ```sqlite3 app.db < triggers.sql```
4. Run ```sqlite3 app.db < triggerscenatios.sql``` to check the effect of different type of modifications
