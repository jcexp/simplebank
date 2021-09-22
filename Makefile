postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb: 
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb: 
	docker exec -it postgres12 dropdb simple_bank

migrateup: 
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown: 
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc: 
	sqlc generate

dkstart: 
	docker start postgres12

dkstop: 
	docker stop postgres12

dkrm: 
	docker rm postgres12

dkps: 
	docker ps -a

test:
	go clean -testcache && go test -v -cover ./...

server:
	go run main.go

mysql: 
	docker run --name mysql8 -p 3306:3306  -e MYSQL_ROOT_PASSWORD=secret -d mysql:8

mock: 
	mockgen -package mockdb -destination db/mock/store.go github.com/jcexp/simplebank/db/sqlc Store
	
.PHONY: postgres createdb dropdb migrateup migratedown sqlc dkstart mock
