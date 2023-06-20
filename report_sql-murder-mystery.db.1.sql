-----SQL Project crime_scene_report------

/* Understanding all tables */
SELECT * from drivers_license
limit 2;

SELECT * from facebook_event_checkin
limit 2;

select * from get_fit_now_check_in
limit 2;

SELECT * from get_fit_now_member
LIMIT 2;

SELECT * from income
limit 2;

SELECT * from interview
LIMIT 5;

SELECT * from person
limit 2;

--diving into the crime scene report to obtain some info----
SELECT * FROM crime_scene_report
where city = 'SQL City'
AND type = 'murder'
and date = 20180115
;

--- following the description from the crime scene report----
/*- the first witness lives at the last house on Northwestern Dr.
the second witness is named Annabel and lives somewhere on Franklin Ave.
*/

---finding withness 1 info. who is witness 1?----
select * from person
where person.address_street_name is 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1
/* witness 1 is Morty Schapiro with id of 14887 */

---finding withness 2 info. who is withness 2----
SELECT * from person
where person.address_street_name IS 'Franklin Ave'
and person.name LIKE '%Annabel%'
/* witness 2 is Annabel Miller with id of 16371 */

-----Diving into info provided by both witness during interview----
SELECT interview.person_id, interview.transcript
from interview
where person_id in (14887, 16371)
/* 
id of 14887---I heard a gunshot and then saw a man run out.
He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z".
Only gold members have those bags. The man got into a car with a plate that included "H42W".

id of 16371------I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
*/

---following the info provided by witness 1 and 2-----
SELECT person.name, person.address_street_name, person.address_number
from get_fit_now_member
JOIN person
on get_fit_now_member.person_id = person.id
JOIN drivers_license
on person.license_id = drivers_license.id
WHERE get_fit_now_member.membership_status is 'gold'
AND get_fit_now_member.id LIKE '48Z%'
AND drivers_license.plate_number LIKE '%H42W%'

----Witness info lead to Jeremy Bowers as a suspect------

/* looking into what Jeremy said during his interview */
SELECT interview.transcript
from interview
JOIN person
ON interview.person_id = person.id
where person.name is 'Jeremy Bowers'
/* interview from the suspect revealed that:
He was hired by a woman with lot of money.
He don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S.
He know that she attended the SQL Symphony Concert 3 times in December 2017.
*/

----finding who hired Jeremy Bowers with the info provided during his interview----
SELECT person.name, person.address_number, person.address_street_name, person.ssn
from person
JOIN facebook_event_checkin
ON person.id=facebook_event_checkin.person_id
JOIN drivers_license
ON person.license_id = drivers_license.id
where facebook_event_checkin.event_name is 'SQL Symphony Concert'
AND facebook_event_checkin.date LIKE '%201712%'
and drivers_license.car_make is 'Tesla'
AND drivers_license.car_model is 'Model S'
AND gender is 'female'
and drivers_license.height BETWEEN 65 and 67
AND drivers_license.hair_color is 'red'
GROUP by person.name
HAVING count(*) == 3

----the killer was hired by Miranda Priestly who lives at 1883 Golden Ave with ssn of 987756388-----

/*---Final Report-----
Miranda Priestly who lives at 1883 Golden Ave 
and Jeremy Bowers who lives at 530 Washington Pl, Apt 3A
are both responsible for the crime that happened on January 15, 2018.
*/