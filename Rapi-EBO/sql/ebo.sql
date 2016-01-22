DROP TABLE IF EXISTS [contest];
CREATE TABLE [contest] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [name] varchar(32) NOT NULL
);
INSERT INTO [contest] VALUES ('1','Democratic Primary');
INSERT INTO [contest] VALUES ('2','Republican Primary');
INSERT INTO [contest] VALUES ('3','Presidency');


DROP TABLE IF EXISTS [candidate];
CREATE TABLE [candidate] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [name] varchar(32) NOT NULL,
  [full_name] varchar(32) NOT NULL
);

DROP TABLE IF EXISTS [tick];
CREATE TABLE [tick] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [ts] datetime NOT NULL,
  [contest_id] INTEGER NOT NULL,
  [candidate_id] INTEGER NOT NULL,
  [pct] decimal(4,2) NOT NULL
);
