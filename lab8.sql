#1. Найти информацию по заданному исполнителю, используя его имя.
use discogs;

create index artist_name on artist(NAME);

select * from artist a
where a.NAME="Eminem";



#2. Найти всех участников указанного музыкального коллектива.
use discogs;

select * from discogs.group g
inner join artist a on a.ARTIST_ID=g.MAIN_ARTIST_ID
where g.GROUP_ARTIST_ID=128624;

create index group_artist_id on discogs.group(GROUP_ARTIST_ID);


#3 Найти все релизы заданного исполнителя и отсортировать их по дате
#  выпуска. Вывести имя исполнителя, название релиза, дату выхода.
use discogs;

SELECT ra.NAME, r.TITLE, r.RELEASED FROM release_artist ra
INNER JOIN discogs.release r ON ra.RELEASE_ID = r.RELEASE_ID
WHERE ra.NAME = "Eminem"
ORDER BY r.RELEASED;

CREATE INDEX release_artist_name ON release_artist(NAME); 




#4. Найти все главные релизы заданного стиля, выпущенные в указанный год. 
#(релиз является главным, если поле release.IS_MAIN_RELEASE = 1)
use discogs;
#без индексов 13/53 сек 
#1            0.047/63 сек
#2			  0.026/44 сек

#1
SELECT * FROM discogs.release r
INNER JOIN discogs.style s ON s.RELEASE_ID = r.RELEASE_ID							#time : 0.47/63 сек
WHERE YEAR(r.RELEASED)= 2001 AND r.IS_MAIN_RELEASE = 1 AND s.STYLE_NAME = "Techno"; #KEY : style_name , PRIMARY

#2
SELECT * FROM discogs.release r														 #time : 0.26/44 сек
INNER JOIN discogs.style s ON s.RELEASE_ID = r.RELEASE_ID                            #KEY : style_realise_id , r_main_realease
WHERE r.RELEASED>'1999-12-31 00:00' AND r.RELEASED<'2000-12-31 00:00' AND r.IS_MAIN_RELEASE = 1 AND s.STYLE_NAME = "Techno";



CREATE INDEX style_name ON style(STYLE_NAME);
CREATE INDEX r_main_released ON discogs.release(RELEASED, IS_MAIN_RELEASE); 
CREATE INDEX style_release_id ON style(RELEASE_ID);


drop index r_main_released on discogs.release;
drop index style_name on discogs.style;
drop index style_release_id on discogs.style;



#5  Найти всех исполнителей, в описании (профиле) которых встречается
#   указанное слово (например, "moog"), с использованием полнотекстового
#   запроса
use discogs;

SELECT * FROM artist WHERE PROFILE LIKE '%moog%';

create fulltext index artist_profile on artist(PROFILE);

SELECT * FROM artist WHERE MATCH (PROFILE) AGAINST ('moog');

