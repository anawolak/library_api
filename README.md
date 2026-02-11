Simple Rails API to handle book library system.

Allows to create new books, set them as borrowed, set them as returned. Every borrow/return operation is logged and visible when checking for individual book info.

For debug/testing purposes, there's also possibility to add new users via API (to be removed).

For convenience, app is provided as Docker-based image with PostgreSQL and Ruby installation.

Install & run:

docker-compose up --build
docker-compose exec web rails db:migrate

Usage examples:

curl -X POST http://localhost:3000/books \
  -H "Content-Type: application/json" \
  -d '{
    "book": {
      "serial": "BOOK-001",
      "title": "1984",
      "author": "George Orwell",
      "borrowed_status": false
    }
  }'

curl -X GET http://localhost:3000/books/1

curl -X POST http://localhost:3000/books/1/borrow \
  -H "Content-Type: application/json" \
  -d '{"user_id":2}'

curl -X GET http://localhost:3000/books/1

curl -X POST http://localhost:3000/books/1/return_book

Todos:
 - Rspec model and integration testing
 - User reminder Mailing. Requires connecting to mailing system, rake tasks, cron/whenever configuration.
 - Authentication, keys, actual user handling
 - Much more error checking