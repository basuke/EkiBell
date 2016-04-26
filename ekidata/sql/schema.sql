CREATE TABLE lines(
	id INTEGER PRIMARY KEY,
	name VAR CHAR(255) NOT NULL,
	short_name VAR CHAR(255) NOT NULL,
	color INTEGER,
	icon_name VAR CHAR(255)
);

CREATE TABLE stations (
	id INTEGER PRIMARY KEY,
	name VAR CHAR(255) NOT NULL,
	latitude REAL NOT NULL,
	longitude REAL NOT NULL,
	group_id INTEGER NOT NULL,
	line_id INTEGER NOT NULL,
	type INTEGER NOT NULL,
	sort INTEGER NOT NULL
);

CREATE INDEX lines_id ON lines(id);
CREATE INDEX stations_id ON stations(id);
CREATE INDEX stations_latitude ON stations(latitude);
CREATE INDEX stations_longitude ON stations(longitude);
CREATE INDEX stations_group_id ON stations(group_id);
CREATE INDEX stations_line_id ON stations(line_id);
