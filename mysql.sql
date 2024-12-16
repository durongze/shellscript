use mysql;
show tables;
create user 'durongze'@'localhost' identified by 'Caonimabi8!';
alter user 'durongze'@'localhost' identified by 'Wocaonimabi8!';
grant all privileges on webdb.* to 'wheatmind'@'localhost';
flush privileges;
