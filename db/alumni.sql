drop table if exists stocks;
create table stocks (
id int auto_increment primary key,
symbol varchar(30),
user_id int default 0
);

drop table if exists emails;
create table emails( 
id int primary key auto_increment, 
from_email varchar(200), 
message text, 
subject text,
send int default 0
);

drop table if exists user_changes;
create table user_changes (
	id int auto_increment primary key,
	user_id int,
	update_id int,
	last_cycle_id int default 0,
	date_changed date
);

drop table if exists users;
create table users (
	id int auto_increment primary key,
	first_name varchar(80),
	last_name varchar(80),
	email varchar(100),
	graduation_year date,
	employer varchar(100),
	job_title varchar(100),
	graduated varchar(1),
	hashed_password varchar(40),
	mobile_phone varchar(100),
	employment_status varchar(100),
	address varchar(200),
	city varchar(100),
	state varchar(100),
	previous_employer text,
	job_description text,
	privilege int default 0,
	login_name varchar(100),
	major varchar(200),
	last_updated date,
	grad_school varchar(100)
);

drop table if exists pictures;
create table pictures (
id int auto_increment primary key,
user_id int,
name varchar(200),
content_type varchar(100),
data longblob
);


drop table if exists admin_emails;
create table admin_emails (
id int auto_increment primary key,
user_id int,
name varchar(200),
content_type varchar(100),
data blob
);


drop table if exists resume_viewers;
create table resume_viewers (
id int auto_increment primary key,
user_id int,
viewer_id int,
viewed int default 0,
date_sent date
);

drop table if exists resumes;
create table resumes (
id int auto_increment primary key,
user_id int,
comment varchar(100),
name varchar(200),
content_type varchar(100),
public varchar(1) default '1',
data longblob
);

drop table if exists messages;
create table messages (
id int auto_increment primary key,
user_id int,
from_id int,
date_sent date,
subject text,
message text,
has_read int default 0,
has_read_sent int default 0,
sent_folder int default 0,
from_deleted int default 0,
user_deleted int default 0
);

drop table if exists updates;
create table updates (
id int auto_increment primary key,
user_id int,
viewer_id int,
date_sent date,
subject text,
update_type int default 0,
type varchar(100),
message text
);
