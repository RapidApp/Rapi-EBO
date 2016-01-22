DROP TABLE IF EXISTS [contest];
CREATE TABLE [contest] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [name] varchar(32) UNIQUE NOT NULL
);
INSERT INTO [contest] VALUES ('1','Democratic Primary');
INSERT INTO [contest] VALUES ('2','Republican Primary');
INSERT INTO [contest] VALUES ('3','Presidency');


DROP TABLE IF EXISTS [candidate];
CREATE TABLE [candidate] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [name] varchar(32) UNIQUE NOT NULL,
  [full_name] varchar(32)
);

DROP TABLE IF EXISTS [dataset];
CREATE TABLE [dataset] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [ts] datetime UNIQUE NOT NULL
);

DROP TABLE IF EXISTS [tick];
CREATE TABLE [tick] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [dataset_id] INTEGER NOT NULL,
  [contest_id] INTEGER NOT NULL,
  [candidate_id] INTEGER NOT NULL,
  [pct] decimal(4,2) NOT NULL,
  
  FOREIGN KEY ([dataset_id]) REFERENCES [dataset] ([id]) 
   ON DELETE CASCADE ON UPDATE RESTRICT,
   
  FOREIGN KEY ([contest_id]) REFERENCES [contest] ([id]) 
   ON DELETE CASCADE ON UPDATE RESTRICT,
   
  FOREIGN KEY ([candidate_id]) REFERENCES [candidate] ([id]) 
   ON DELETE CASCADE ON UPDATE RESTRICT
  
);
  
