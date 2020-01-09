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

get ("/admin")do
@books = Book.all
@authors = Author.all
@patrons = Patron.all
erb(:librarian_options)
end

get("/admin/add_book")do
  erb(:new_book)
end
get("/admin/add_author")do
  erb(:new_author)
end

get("/admin/books/:id")do
  @book = Book.find(params[:id])
  @authors = @book.authors
  erb(:book_admin)
end

get("/admin/authors/:id")do
  @author = Author.find(params[:id])
  erb(:author_admin)
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
  account = Patron.find(patron.id)
  redirect to("/patrons/"+account.id)
end

post("/admin/search/author")do
@search_authors = params[:author_search]
results = DB.exec("SELECT * FROM authors WHERE name ILIKE '%#{params[:author_search]}%';")
authors = []
results.each do |result|
  authors.push(result)
end
@authors = []
authors.each do |author|
  @authors.push(Author.new({:name => author.fetch("name"), :id =>author.fetch("id")}))
end
@books = Book.all
@patrons = Patron.all
  erb(:librarian_options)
end

post("/admin/search/book")do
@search_books = params[:book_search]
results = DB.exec("SELECT * FROM books WHERE name ILIKE '%#{params[:book_search]}%';")
books = []
results.each do |result|
  books.push(result)
end
@books = []
books.each do |book|
  @books.push(Book.new({:name => book.fetch("name"), :id =>book.fetch("id"), :return_date => book.fetch("return_date"), :checkout_date => book.fetch("checkout_date")}))
end
@authors = Author.all
@patrons = Patron.all
  erb(:librarian_options)
end

get("/patrons/:id/books/new")do
@patron = Patron.find(params[:id])
  erb(:new_book)
end

post("/admin/add_book")do
  book = Book.new({:name => params[:book_name], :return_date => "1-01-01", :checkout_date => "0001-01-01", :id => nil})
  book.save
  redirect to("/admin")
end

get("/patrons/:id/authors/new")do
@patron = Patron.find(params[:id])
  erb(:new_author)
end

post("/admin/new_author")do
  author = Author.new({:name => params[:author_name], :id => nil})
  author.save
  redirect to("/admin")
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
@patron.update(params[:name], params[:password])
erb(:patron)
end


get("/admin/books/:book_id/edit")do
  @book = Book.find(params[:book_id])
  erb(:edit_book)
end


patch("/admin/books/:book_id")do
@book = Book.find(params[:book_id])
@book.update(params[:name])
erb(:book_admin)
end

get("/admin/authors/:author_id/edit")do
  @author = Author.find(params[:author_id])
  erb(:edit_author)
end


patch("/admin/authors/:author_id")do
@author = Author.find(params[:author_id])
@author.update(params[:name])
erb(:author_admin)
end

delete("/patrons/:id")do
  patron = Patron.find(params[:id])
  patron.delete
  redirect to ("/patrons")
end


delete("/admin/books/:id")do
  book = Book.find(params[:id])
  book.delete
  redirect to ("/admin")
end

delete("/admin/authors/:author_id")do
  author = Author.find(params[:author_id])
  author.delete
  redirect to ("/admin")
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
    redirect to ("/patrons/"+@patron.id)
  end



end
