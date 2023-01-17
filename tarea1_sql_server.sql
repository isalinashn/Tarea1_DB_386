CREATE DATABASE Tarea1_DB386
go
use Tarea1_DB386

 create table teams (
      team_id integer not null,
      team_name varchar(30) not null,
      unique(team_id)
  );

  create table matches (
      match_id integer not null,
      host_team integer not null,
      guest_team integer not null,
      host_goals integer not null,
      guest_goals integer not null,
      unique(match_id)
  );

insert into teams ( team_id, team_name) Values(10,'Give')
insert into teams ( team_id, team_name) Values(20,'Never')
insert into teams ( team_id, team_name) Values(30,'You')
insert into teams ( team_id, team_name) Values(40,'Up')
insert into teams ( team_id, team_name) Values(50,'Gonna')

insert into matches (match_id, host_team, guest_team, host_goals, guest_goals) values(1,30,20,1,0)
insert into matches (match_id, host_team, guest_team, host_goals, guest_goals) values(2,10,20,1,2)
insert into matches (match_id, host_team, guest_team, host_goals, guest_goals) values(3,20,50,2,2)
insert into matches (match_id, host_team, guest_team, host_goals, guest_goals) values(4,10,30,1,0)
insert into matches (match_id, host_team, guest_team, host_goals, guest_goals) values(5,30,50,0,1)

WITH tabla_puntos_host AS (
    SELECT host_team AS codigo_equipo,
           SUM(CASE 
                 WHEN host_goals > guest_goals THEN 3
                 WHEN host_goals = guest_goals THEN 1
                 ELSE 0
              END) AS puntos_totales
    FROM matches
    GROUP BY host_team
),
tabla_puntos_guest AS (
    SELECT guest_team AS codigo_equipo,
           SUM(CASE 
                 WHEN guest_goals > host_goals THEN 3
                 WHEN host_goals = guest_goals THEN 1
                 ELSE 0
              END) AS puntos_totales
    FROM matches
    GROUP BY guest_team
)

SELECT e.team_id, e.team_name, COALESCE(SUM(tp.puntos_totales),0) AS puntos_totales
FROM teams e
LEFT JOIN (SELECT * FROM tabla_puntos_host
           UNION ALL
           SELECT * FROM tabla_puntos_guest) tp
ON e.team_id = tp.codigo_equipo
GROUP BY e.team_name, e.team_id
ORDER BY puntos_totales DESC

