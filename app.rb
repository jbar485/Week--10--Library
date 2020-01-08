require('sinatra')
require('sinatra/reloader')
require('./lib/book')
require('./lib/author')
require('pry')
also_reload('lib/**/*.rb')
require("pg")
require('./lib/patron')

DB = PG.connect({:dbname => "library"})

get("/") do
  erb(:main_page)
end

get("/patrons")do
  @patrons = Patron.all()
  erb(:patrons)
end

get("/books")do
  @books = Book.all()
  erb(:books)
end

get("/authors")do
  @authors = Author.all()
  erb(:authors)
end

get("/patrons/new")do
  erb(:new_patron)
end

post("/patrons")do
  patron = Patron.new({:name => params[:patron_name], :id => nil})
  patron.save
  redirect to("/patrons")
end

get("/books/new")do
  erb(:new_book)
end

post("/books")do
  book = Book.new({:name => params[:book_name], :return_date => "1-01-01", :checkout_date => "0001-01-01", :id => nil})
  book.save
  redirect to("/books")
end

get("/authors/new")do
  erb(:new_author)
end

post("/authors")do
  author = Author.new({:name => params[:author_name], :id => nil})
  author.save
  redirect to("/authors")
end

get("/patrons/:id")do
  @patron = Patron.find(params[:id])
  @books = @patron.books()
  erb(:patron)
end

get("/books/:id")do
  @book = Book.find(params[:id])
  @authors = @book.authors()
  erb(:book)
end

get("/authors/:id")do
  @author = Author.find(params[:id])
  @books = @author.books()
  erb(:author)
end

get("/patrons/:id/edit")do
  @patron = Patron.find(params[:id])
  erb(:edit_patron)
end


patch("/patrons/:id")do
@patron = Patron.find(params[:id])
@patron.update(params[:name])
erb(:patron)
end


get("/books/:id/edit")do
  @book = Book.find(params[:id])
  erb(:edit_book)
end


patch("/books/:id")do
@book = Book.find(params[:id])
@book.update(params[:name])
erb(:book)
end

get("/authors/:id/edit")do
  @author = Author.find(params[:id])
  erb(:edit_author)
end


patch("/authors/:id")do
@author = Author.find(params[:id])
@author.update(params[:name])
erb(:author)
end

delete("/patrons/:id")do
  patron = Patron.find(params[:id])
  patron.delete
  redirect to ("/patrons")
end


delete("/books/:id")do
  book = Book.find(params[:id])
  book.delete
  redirect to ("/books")
end

delete("/authors/:id")do
  author = Author.find(params[:id])
  author.delete
  redirect to ("/authors")
end
