
DROP TABLE IF EXISTS [color];
CREATE TABLE [color] (
  [name] varchar(32) PRIMARY KEY NOT NULL,
  [hex] char(7) NOT NULL,
  [red] int(3) NOT NULL,
  [green] int(3) NOT NULL,
  [blue] int(3) NOT NULL
);

INSERT INTO [color] VALUES('lightpink','#FFB6C1','255','182','193');
INSERT INTO [color] VALUES('pink','#FFC0CB','255','192','203');
INSERT INTO [color] VALUES('crimson','#DC143C','220','20','60');
INSERT INTO [color] VALUES('lavenderblush','#FFF0F5','255','240','245');
INSERT INTO [color] VALUES('palevioletred','#DB7093','219','112','147');
INSERT INTO [color] VALUES('hotpink','#FF69B4','255','105','180');
INSERT INTO [color] VALUES('deeppink','#FF1493','255','20','147');
INSERT INTO [color] VALUES('mediumvioletred','#C71585','199','21','133');
INSERT INTO [color] VALUES('orchid','#DA70D6','218','112','214');
INSERT INTO [color] VALUES('thistle','#D8BFD8','216','191','216');
INSERT INTO [color] VALUES('plum','#DDA0DD','221','160','221');
INSERT INTO [color] VALUES('violet','#EE82EE','238','130','238');
INSERT INTO [color] VALUES('fuchsia','#FF00FF','255','0','255');
INSERT INTO [color] VALUES('darkmagenta','#8B008B','139','0','139');
INSERT INTO [color] VALUES('purple','#800080','128','0','128');
INSERT INTO [color] VALUES('mediumorchid','#BA55D3','186','85','211');
INSERT INTO [color] VALUES('darkviolet','#9400D3','148','0','211');
INSERT INTO [color] VALUES('darkorchid','#9932CC','153','50','204');
INSERT INTO [color] VALUES('indigo','#4B0082','75','0','130');
INSERT INTO [color] VALUES('blueviolet','#8A2BE2','138','43','226');
INSERT INTO [color] VALUES('mediumpurple','#9370DB','147','112','219');
INSERT INTO [color] VALUES('mediumslateblue','#7B68EE','123','104','238');
INSERT INTO [color] VALUES('slateblue','#6A5ACD','106','90','205');
INSERT INTO [color] VALUES('darkslateblue','#483D8B','72','61','139');
INSERT INTO [color] VALUES('ghostwhite','#F8F8FF','248','248','255');
INSERT INTO [color] VALUES('lavender','#E6E6FA','230','230','250');
INSERT INTO [color] VALUES('blue','#0000FF','0','0','255');
INSERT INTO [color] VALUES('mediumblue','#0000CD','0','0','205');
INSERT INTO [color] VALUES('darkblue','#00008B','0','0','139');
INSERT INTO [color] VALUES('navy','#000080','0','0','128');
INSERT INTO [color] VALUES('midnightblue','#191970','25','25','112');
INSERT INTO [color] VALUES('royalblue','#4169E1','65','105','225');
INSERT INTO [color] VALUES('cornflowerblue','#6495ED','100','149','237');
INSERT INTO [color] VALUES('lightsteelblue','#B0C4DE','176','196','222');
INSERT INTO [color] VALUES('lightslategray','#778899','119','136','153');
INSERT INTO [color] VALUES('slategray','#708090','112','128','144');
INSERT INTO [color] VALUES('dodgerblue','#1E90FF','30','144','255');
INSERT INTO [color] VALUES('aliceblue','#F0F8FF','240','248','255');
INSERT INTO [color] VALUES('steelblue','#4682B4','70','130','180');
INSERT INTO [color] VALUES('lightskyblue','#87CEFA','135','206','250');
INSERT INTO [color] VALUES('skyblue','#87CEEB','135','206','235');
INSERT INTO [color] VALUES('deepskyblue','#00BFFF','0','191','255');
INSERT INTO [color] VALUES('lightblue','#ADD8E6','173','216','230');
INSERT INTO [color] VALUES('powderblue','#B0E0E6','176','224','230');
INSERT INTO [color] VALUES('cadetblue','#5F9EA0','95','158','160');
INSERT INTO [color] VALUES('darkturquoise','#00CED1','0','206','209');
INSERT INTO [color] VALUES('azure','#F0FFFF','240','255','255');
INSERT INTO [color] VALUES('lightcyan','#E0FFFF','224','255','255');
INSERT INTO [color] VALUES('paleturquoise','#AFEEEE','175','238','238');
INSERT INTO [color] VALUES('aqua','#00FFFF','0','255','255');
INSERT INTO [color] VALUES('darkcyan','#008B8B','0','139','139');
INSERT INTO [color] VALUES('teal','#008080','0','128','128');
INSERT INTO [color] VALUES('darkslategray','#2F4F4F','47','79','79');
INSERT INTO [color] VALUES('mediumturquoise','#48D1CC','72','209','204');
INSERT INTO [color] VALUES('lightseagreen','#20B2AA','32','178','170');
INSERT INTO [color] VALUES('turquoise','#40E0D0','64','224','208');
INSERT INTO [color] VALUES('aquamarine','#7FFFD4','127','255','212');
INSERT INTO [color] VALUES('mediumaquamarine','#66CDAA','102','205','170');
INSERT INTO [color] VALUES('mediumspringgreen','#00FA9A','0','250','154');
INSERT INTO [color] VALUES('mintcream','#F5FFFA','245','255','250');
INSERT INTO [color] VALUES('springgreen','#00FF7F','0','255','127');
INSERT INTO [color] VALUES('mediumseagreen','#3CB371','60','179','113');
INSERT INTO [color] VALUES('seagreen','#2E8B57','46','139','87');
INSERT INTO [color] VALUES('honeydew','#F0FFF0','240','255','240');
INSERT INTO [color] VALUES('darkseagreen','#8FBC8F','143','188','143');
INSERT INTO [color] VALUES('palegreen','#98FB98','152','251','152');
INSERT INTO [color] VALUES('lightgreen','#90EE90','144','238','144');
INSERT INTO [color] VALUES('limegreen','#32CD32','50','205','50');
INSERT INTO [color] VALUES('lime','#00FF00','0','255','0');
INSERT INTO [color] VALUES('forestgreen','#228B22','34','139','34');
INSERT INTO [color] VALUES('green','#008000','0','128','0');
INSERT INTO [color] VALUES('darkgreen','#006400','0','100','0');
INSERT INTO [color] VALUES('lawngreen','#7CFC00','124','252','0');
INSERT INTO [color] VALUES('chartreuse','#7FFF00','127','255','0');
INSERT INTO [color] VALUES('greenyellow','#ADFF2F','173','255','47');
INSERT INTO [color] VALUES('darkolivegreen','#556B2F','85','107','47');
INSERT INTO [color] VALUES('yellowgreen','#9ACD32','154','205','50');
INSERT INTO [color] VALUES('olivedrab','#6B8E23','107','142','35');
INSERT INTO [color] VALUES('ivory','#FFFFF0','255','255','240');
INSERT INTO [color] VALUES('beige','#F5F5DC','245','245','220');
INSERT INTO [color] VALUES('lightyellow','#FFFFE0','255','255','224');
INSERT INTO [color] VALUES('lightgoldenrodyellow','#FAFAD2','250','250','210');
INSERT INTO [color] VALUES('yellow','#FFFF00','255','255','0');
INSERT INTO [color] VALUES('olive','#808000','128','128','0');
INSERT INTO [color] VALUES('darkkhaki','#BDB76B','189','183','107');
INSERT INTO [color] VALUES('palegoldenrod','#EEE8AA','238','232','170');
INSERT INTO [color] VALUES('lemonchiffon','#FFFACD','255','250','205');
INSERT INTO [color] VALUES('khaki','#F0E68C','240','230','140');
INSERT INTO [color] VALUES('gold','#FFD700','255','215','0');
INSERT INTO [color] VALUES('cornsilk','#FFF8DC','255','248','220');
INSERT INTO [color] VALUES('goldenrod','#DAA520','218','165','32');
INSERT INTO [color] VALUES('darkgoldenrod','#B8860B','184','134','11');
INSERT INTO [color] VALUES('floralwhite','#FFFAF0','255','250','240');
INSERT INTO [color] VALUES('oldlace','#FDF5E6','253','245','230');
INSERT INTO [color] VALUES('wheat','#F5DEB3','245','222','179');
INSERT INTO [color] VALUES('orange','#FFA500','255','165','0');
INSERT INTO [color] VALUES('moccasin','#FFE4B5','255','228','181');
INSERT INTO [color] VALUES('papayawhip','#FFEFD5','255','239','213');
INSERT INTO [color] VALUES('blanchedalmond','#FFEBCD','255','235','205');
INSERT INTO [color] VALUES('navajowhite','#FFDEAD','255','222','173');
INSERT INTO [color] VALUES('antiquewhite','#FAEBD7','250','235','215');
INSERT INTO [color] VALUES('tan','#D2B48C','210','180','140');
INSERT INTO [color] VALUES('burlywood','#DEB887','222','184','135');
INSERT INTO [color] VALUES('darkorange','#FF8C00','255','140','0');
INSERT INTO [color] VALUES('bisque','#FFE4C4','255','228','196');
INSERT INTO [color] VALUES('linen','#FAF0E6','250','240','230');
INSERT INTO [color] VALUES('peru','#CD853F','205','133','63');
INSERT INTO [color] VALUES('peachpuff','#FFDAB9','255','218','185');
INSERT INTO [color] VALUES('sandybrown','#F4A460','244','164','96');
INSERT INTO [color] VALUES('chocolate','#D2691E','210','105','30');
INSERT INTO [color] VALUES('saddlebrown','#8B4513','139','69','19');
INSERT INTO [color] VALUES('seashell','#FFF5EE','255','245','238');
INSERT INTO [color] VALUES('sienna','#A0522D','160','82','45');
INSERT INTO [color] VALUES('lightsalmon','#FFA07A','255','160','122');
INSERT INTO [color] VALUES('coral','#FF7F50','255','127','80');
INSERT INTO [color] VALUES('orangered','#FF4500','255','69','0');
INSERT INTO [color] VALUES('darksalmon','#E9967A','233','150','122');
INSERT INTO [color] VALUES('tomato','#FF6347','255','99','71');
INSERT INTO [color] VALUES('salmon','#FA8072','250','128','114');
INSERT INTO [color] VALUES('mistyrose','#FFE4E1','255','228','225');
INSERT INTO [color] VALUES('lightcoral','#F08080','240','128','128');
INSERT INTO [color] VALUES('snow','#FFFAFA','255','250','250');
INSERT INTO [color] VALUES('rosybrown','#BC8F8F','188','143','143');
INSERT INTO [color] VALUES('indianred','#CD5C5C','205','92','92');
INSERT INTO [color] VALUES('red','#FF0000','255','0','0');
INSERT INTO [color] VALUES('brown','#A52A2A','165','42','42');
INSERT INTO [color] VALUES('firebrick','#B22222','178','34','34');
INSERT INTO [color] VALUES('darkred','#8B0000','139','0','0');
INSERT INTO [color] VALUES('maroon','#800000','128','0','0');
INSERT INTO [color] VALUES('white','#FFFFFF','255','255','255');
INSERT INTO [color] VALUES('whitesmoke','#F5F5F5','245','245','245');
INSERT INTO [color] VALUES('gainsboro','#DCDCDC','220','220','220');
INSERT INTO [color] VALUES('lightgrey','#D3D3D3','211','211','211');
INSERT INTO [color] VALUES('silver','#C0C0C0','192','192','192');
INSERT INTO [color] VALUES('darkgray','#A9A9A9','169','169','169');
INSERT INTO [color] VALUES('gray','#808080','128','128','128');
INSERT INTO [color] VALUES('dimgray','#696969','105','105','105');
INSERT INTO [color] VALUES('black','#000000','0','0','0');



DROP TABLE IF EXISTS [contest];
CREATE TABLE [contest] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [name] varchar(32) UNIQUE NOT NULL
);


DROP TABLE IF EXISTS [candidate];
CREATE TABLE [candidate] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [name] varchar(32) UNIQUE NOT NULL,
  [photo_cas] text DEFAULT NULL,
  [full_name] varchar(32),
  [color] varchar(32) DEFAULT NULL,
  
  FOREIGN KEY ([color]) REFERENCES [color] ([name]) 
   ON DELETE RESTRICT ON UPDATE RESTRICT
);


DROP TABLE IF EXISTS [dataset];
CREATE TABLE [dataset] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [ts] datetime UNIQUE NOT NULL,
  [hour] char(14),    -- i.e. '2016-01-25 17', ''2016-01-25 18' ... 
  [halfday] char(12), -- i.e. '2016-01-25A', ''2016-01-25P' ...
  [day] date,         -- i.e. '2016-01-24', '2016-01-25' ...
  [week] char(8),     -- i.e. '2016w02', '2016w03' ...
  [month] char(9),    -- i.e. '2016-Jan', '2016-Feb' ...
  [quarter] char(7),  -- i.e. '2016q1', '2016q2' ... 
  [year] int(4)       -- i.e. '2015', '2016' ...
);
CREATE INDEX [hour_idx]    ON [dataset] ([hour]);
CREATE INDEX [halfday_idx] ON [dataset] ([halfday]);
CREATE INDEX [day_idx]     ON [dataset] ([day]);
CREATE INDEX [week_idx]    ON [dataset] ([week]);
CREATE INDEX [month_idx]   ON [dataset] ([month]);
CREATE INDEX [quarter_idx] ON [dataset] ([quarter]);
CREATE INDEX [year_idx]    ON [dataset] ([year]);



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
  


DROP TABLE IF EXISTS [slot];
CREATE TABLE [slot] ([name] varchar(8) PRIMARY KEY NOT NULL);
INSERT INTO [slot] VALUES('hour');
INSERT INTO [slot] VALUES('halfday');
INSERT INTO [slot] VALUES('day');
INSERT INTO [slot] VALUES('week');
INSERT INTO [slot] VALUES('month');
INSERT INTO [slot] VALUES('quarter');
INSERT INTO [slot] VALUES('year');
  
DROP TABLE IF EXISTS [closing];
CREATE TABLE [closing] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [by] varchar(8) NOT NULL,
  [key] varchar(14) UNIQUE NOT NULL,
  [label] varchar(14),
  [dataset_id] INTEGER NOT NULL,

  FOREIGN KEY ([dataset_id]) REFERENCES [dataset] ([id]) 
   ON DELETE CASCADE ON UPDATE RESTRICT,
  
  FOREIGN KEY ([by]) REFERENCES [slot] ([name]) 
   ON DELETE CASCADE ON UPDATE RESTRICT
  
);
