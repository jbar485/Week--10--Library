class Book
  attr_accessor :name
  attr_reader :id
  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @return_date = attributes.fetch(:return_date)
    @checkout_date = attributes.fetch(:checkout_date)
  end

  def self.all
    returned_books = DB.exec("SELECT * FROM books;")
    books = []
    returned_books.each() do |book|
      name = book.fetch("name")
      id = book.fetch("id").to_i
      return_date = book.fetch("return_date")
      checkout_date = book.fetch("checkout_date")
      books.push(Book.new({:name => name, :id => id, :return_date => return_date, :checkout_date => checkout_date}))
    end
    books
  end

  def save
    result = DB.exec("INSERT INTO books (name, return_date, checkout_date) VALUES ('#{@name}', '#{@return_date}', '#{@checkout_date}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(book_to_compare)
    self.id().to_i == book_to_compare.id().to_i
  end

  def self.find(id)
    book = DB.exec("SELECT * FROM books WHERE id = #{id};").first
    name = book.fetch('name')
    id = book.fetch('id')
    return_date = book.fetch("return_date")
    checkout_date = book.fetch("checkout_date")
    Book.new({:name => name, :id => id, :return_date => return_date, :checkout_date => checkout_date})
  end

  def update(name)
    @name = name
    DB.exec("Update books SET name = '#{@name}' WHERE id =#{@id};")
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{@id}")
  end

  def authors
    results = DB.exec("SELECT author_id from authors_books where book_id = #{id};")
    authors_ids = ''
    results.each do |result|
      book_ids << (result.fetch("book_id")) + ", "
    end
    if authors_ids != ""
      authors = DB.exec("SELECT * FROM authors WHERE id IN (#{authors_ids.slice(0, (albums_ids.length - 2))});")
      author_objects = []
      authors.each() do |hash|
        id = hash.fetch("id").to_i
        author_objects.push(author.find(id))
      end
      return author_objects
    else
      nil
    end
  end


  def authors
    results = DB.exec("SELECT author_id from authors_books where book_id = #{@id};")
    authors_ids = ''
    results.each do |result|
      authors_ids << (result.fetch("author_id")) + ", "
    end
    if authors_ids != ""
      authors = DB.exec("SELECT * FROM authors WHERE id IN (#{authors_ids.slice(0, (authors_ids.length - 2))});")
      author_objects = []
      authors.each() do |hash|
        id = hash.fetch("id").to_i
        author_objects.push(Author.find(id))
      end
      return author_objects
    else
      nil
    end
  end

  def link_book_author(author_id)
    author = DB.exec("SELECT * FROM authors WHERE id = #{author_id};").first
    if author != nil
      DB.exec("INSERT into authors_books (author_id, book_id) VALUES (#{author['id'].to_i}, #{@id});")
    else
      nil
    end
  end


end
