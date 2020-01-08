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
    returned_books.each() do |books|
      name = book.fetch("name")
      id = book.fetch("id").to_i
      books.push(book.new({:name => name, :id => id}))
    end
    books
  end

  def save
    result = DB.exec("INSERT INTO books (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(book_to_compare)
    self.id() == books_to_compare.id()
  end

  def self.find(id)
    book = DB.exec("SELECT * FROM books WHERE id = #{id};").first
    name = book.fetch('name')
    id = book.fetch('id')
    book.new({:name => name, :id => id})
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





end
