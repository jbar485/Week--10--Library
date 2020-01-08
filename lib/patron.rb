class Patron
  attr_accessor :name
  attr_reader :id
  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_patrons = DB.exec("SELECT * FROM patrons;")
    patrons = []
    returned_patrons.each() do |patron|
      name = patron.fetch("name")
      id = patron.fetch("id").to_i
      patrons.push(Patron.new({:name => name, :id => id}))
    end
    patrons
  end

  def save
    result = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(patron_to_compare)
    self.id().to_i == patron_to_compare.id().to_i
  end

  def self.find(id)
    patron = DB.exec("SELECT * FROM patrons WHERE id = #{id};").first
    name = patron.fetch('name')
    id = patron.fetch('id')
    Patron.new({:name => name, :id => id})
  end

  def update(name)
    @name = name
    DB.exec("Update patrons SET name = '#{@name}' WHERE id =#{@id};")
  end

  def delete
    DB.exec("DELETE FROM patrons WHERE id = #{@id}")
  end

  def books
    results = DB.exec("SELECT book_id from books_patrons where patron_id = #{@id};")
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

  def link_patron_book(book_id)
    book = DB.exec("SELECT * FROM books WHERE id = #{book_id};").first
    if book != nil
      DB.exec("INSERT into books_patrons (book_id, patron_id) VALUES (#{book['id'].to_i}, #{@id});")
    else
      nil
    end
  end




end
