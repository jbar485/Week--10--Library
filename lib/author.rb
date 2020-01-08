class Author
  attr_accessor :name
  attr_reader :id
  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_authors = DB.exec("SELECT * FROM authors;")
    authors = []
    returned_authors.each() do |author|
      name = author.fetch("name")
      id = author.fetch("id").to_i
      authors.push(Author.new({:name => name, :id => id}))
    end
    authors
  end

  def save
    result = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(author_to_compare)
    self.name() == author_to_compare.name()
  end

  def self.find(id)
    author = DB.exec("SELECT * FROM authors WHERE id = #{id};").first
    name = author.fetch('name')
    id = author.fetch('id')
    Author.new({:name => name, :id => id})
  end

  def update(name)
    @name = name
    DB.exec("Update authors SET name = '#{@name}' WHERE id =#{@id};")
  end

  def delete
    DB.exec("DELETE FROM authors WHERE id = #{@id}")
  end

  def books
    results = DB.exec("SELECT book_id from authors_books where author_id = #{@id};")
    books_ids = ''
    results.each do |result|
      books_ids << (result.fetch("book_id")) + ", "
    end
    if books_ids != ""
      books = DB.exec("SELECT * FROM books WHERE id IN (#{books_ids.slice(0, (books_ids.length - 2))});")
      book_objects = []
      books.each() do |hash|
        id = hash.fetch("id").to_i
        book_objects.push(Book.find(id))
      end
      return book_objects
    else
      nil
    end
  end


end
