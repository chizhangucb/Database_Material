/* Delete the tables if they already exist */
drop table if exists Node;
drop table if exists Edge;

/* Create the schema for our tables */
create table Node(nID char, color varchar);
create table Edge(n1 char, n2 char, weight int);

/* Populate the tables with our data */
insert into Node values ('A', 'red');
insert into Node values ('B', 'yellow');
insert into Node values ('C', 'blue');
insert into Node values ('D', 'red');
insert into Node values ('E', 'yellow');
insert into Node values ('F', 'blue');
insert into Node values ('G', 'red');
insert into Node values ('H', 'yellow');
insert into Node values ('I', 'blue');
insert into Node values ('J', 'red');
insert into Node values ('K', 'yellow');
insert into Node values ('L', 'blue');

insert into Edge values ('A', 'B', 1);
insert into Edge values ('A', 'C', 2);
insert into Edge values ('A', 'D', 3);
insert into Edge values ('B', 'E', 4);
insert into Edge values ('C', 'E', 3);
insert into Edge values ('D', 'F', 2);
insert into Edge values ('D', 'J', 1);
insert into Edge values ('E', 'H', 2);
insert into Edge values ('E', 'I', 3);
insert into Edge values ('F', 'E', 4);
insert into Edge values ('F', 'G', 3);
insert into Edge values ('H', 'I', 2);
insert into Edge values ('I', 'J', 1);
insert into Edge values ('I', 'K', 2);
insert into Edge values ('I', 'L', 3);
insert into Edge values ('K', 'L', 4);
