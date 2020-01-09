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

get("/patrons/:id/books")do
  @patron = Patron.find(params[:id])
  @books = Book.all()
  erb(:books)
end

get("/patrons/:id/authors")do
  @authors = Author.all()
  erb(:authors)
end

get("/patrons/new")do
  erb(:new_patron)
end

post("/patrons")do
  patron = Patron.new({:name => params[:patron_name], :password => params[:patron_password] , :id => nil})
  patron.save
  redirect to("/patrons")
end

get("/patrons/:id/books/new")do
@patron = Patron.find(params[:id])
  erb(:new_book)
end

post("/patrons/:id/books")do
  book = Book.new({:name => params[:book_name], :return_date => "1-01-01", :checkout_date => "0001-01-01", :id => nil})
  book.save
  redirect to("/books")
end

get("/patrons/:id/authors/new")do
@patron = Patron.find(params[:id])
  erb(:new_author)
end

post("/patrons/:id/authors")do
  author = Author.new({:name => params[:author_name], :id => nil})
  author.save
  redirect to("/authors")
end

get("/patrons/:id")do
  @patron = Patron.find(params[:id])
  @books = @patron.books()
  erb(:patron)
end

get("/patrons/:id/books/:book_id")do
@patron = Patron.find(params[:id])
  @book = Book.find(params[:book_id])
  @authors = @book.authors()
  erb(:book)
end

get("/patrons/:id/authors/:author_id")do
  @patron = Patron.find(params[:id])
  @author = Author.find(params[:author_id])
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


get("/patrons/:id/books/:book_id/edit")do
@patron = Patron.find(params[:id])
  @book = Book.find(params[:book_id])
  erb(:edit_book)
end


patch("/patrons/:id/books/:book_id")do
@book = Book.find(params[:book_id])
@book.update(params[:name])
erb(:book)
end

get("/patrons/:id/authors/:author_id/edit")do
@patron = Patron.find(params[:id])
  @author = Author.find(params[:author_id])
  erb(:edit_author)
end


patch("/patrons/:id/authors/:author_id")do
@author = Author.find(params[:author_id])
@author.update(params[:name])
erb(:author)
end

delete("/patrons/:id")do
  patron = Patron.find(params[:id])
  patron.delete
  redirect to ("/patrons")
end


delete("/patrons/:id/books/:book_id")do
  book = Book.find(params[:id])
  book.delete
  redirect to ("/books")
end

delete("/patrons/:id/authors/:author_id")do
  author = Author.find(params[:author_id])
  author.delete
  redirect to ("/authors")
end

get("/patrons/:id/books") do
  @patron = Patron.find(params[:id])
  @books = Book.all()
  erb(:books)
end

patch("/patrons") do
  results = []
  DB.exec("SELECT * FROM patrons WHERE name = '#{params[:patron_name_old]}' and password = '#{params[:patron_password_old]}' ").each do |result|
    results.push(result.fetch("id"))
  end
  if results == []
    redirect to ("/")
  else
    @patron = Patron.find(results.pop)
    # params[:id] = @patron.id
    # binding.pry
    redirect to ("/patrons/"+@patron.id)
  end



end
