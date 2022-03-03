up:
	docker-compose up -d

down:
	docker-compose down

task14_up:
	docker exec -it lab4_db sh -c 'mysql -uroot -ppass1234 < /data/task14/up.sql'

task14_down:
	docker exec -it lab4_db sh -c 'mysql -uroot -ppass1234 < /data/task14/down.sql'